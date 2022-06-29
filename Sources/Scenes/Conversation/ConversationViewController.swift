//
//  ConversationViewController.swift
//  Desk360
//
//  Created by samet on 18.05.2019.
//

import UIKit
import Photos
import Moya

public protocol ConversationViewControllerCoinDelegate: AnyObject {
    
    /// message did send and return spent coin value
    /// - Parameter spentCoin: calculate spent coin with characterPerCoin and message character count
    func didMessageSent(spentCoin: Int)
    
    /// total coin balance not enough for message send
    func coinBalanceNotEnough()
    
    /// did tap Add Coin button, will open landing
    func didTapAddCoin()
    
    /// ticket created, ticketId and agentId will request to backend
    func didTicketCreated(agentId: Int, ticketId: Int)
}

public final class ConversationViewController: UIViewController, Layouting, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, UIScrollViewDelegate, UIDocumentBrowserViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIDocumentPickerDelegate {

    typealias ViewType = ConversationView

    var request: Ticket!
    public weak var delegate: ConversationViewControllerCoinDelegate?
    private var characterPerCoin: Int = 0
    private var totalCoin: Int = 0
    private var spentCoin: Int = 0
    private var name: String = ""
    private var email: String = ""
    private var message: String = ""

    private var isConfigure = false
    private var previousLineCount = 0
    private var currentLineCount = 0
    private var refreshIcon = UIImageView()
    private var aiv = UIActivityIndicatorView()
    private var isDragReleased = false

    convenience init(request: Ticket, characterPerCoin: Int = 0, totalCoin: Int = 0, name: String = "", email: String = "") {
        self.init()
        self.request = request
        self.characterPerCoin = characterPerCoin
        self.totalCoin = totalCoin
        self.name = name
        self.email = email

        layoutableView.chatInputView.setValues(characterPerCoin: self.characterPerCoin, totalCoin: self.totalCoin)
        layoutableView.chatInputView.delegate = self
    }

    public override func loadView() {
        view = ViewType.create()
    }

    public func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        scrollToBottom(animated: false)
        return false
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        registerForKeyboardEvents()
        layoutableView.titleLabel.text = request.agentName
        layoutableView.backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        layoutableView.tableView.addGestureRecognizer(tapGesture)
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Desk360.conVC = self
        setMessages()
        previousLineCount = 0
        currentLineCount = 0
        layoutableView.tableView.dataSource = self
        layoutableView.tableView.delegate = self

        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.interactivePopGestureRecognizer?.delegate = self

        configure()
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        layoutableView.setLoading(self.request.messages.isEmpty)
        readRequest(request)
        self.scrollToBottom(animated: true)
    }

    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    func refreshAction() {
        readRequest(request)
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Desk360.conVC = nil
        layoutableView.chatInputView.textView.resignFirstResponder()
        setRead()
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return request.messages.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = request.messages[indexPath.row]

        if !message.isAnswer {
            let cell = tableView.dequeueReusableCell(SenderMessageTableViewCell.self)
            cell.clearCell()
            cell.configure(for: request.messages[indexPath.row], hasAttach: false)
            return cell
        }
        let cell = tableView.dequeueReusableCell(ReceiverMessageTableViewCell.self)
        cell.clearCell()
        cell.configure(for: request.messages[indexPath.row], request.agentImage, indexPath, nil, hasAttach: false)
        return cell
    }
}

// MARK: - ConversationInputViewDelegate
extension ConversationViewController: InputViewDelegate {
    func inputView(_ view: InputView, didTapCreateRequestButton button: UIButton) {
    }

    func inputView(_ view: InputView, didTapSendButton button: UIButton, withText text: String, spentCoin: Int) {
        self.spentCoin = spentCoin

        if totalCoin == 0 || totalCoin < spentCoin {
            delegate?.coinBalanceNotEnough()
        } else {
            layoutableView.chatInputView.setLoading(true)
            if request.id == 0 {
                createTicket()
            } else {
                addMessage(text.condenseNewlines.condenseWhitespacs, to: request)
            }
        }
    }
    
