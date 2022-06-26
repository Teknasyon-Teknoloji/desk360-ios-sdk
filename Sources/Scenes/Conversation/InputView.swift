//
//  InputView.swift
//  Desk360
//
//  Created by samet on 18.05.2019.
//

import UIKit
import ISEmojiView

protocol InputViewDelegate: AnyObject {
    func inputView(_ view: InputView, didTapSendButton button: UIButton, withText text: String)
    func inputView(_ view: InputView, didTapAttachButton button: UIButton)
    func inputView(_ view: InputView, didTapCreateRequestButton button: UIButton)
}

class InputView: UIView, Layoutable {
    weak var delegate: InputViewDelegate?

    private var hasAttachView: Bool = false
    private var characterPerCoin: Int = 0
    private var totalCoin: Int = 0
    private var coinCounter: Int = 0
    private var characterCounter: Int = 0

    private lazy var messageInputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.addSubview(inputTopView)
        view.addSubview(textViewContainerView)
        view.addSubview(sendButton)
        return view
    }()

    private lazy var inputTopView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.paleLilac
        return view
    }()

    private lazy var textViewContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.grayInput
        view.setBorder(width: 1, color: Colors.paleLilac, radius: 20)
        view.addSubview(textView)
        view.addSubview(emojiButton)
        return view
    }()

    lazy var textView: GrowingTextView = {
        var view = GrowingTextView()
        view.textColor = Colors.ticketDetailWriteMessageTextColor
        view.tintColor = Colors.ticketDetailWriteMessageTextColor
        view.placeholderColor = Colors.writeMessagePHTextColor
        view.placeholder = Config.shared.model?.ticketDetail?.writeMessagePlaceHolderText
        view.font = Fonts.Montserrat.regular.font(size: 14)
        view.textAlignment = UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft ? .right : .left
        view.autocorrectionType = .no
        return view
    }()

    private lazy var emojiButton: UIButton = {
        let button = UIButton()
        button.setImage(Desk360.Config.Images.emojiIcon, for: .normal)
        return button
    }()

    lazy var sendButton: UIButton = {
        let button = UIButton()
        button.setImage(Desk360.Config.Images.sendIcon, for: .normal)
        return button
    }()

    private lazy var coinBarView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.backgroundColor = Colors.crayola
        view.addSubview(spentCoinValue)
        view.addSubview(spentCharacterValue)
        view.addSubview(addCoinView)
        return view
    }()

    private lazy var spentCoinValue: UILabel = {
        let label = UILabel()
        label.text = String(format: Desk360.properties?.coinCountText ?? "", coinCounter)
        label.textColor = .white
        label.font = Fonts.Montserrat.semiBold.font(size: 14)
        return label
    }()

    private lazy var spentCharacterValue: UILabel = {
        let label = UILabel()
        label.text = String(format: Desk360.properties?.characterCountText ?? "", characterCounter)
        label.textColor = Colors.paleLilac
        label.font = Fonts.Montserrat.regular.font(size: 14)
        return label
    }()

    private lazy var totalCoinValue: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = Fonts.Montserrat.semiBold.font(size: 18)
        return label
    }()

    private lazy var addCoinImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Desk360.Config.Images.addCoinIcon
        return imageView
    }()

    private lazy var addCoinView: UIView = {
        let view = UIView()
        view.addSubview(totalCoinValue)
        view.addSubview(addCoinImageView)
        return view
    }()

    private lazy var emojiView: EmojiView = {
        let settings = KeyboardSettings(bottomType: .categories)
        settings.needToShowAbcButton = true
        settings.updateRecentEmojiImmediately = false

        let emojiView = EmojiView(keyboardSettings: settings)
        return emojiView
    }()

    lazy var attachButton = UIButton()

    override var intrinsicContentSize: CGSize {
        let height: CGFloat = 96
        return CGSize(width: UIView.noIntrinsicMetric, height: height)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupViews()
        setupLayout()
    }

    func setupViews() {
        backgroundColor = .clear
        addSubview(messageInputContainerView)
        addSubview(coinBarView)

        textView.delegate = self
        emojiView.delegate = self
        sendButton.isEnabled = textView.text.condenseNewlines.condenseNewlines.isEmpty == false
        sendButton.addTarget(self, action: #selector(didTapSendButton(_:)), for: .touchUpInside)
        emojiButton.addTarget(self, action: #selector(didTapEmojiButton(_:)), for: .touchUpInside)
    }

    func setupLayout() {
        messageInputContainerView.snp.makeConstraints { make in
            make.top.equalTo(coinBarView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }

        inputTopView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }

        textViewContainerView.snp.makeConstraints { make in
            make.top.equalTo(inputTopView.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(10)
            make.height.equalTo(40)
        }

        textView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
            make.height.equalTo(40)
        }

        sendButton.snp.makeConstraints { make in
            make.width.height.equalTo(36)
            make.centerY.equalTo(textViewContainerView.snp.centerY)
            make.leading.equalTo(textViewContainerView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(12)
        }

        emojiButton.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.centerY.equalTo(textViewContainerView.snp.centerY)
            make.leading.equalTo(textView.snp.trailing).offset(10)
            make.trailing.equalTo(textViewContainerView.snp.trailing).inset(10)
        }

        coinBarView.snp.makeConstraints { make in
            make.height.equalTo(36)
            make.top.leading.trailing.equalToSuperview()
        }

        spentCoinValue.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(14)
            make.top.bottom.equalToSuperview()
        }

        spentCharacterValue.snp.makeConstraints { make in
            make.leading.equalTo(spentCoinValue.snp.trailing).offset(5)
            make.top.bottom.equalToSuperview()
        }

        addCoinView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(18)
            make.top.bottom.equalToSuperview()
        }

        addCoinImageView.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.leading.equalTo(totalCoinValue.snp.trailing).offset(5)
        }

        totalCoinValue.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview()
        }
    }

    func reset(isClearText: Bool = true) {

        DispatchQueue.main.async {
            // self.setLoading(false)
            if isClearText {
                self.textView.text = ""
            }
            self.sendButton.isEnabled = false
//            self.attachmentView.clear()
        }
    }

    func resetAttachView() {
        reset(isClearText: false)
        self.hasAttachView = false
    }

    func setValues(characterPerCoin: Int, totalCoin: Int) {
        self.characterPerCoin = characterPerCoin
        self.totalCoin = totalCoin
        totalCoinValue.text = String(self.totalCoin)
    }

    private func calculateWithMessageText() {
        guard let text = textView.text else { return }

        if text.isEmpty {
            coinCounter = 0
        } else {
            coinCounter = characterPerCoin == 0 ? 0 : (text.count / characterPerCoin) + (text.count % characterPerCoin == 0 ? 0 : 1)
        }
        characterCounter = text.count

        spentCoinValue.text = String(format: Desk360.properties?.coinCountText ?? "", coinCounter)
        spentCharacterValue.text = String(format: Desk360.properties?.characterCountText ?? "", characterCounter)
    }
}