    func inputViewDidTapAddCoin(_ view: InputView) {
        layoutableView.chatInputView.textView.resignFirstResponder()
        delegate?.didTapAddCoin()
    }
    
    func inputViewDidBegin() {
        scrollToBottom(animated: true)
    }
}

// MARK: - Networking
extension ConversationViewController {

    /// This method use is to get one ticket from the use id
    /// - Parameter request: this parameter is a ticket object we will use its id and we will use its properties
    func readRequest(_ request: Ticket) {
        guard request.id != 0 else {
            hidePDR()
            layoutableView.setLoading(false)
            return
        }

        guard Desk360.isReachable else {
            networkError()
            return
        }
        showPDR()
        Desk360.apiProvider.request(.ticketWithId(request.id)) { [weak self] result in
            guard let self = self else { return }
            self.hidePDR()
            self.layoutableView.setLoading(false)
            switch result {
            case .failure(let error):
                if error.response?.statusCode == 400 {
                    Desk360.isRegister = false
                    Alert.showAlertWithDismiss(viewController: self, title: "Desk360", message: "general.error.message".localize(), dissmis: true)
                    return
                }

            case .success(let response):
                guard let tickets = try? response.map(DataResponse<Ticket>.self) else { return }
                guard let data = tickets.data else { return }
                self.request = data
                let storedTickets = Stores.ticketWithMessageStore.allObjects() // fetch previously saved tickets from the local just before save new tickets
                try? Stores.ticketWithMessageStore.save(self.request)// save new tickets to the local.

                if let msg = self.request.messages.last {
                    let currentTicketWithMessage = storedTickets.filter({ $0.id == self.request.id })
                    if currentTicketWithMessage.count > 0 {
                        if let mesaj = currentTicketWithMessage[0].messages.last {
                            if msg.id == mesaj.id {
                                self.scrollToBottom(animated: false)
                                return // don't reload table to avoid performance issues
                            }
                        }
                    }
                }

                DispatchQueue.main.async {
                    self.layoutableView.tableView.reloadData()
                    self.scrollToBottom(animated: false)
                }
            }
        }
    }

    /// This method is used to send a request to backend for add a message in ticket
    /// - Parameters:
    ///   - message: this parameter is a user message
    ///   - request: this parameter is a ticket object
    func addMessage(_ message: String, to request: Ticket) {

        self.message = message
        self.layoutableView.chatInputView.reset(isClearText: true)
        guard Desk360.isReachable else {
            networkError()
            return
        }

        let id = (request.messages.last?.id ?? 0) + 1

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            self.appendMessage(message: Message(id: id, message: message, isAnswer: false, createdAt: formatter.string(from: Date())))
            self.scrollToBottom(animated: true)
        }
        var attach = [MultipartFormData]()
        let fieldData = MultipartFormData(provider: .data(message.data(using: .utf8)!), name: "message")
        attach.insert(fieldData, at: 0)

        Desk360.apiProvider.request(.ticketMessages(request.id, attach: attach)) { [weak self] result in
            guard let self = self else { return }
            self.layoutableView.chatInputView.setLoading(false)
            switch result {
            case .failure(let error):
                if error.response?.statusCode == 400 {
                    Desk360.isRegister = false
                    Alert.showAlertWithDismiss(viewController: self, title: "Desk360", message: "general.error.message".localize(), dissmis: true)
                    return
                }
            case .success(let data):
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.showActiveCheckMark()
                    self.scrollToBottom(animated: true)
                    self.delegate?.didMessageSent(spentCoin: self.spentCoin)
                }
                self.coinDecrement()
                self.layoutableView.chatInputView.clearText()
            }
            self.layoutableView.chatInputView.setLoading(false)
        }
    }
    
    
    func createTicket() {
        guard Desk360.isReachable else {
            networkError()
            return
        }
        
        var ticket = [MultipartFormData]()
        
        /// Name
        let nameData = name.data(using: String.Encoding.utf8) ?? Data()
        ticket.append(Moya.MultipartFormData(provider: .data(nameData), name: "name"))
        
        /// Email
        let emailData = email.data(using: String.Encoding.utf8) ?? Data()
        //Stores.userMail.object?.data(using: String.Encoding.utf8) ?? Data()
        ticket.append(Moya.MultipartFormData(provider: .data(emailData), name: "email"))
        
        ///  Type id
        let typeData = "5".data(using: String.Encoding.utf8) ?? Data()
        ticket.append(Moya.MultipartFormData(provider: .data(typeData), name: "type_id"))
        
        // Message
        let messageData = layoutableView.chatInputView.textView.text.data(using: String.Encoding.utf8) ?? Data()
        ticket.append(Moya.MultipartFormData(provider: .data(messageData), name: "message"))
        
        // Assign to
        let assignToData = String(request.agentId ?? 0).data(using: String.Encoding.utf8) ?? Data()
        ticket.append(Moya.MultipartFormData(provider: .data(assignToData), name: "assign_to"))
        
        guard let props = Desk360.properties else {
            Alert.showAlertWithDismiss(viewController: self, title: "Desk360", message: "general.error.message".localize(), dissmis: true)
            return
        }

        let sourceData = "App".data(using: String.Encoding.utf8) ?? Data()
        ticket.append(Moya.MultipartFormData(provider: .data(sourceData), name: "source"))

        let platformData = props.appPlatform.data(using: String.Encoding.utf8) ?? Data()
        ticket.append(Moya.MultipartFormData(provider: .data(platformData), name: "platform"))

        let countryCodeData = props.country.data(using: String.Encoding.utf8) ?? Data()
        ticket.append(Moya.MultipartFormData(provider: .data(countryCodeData), name: "country_code"))

        if let json = props.jsonInfo, let jsonData = try? JSONSerialization.data(withJSONObject: json) {
            ticket.append(Moya.MultipartFormData(provider: .data(jsonData), name: "settings"))
        }

        if let pushTokenString = Desk360.pushToken {
            let pushTokenData = pushTokenString.data(using: String.Encoding.utf8) ?? Data()
            ticket.append(Moya.MultipartFormData(provider: .data(pushTokenData), name: "push_token"))
        }

        self.layoutableView.setLoading(true)
        Desk360.apiProvider.request(.create(ticket: ticket)) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .failure(let error):
                self.layoutableView.setLoading(false)
                print(error.localizedServerDescription)
                if error.response?.statusCode == 400 {
                    Desk360.isRegister = false
                    Alert.showAlertWithDismiss(viewController: self, title: "Desk360", message: "general.error.message".localize(), dissmis: true)
                    return
                }
            case .success(let response):
                guard let tickets = try? response.map(DataResponse<NewTicket>.self) else { return }
                guard let data = tickets.data else { return }
                self.request.id = data.id
                self.delegate?.didTicketCreated(agentId: self.request.agentId ?? 0, ticketId: self.request.id)
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                    self.readRequest(self.request)
                }
                self.layoutableView.chatInputView.clearText()
                self.coinDecrement()
            }
        }
    }
}

// MARK: - Helpers
private extension ConversationViewController {
    /// This method is used to  a add a message in ticket
    /// - Parameter message: this parameter is a user message
    func appendMessage(message: Message) {
        var msgObject = message
        self.request.messages.append(msgObject)
        try? Stores.ticketWithMessageStore.save(self.request)

        self.layoutableView.tableView.beginUpdates()
        let indexPath = IndexPath(row: self.request.messages.count - 1, section: 0)
        self.layoutableView.tableView.insertRows(at: [indexPath], with: .top)
        self.layoutableView.tableView.endUpdates()

        try? Stores.ticketsStore.save(self.request)
    }