// MARK: - Loadingable
extension InputView: Loadingable {
    func setLoading(_ loading: Bool) {
        if loading {
            textView.resignFirstResponder()
        }

//        loading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        sendButton.isHidden = loading
        textView.isUserInteractionEnabled = !loading
        setSendButton()
    }
}

// MARK: - UITextViewDelegate
extension InputView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        setSendButton()
        calculateWithMessageText()
    }

    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        coinBarView.isHidden = false
        return true
    }

    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        coinBarView.isHidden = true
        return true
    }

    func setSendButton() {
        sendButton.isEnabled = textView.text.condenseNewlines.condenseWhitespacs.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false
    }
}

// MARK: - Actions
private extension InputView {
    @objc
    func didTapSendButton(_ button: UIButton) {
        guard let text = textView.trimmedText else { return }
        delegate?.inputView(self, didTapSendButton: button, withText: text)
    }

    @objc
    func didTapAttachButton(_ button: UIButton) {
        delegate?.inputView(self, didTapAttachButton: button)
    }

    @objc
    func didTapCreateRequestButton(_ button: UIButton) {
        delegate?.inputView(self, didTapCreateRequestButton: button)
    }

    @objc
    func didTapEmojiButton(_ button: UIButton) {
        
    }
}

extension InputView: EmojiViewDelegate {
    func emojiViewDidSelectEmoji(_ emoji: String, emojiView: EmojiView) {
        textView.insertText(emoji)
    }
}