    /// This method is used to scroll to tableview bottom
    /// - Parameter animated:this parameter is used  to scroll animation
    func scrollToBottom(animated: Bool) {
        let row = request.messages.count - 1
        guard row >= 0 else { return }
        if Desk360.conVC == nil { return }
        let lastIndexPath = IndexPath(row: row, section: 0)
        guard layoutableView.tableView.isValid(indexPath: lastIndexPath) else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.layoutableView.tableView.scrollToRow(at: lastIndexPath, at: .bottom, animated: animated)
            })
    }

    func showActiveCheckMark() {
        let indexPath = IndexPath(row: request.messages.count - 1, section: 0)
        guard let cell = layoutableView.tableView.cellForRow(at: indexPath) else { return }
        guard layoutableView.tableView.isValid(indexPath: indexPath) else { return }
        layoutableView.tableView.reloadRows(at: [indexPath], with: .none)
    }

    func networkError() {
        layoutableView.setLoading(false)

        let cancel = "cancel.button".localize()
        let tryAgain = "try.again.button".localize()

        Alert.shared.showAlert(viewController: self, withType: .info, title: "Desk360", message: "connection.error.message".localize(), buttons: [cancel, tryAgain], dismissAfter: 0.1) { [weak self] value in
            guard let self = self else { return }
            if value == 2 {
                self.addMessage(self.message, to: self.request)
            }
        }
    }
}

extension UITableView {
    func isValid(indexPath: IndexPath) -> Bool {
        guard indexPath.section < numberOfSections,
            indexPath.row < numberOfRows(inSection: indexPath.section)
            else { return false }
        return true
    }
}

// MARK: - Actions
extension ConversationViewController {
    func setMessages() {
        let tickets = Stores.ticketWithMessageStore.allObjects()
        let currentTicketWithMessage = tickets.filter({ $0.id == self.request.id })
        guard currentTicketWithMessage.count > 0 else { return }
        self.request.messages = currentTicketWithMessage.first?.messages ?? []
        layoutableView.tableView.reloadData()
        scrollToBottom(animated: false)
    }

    func setRead() {
        let id = request.id
        let tickets = Stores.ticketsStore.allObjects().sorted()

        for ticket in tickets {
            var currentTicket = ticket
            if ticket.id == id {
                if ticket.status == .unread {
                    currentTicket.status = .read
                }
                currentTicket.messages = self.request.messages
                if message != "" {
                    currentTicket.message = message
                }
                try? Stores.ticketsStore.save(currentTicket)
            }
        }
    }
}

// MARK: - Actions
extension ConversationViewController {
    /// This method is used to pop action on navigationcontroller
    @objc func didTapBackButton() {
        layoutableView.chatInputView.textView.resignFirstResponder()
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Configure
extension ConversationViewController {
    func configure() {
        let fontWeight = Font.weight(type: Config.shared.model?.generalSettings?.navigationTitleFontWeight ?? 400)
        let fontSize = CGFloat(Config.shared.model?.generalSettings?.navigationTitleFontSize ?? 16)
        let font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
        let selectedattributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: font, NSAttributedString.Key.shadow: NSShadow()]
        let navigationTitle = NSAttributedString(string: Config.shared.model?.ticketDetail?.title ?? "", attributes: selectedattributes as [NSAttributedString.Key: Any])
        let titleLabel = UILabel()
        titleLabel.attributedText = navigationTitle
        titleLabel.sizeToFit()
        titleLabel.textAlignment = .center
        titleLabel.textColor = Colors.navigationTextColor
        navigationItem.titleView = titleLabel

        navigationItem.title = Config.shared.model?.ticketDetail?.title
        self.navigationController?.navigationBar.setColors(background: Colors.navigationBackgroundColor, text: Colors.navigationTextColor)
        navigationController?.navigationBar.tintColor = Colors.navigationImageViewTintColor
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        layoutableView.configure()
        aiv.removeFromSuperview()
        aiv = UIActivityIndicatorView(style: .gray)
        aiv.color = Colors.pdrColor
        aiv.frame.size.height = 20
        refreshIcon = UIImageView(image: Desk360.Config.Images.arrowDownIcon)
        let view = UIView(frame: CGRect(x: (UIScreen.main.bounds.size.width / 2) - 17, y: 0, width: 34, height: 20))
        view.backgroundColor = layoutableView.tableView.backgroundColor
        refreshIcon.frame = CGRect(x: (view.frame.size.width / 2) - 7, y: 0, width: 14, height: 19)
        refreshIcon.backgroundColor = layoutableView.tableView.backgroundColor
        refreshIcon.isHidden = true
        aiv.hidesWhenStopped = false
        view.addSubview(refreshIcon)
        aiv.addSubview(view)
        layoutableView.tableView.tableHeaderView = aiv
        layoutableView.chatInputView.sendButton.isHidden = false
    }

    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if aiv.isAnimating == false {
            hidePDR()
        }
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if aiv.isAnimating == false {
            hidePDR()
        }
    }

    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isDragReleased = false
        refreshIcon.isHidden = false
        if aiv.isAnimating {
            return
        }
    }

    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        isDragReleased = true
        if aiv.isAnimating == false {
            hidePDR()
        }
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if aiv.isAnimating {
            return
        }
        if scrollView.contentOffset.y >= 0 {
            hidePDR()
            return
        }

        if scrollView.contentOffset.y < -23 { // arrow starting to show down direction
            if isDragReleased {
                return
            }

            refreshIcon.isHidden = false
            self.refreshIcon.superview!.isHidden = false
            aiv.hidesWhenStopped = false
            self.aiv.stopAnimating()
        }
        if scrollView.contentOffset.y < -65 { // arrow will turn up
            var val = 0.0

            UIView.animate(withDuration: 0.1, animations: {
                self.aiv.startAnimating()
                self.refreshIcon.transform = CGAffineTransform(rotationAngle: .pi)

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.refreshIcon.isHidden = true
                    self.refreshIcon.superview!.isHidden = true
                    self.aiv.hidesWhenStopped = false
                    self.refreshAction()
                }
            })
            return
        }
    }

    func hidePDR() {
        refreshIcon.isHidden = true
        self.refreshIcon.superview!.isHidden = true
        aiv.hidesWhenStopped = true
        self.aiv.stopAnimating()
        self.refreshIcon.transform = CGAffineTransform(rotationAngle: 0)
    }

    func showPDR() {
        refreshIcon.isHidden = true
        self.refreshIcon.superview!.isHidden = true
        aiv.hidesWhenStopped = false
        self.aiv.startAnimating()
    }
}

// MARK: - KeyboardObserving
extension ConversationViewController: KeyboardObserving {
    public func keyboardWillShow(_ notification: KeyboardNotification?) { }

    public func keyboardWillHide(_ notification: KeyboardNotification?) {
    }

    public func keyboardDidHide(_ notification: KeyboardNotification?) { }

    public func keyboardDidShow(_ notification: KeyboardNotification?) { }

    public func keyboardWillChangeFrame(_ notification: KeyboardNotification?) {
    }

    public func keyboardDidChangeFrame(_ notification: KeyboardNotification?) { }
}

extension String {
    func size(constraintedWidth width: CGFloat, font: UIFont = .systemFont(ofSize: 14)) -> CGSize {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.text = self
        label.font = font
        label.lineBreakMode = .byWordWrapping
        label.sizeToFit()
        return label.frame.size
    }
}

extension ConversationViewController {
    @objc private func tableViewTapped() {
        layoutableView.chatInputView.textView.resignFirstResponder()
    }
    
    private func coinDecrement() {
        totalCoin -= spentCoin
        layoutableView.chatInputView.setValues(characterPerCoin: characterPerCoin, totalCoin: totalCoin)
    }
}
