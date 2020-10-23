//
//  ReceiverMessageTableViewCell.swift
//  Desk360
//
//  Created by samet on 18.05.2019.
//

import UIKit
import PDFKit
import Alamofire
import AVFoundation
import MediaPlayer
import AVKit

final class ReceiverMessageTableViewCell: UITableViewCell, Layoutable, Reusable {

	override var isSelected: Bool {
		didSet {
			checkMark.image = isSelected ? Desk360.Config.Images.checkMarkActive : Desk360.Config.Images.checkMarkPassive
			checkMark.tintColor = Colors.ticketDetailWriteMessageButtonIconDisableColor
		}
	}

	lazy var videoView: VideoView = {
		return VideoView()
	}()

	lazy var playButton: UIButton = {
		let button = UIButton()
		button.setImage(Desk360.Config.Images.playIcon, for: .normal)
		button.setImage(Desk360.Config.Images.pauseIcon, for: .selected)
		return button
	}()

	private lazy var containerView: UIView = {
		var view = UIView()
		view.clipsToBounds = true
		view.addSubview(checkMark)
		return view
	}()

	private lazy var messageTextView: UITextView = {
		let textView = UITextView()
		textView.isEditable = false
		textView.isScrollEnabled = false
		textView.allowsEditingTextAttributes = false
		textView.dataDetectorTypes = .link
		textView.font = Desk360.Config.Conversation.MessageCell.Receiver.messageFont
		textView.backgroundColor = .clear
		return textView
	}()

	private lazy var dateLabel: UILabel = {
		let label = UILabel()
		label.font = Desk360.Config.Conversation.MessageCell.Receiver.dateFont
		label.textAlignment = .right
		return label
	}()

	private lazy var stackView: UIStackView = {
		let view = UIStackView(arrangedSubviews: [messageTextView])
		view.axis = .vertical
		view.alignment = .fill
		view.distribution = .fill
		view.spacing = preferredSpacing * 0.5
		return view
	}()

	lazy var previewImageView: UIView = {
		let imageView = UIView()
		return imageView
	}()

	lazy var checkMark: UIImageView = {
		let imageView = UIImageView()
		imageView.image = Desk360.Config.Images.checkMarkActive
		imageView.contentMode = .scaleAspectFit
		return imageView
	}()

	lazy var previewVideoView: UIView = {
		let view = UIView()
		return view
	}()

    lazy var previewPdfView: UIView = {
        let view = UIView()
        return view
    }()

	@available(iOS 11.0, *)
	lazy var pdfView: PDFView = {
		let pdfView = PDFView()
		return pdfView
	}()

	private var containerBackgroundColor: UIColor? {
		didSet {
			containerView.backgroundColor = containerBackgroundColor
			messageTextView.backgroundColor = containerBackgroundColor
			dateLabel.backgroundColor = containerBackgroundColor
		}
	}

	func setupViews() {
		backgroundColor = .clear
		selectionStyle = .none

		containerView.addSubview(stackView)
		addSubview(containerView)
		addSubview(dateLabel)
	}

	func setupLayout() {

		containerView.snp.makeConstraints { make in
			make.top.trailing.equalToSuperview().inset(preferredSpacing / 2)
			make.width.equalTo(UIScreen.main.bounds.size.minDimension - (preferredSpacing * 2))
		}
		
		stackView.snp.makeConstraints { $0.edges.equalToSuperview().inset(preferredSpacing / 2) }

		checkMark.snp.makeConstraints { make in
			make.trailing.equalToSuperview().inset(preferredSpacing * 0.5)
			make.bottom.equalToSuperview().inset(preferredSpacing)
		}

		dateLabel.snp.makeConstraints { make in
			make.trailing.equalTo(containerView.snp.trailing).offset(-preferredSpacing * 0.5)
			make.top.equalTo(containerView.snp.bottom).offset(preferredSpacing * 0.25)
			make.bottom.equalToSuperview().inset(preferredSpacing * 0.25)
			make.height.equalTo(preferredSpacing)
		}
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		roundCorner()

	}
    
    func clearCell() {
        previewImageView.isHidden = true
        previewVideoView.isHidden = true
        previewPdfView.isHidden = true
    }
}

// MARK: - Configure
internal extension ReceiverMessageTableViewCell {

	func configure(for request: Message, _ indexPath: IndexPath, _ attachment: URL? = nil, hasAttach: Bool = false) {
        if Desk360.conVC == nil { return }
        
		containerView.backgroundColor = Colors.ticketDetailChatReceiverBackgroundColor
		messageTextView.text = request.message
		messageTextView.textColor = Colors.ticketDetailChatReceiverTextColor
		messageTextView.font = UIFont.systemFont(ofSize: CGFloat(Config.shared.model?.ticketDetail?.chatReceiverFontSize ?? 18), weight: Font.weight(type: Config.shared.model?.ticketDetail?.chatReceiverFontWeight ?? 400))
		dateLabel.textColor = Colors.ticketDetailChatChatReceiverDateColor
        
        if let dateString = request.createdAt {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            if let date = formatter.date(from: dateString) {
                let formattedDate = DateFormat.raadable.dateFormatter.string(from: date)
                dateLabel.text = formattedDate
            } else {
                dateLabel.text = dateString
            }
        }

		if stackView.arrangedSubviews.count > 1 {
			stackView.removeArrangedSubview(stackView.arrangedSubviews[1])
		}
		previewImageView.isHidden = true
		previewVideoView.isHidden = true
		if #available(iOS 11.0, *) {
			pdfView.isHidden = true
		}

        if hasAttach == false { //hasAttach flag is holds is there attachments sent from messages not ticket creation.
            if let attachmentUrl = attachment { // function's attachment parameter is holds, ticket creation attachment.
                guard indexPath.row == 0 else { return } //ticket attachments will allways at zero row, so if not we can return.
                checkFile(attachmentUrl, fileName: "", i: 1, fileInx: 1)
                return
            }
        }
        if hasAttach == false { return }
        
        var fileInx = 1
        if let images = request.attachments?.images {
            let val = images.filter({$0 != nil })
            var i = 1
            if val.count > 0 { fileInx = fileInx + 1 }
            for image in val {
                if let url = URL(string: image.url) {
                    self.checkFile(url, fileName: image.name, i: i, fileInx: fileInx)
                }
                i = i + 1
            }
        }
        if let videos = request.attachments?.videos {
            let val = videos.filter({$0 != nil })
            var i = 1
            if val.count > 0 { fileInx = fileInx + 1 }
            for video in val {
                if let url = URL(string: video.url) {
                    self.checkFile(url, fileName: video.name, i: i, fileInx: fileInx)
                }
                i = i + 1
            }
        }
        if let files = request.attachments?.files {
            let val = files.filter({$0 != nil })
            var i = 1
            if val.count > 0 { fileInx = fileInx + 1 }
            for file in val {
                if let url = URL(string: file.url) {
                    self.checkFile(url, fileName: file.name, i: i, fileInx: fileInx)
                }
                i = i + 1
            }
        }
        if let otherFiles = request.attachments?.others {
            let val = otherFiles.filter({$0 != nil })
            var i = 1
            if val.count > 0 { fileInx = fileInx + 1 }
            for otherFile in val {
                if let url = URL(string: otherFile.url) {
                    self.checkFile(url, fileName: otherFile.name, i: i, fileInx: fileInx)
                }
                i = i + 1
            }
        }
	}

    func checkFile(_ url: URL, fileName: String, i: Int = 1, fileInx: Int) {

        if Desk360.conVC == nil { return }
        guard let path = url.pathComponents.last else { return }
        let words = path.split(separator: ".")
        guard var word = words.last?.lowercased() else { return }
        if word == "pdf" {
            self.addPdf(url, fileName: fileName, inx: i, fileInx: fileInx)
        } else if word == "png" || word == "jpeg" || word == "jpg" {
            self.addImageView(url, fileExt: String(word), fileName: fileName, inx: i, fileInx: fileInx)
        } else if word == "avi" || word == "mkv" || word == "mov" || word == "wmv" || word == "mp4" || word == "3gp" {
            if word == "mkv" || word == "wmv" || word == "3gp" { word = "mp4" }
            self.addVideoView(url, fileExt: String(word), fileName: fileName, inx: i, fileInx: fileInx)
        }
    }
    
    func addVideoView(_ url: URL, fileExt: String, fileName: String, inx: Int, fileInx: Int) {
        if Desk360.conVC == nil { return }

        self.previewVideoView.isHidden = false
        if inx == 1 {
            previewVideoView.subviews.map({$0.removeFromSuperview()})
        }
        self.stackView.addArrangedSubview(self.previewVideoView)
        self.previewVideoView.snp.remakeConstraints { remake in
            remake.leading.trailing.equalToSuperview()
            remake.height.equalTo(self.previewVideoView.snp.width).multipliedBy(inx).offset(4 * inx)
        }

        let videoView = PlayerView()
        videoView.tag = inx
        self.previewVideoView.addSubview(videoView)
        
        let playButton = UIButton()
        playButton.titleLabel?.tag = inx
        playButton.setImage(Desk360.Config.Images.playIcon, for: .normal)
        playButton.setImage(Desk360.Config.Images.pauseIcon, for: .selected)

        self.previewVideoView.addSubview(playButton)

        playButton.snp.makeConstraints { make in
            make.center.equalTo(videoView)
            make.width.height.equalTo(self.preferredSpacing * 2)
        }

        playButton.addTarget(self, action: #selector(self.didTapPlayButton(sender:)), for: .touchUpInside)
        playButton.tintColor = Colors.ticketDetailWriteMessageButtonIconColor
        
        videoView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(previewVideoView.snp.width)
            if inx == 1 {
                make.top.equalToSuperview()
            } else {
                make.top.equalTo(previewVideoView.viewWithTag(inx - 1)!.snp.bottom).offset(4)
            }
        }

        let avPlayer = AVPlayer(url: url);
        videoView.playerLayer.player = avPlayer;
	}

    func addImageView(_ url: URL, fileExt: String, fileName: String, inx: Int, fileInx: Int) {

        if Desk360.conVC == nil { return }

        if inx == 1 {
            previewImageView.subviews.map({$0.removeFromSuperview()})
        }
        self.stackView.addArrangedSubview(self.previewImageView)
        self.previewImageView.snp.remakeConstraints { remake in
            remake.leading.trailing.equalToSuperview()
            remake.height.equalTo(self.previewImageView.snp.width).multipliedBy(inx).offset(4 * inx)
        }
        let imgView = UIImageView()
        imgView.tag = inx
        imgView.clipsToBounds = true
        imgView.contentMode = .scaleAspectFill
        previewImageView.addSubview(imgView)
        imgView.snp.makeConstraints { remake in
            remake.leading.trailing.equalToSuperview()
            remake.height.equalTo(previewImageView.snp.width)
            if inx == 1 {
                remake.top.equalToSuperview()
            } else {
                remake.top.equalTo(previewImageView.viewWithTag(inx - 1)!.snp.bottom).offset(4)
            }
        }
        imageFromUrl(url: url) { (image) in
            imgView.image = image
        }
        
        self.previewImageView.isHidden = false
	}
    
    func addPdf(_ url: URL, fileName: String, inx: Int, fileInx: Int) {
        guard #available(iOS 11.0, *) else { return }

        if Desk360.conVC == nil { return }
        
        if inx == 1 {
            previewPdfView.subviews.map({$0.removeFromSuperview()})
        }
        self.stackView.addArrangedSubview(self.previewPdfView)
        self.previewPdfView.snp.remakeConstraints { remake in
            remake.leading.trailing.equalToSuperview()
            remake.height.equalTo(self.previewPdfView.snp.width).multipliedBy(inx).offset(4 * inx)
        }
        
        let pdfView = PDFView()
        pdfView.tag = inx
        previewPdfView.addSubview(pdfView)
        pdfView.snp.makeConstraints { remake in
            remake.leading.trailing.equalToSuperview()
            remake.height.equalTo(previewPdfView.snp.width)
            if inx == 1 {
                remake.top.equalToSuperview()
            } else {
                remake.top.equalTo(previewPdfView.viewWithTag(inx - 1)!.snp.bottom).offset(4)
            }
        }
        
        self.previewPdfView.isHidden = false
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        guard let document = PDFDocument(url: url) else { return }
        pdfView.document = document
    }
    
    @objc func didTapPlayButton(sender: UIButton) {
        if sender == nil {
            playButton.isSelected = !playButton.isSelected
            guard playButton.isSelected else {
                videoView.player?.pause()
                return
            }
            videoView.player?.play()
            return
        }
        if Desk360.conVC == nil { return }
        sender.isSelected = !sender.isSelected
        let v = sender.superview?.viewWithTag(sender.titleLabel?.tag ?? 0) as! PlayerView
        guard sender.isSelected else {
            if v != nil {
                v.player?.pause()
            }
            return
        }
        if v != nil {
            v.player?.play()
        }
	}

	func getThumbnailImageFromVideoUrl(url: URL, completion: @escaping ((_ image: UIImage?) -> Void)) {
		DispatchQueue.global().async { //1
			let asset = AVAsset(url: url) //2
			let avAssetImageGenerator = AVAssetImageGenerator(asset: asset) //3
			avAssetImageGenerator.appliesPreferredTrackTransform = true //4
			let thumnailTime = CMTimeMake(value: 50, timescale: 5) //5
			do {
				let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumnailTime, actualTime: nil) //6
				let thumbImage = UIImage(cgImage: cgThumbImage) //7
				DispatchQueue.main.async { //8
					completion(thumbImage) //9
				}
			} catch {
				print(error.localizedDescription) //10
				DispatchQueue.main.async {
					completion(nil) //11
				}
			}
		}
	}

    func imageFromUrl(url: URL, completion: @escaping ((_ image: UIImage?) -> Void))  {
        if Desk360.isUrlLocal(url) {
            if let data = try? Data(contentsOf: url) {
                let img = UIImage(data: data)
                completion(img)
                return
            }
        }
        let request = URLRequest(url: url as URL)
        let task = URLSession.shared.dataTask(with: request) { (data, _, _) in
            if let imageData = data {
                DispatchQueue.main.async {
                    completion(UIImage(data: imageData))
                }
            }
        }
        task.resume()
    }
    
	func addPdf(_ url: URL) {
		guard #available(iOS 11.0, *) else { return }
		pdfView.translatesAutoresizingMaskIntoConstraints = false
		pdfView.isHidden = false
		stackView.addArrangedSubview(pdfView)

		pdfView.snp.remakeConstraints { remake  in
			remake.leading.trailing.equalToSuperview()
			remake.height.equalTo(pdfView.snp.width)
		}

		guard let document = PDFDocument(url: url) else { return }
		pdfView.document = document

	}

	func roundCorner() {
		let type = Config.shared.model?.ticketDetail?.chatBoxStyle

		let containerShadowIsHidden = Config.shared.model?.ticketDetail?.chatReceiverShadowIsHidden ?? true

		switch type {
		case 1:
			containerView.roundCorners([.bottomLeft, .bottomRight, .topLeft], radius: 10, isShadow: !containerShadowIsHidden)
		case 2:
			containerView.roundCorners([.bottomLeft, .bottomRight, .topLeft], radius: 30, isShadow: !containerShadowIsHidden)
		case 3:
			containerView.roundCorners([.bottomLeft, .bottomRight, .topLeft], radius: 19, isShadow: !containerShadowIsHidden)
		case 4:
			containerView.layer.cornerRadius = 0
			addSubLayerChatBubble()
			containerBackgroundColor = .clear
		default:
			containerView.roundCorners([.bottomLeft, .bottomRight, .topLeft], radius: 10, isShadow: !containerShadowIsHidden)
		}

		if containerShadowIsHidden {
			containerView.layer.shadowColor = UIColor.black.cgColor
			containerView.layer.shadowOffset = CGSize.zero
			containerView.layer.shadowRadius = 10
			containerView.layer.shadowOpacity = 0.3
			containerView.layer.masksToBounds = false
		}

	}

	func addSubLayerChatBubble() {

		let width = containerView.frame.width
		let height = containerView.frame.height

		let bezierPath = UIBezierPath()
		bezierPath.move(to: CGPoint(x: width - 4, y: height))
		bezierPath.addLine(to: CGPoint(x: 4, y: height))
		bezierPath.addCurve(to: CGPoint(x: 0, y: height - 4), controlPoint1: CGPoint(x: 2, y: height), controlPoint2: CGPoint(x: 0, y: height - 2))
		bezierPath.addLine(to: CGPoint(x: 0, y: 4))
		bezierPath.addCurve(to: CGPoint(x: 4, y: 0), controlPoint1: CGPoint(x: 0, y: 2), controlPoint2: CGPoint(x: 2, y: 0))
		bezierPath.addLine(to: CGPoint(x: width - 16, y: 0))
		bezierPath.addCurve(to: CGPoint(x: width - 12, y: 4), controlPoint1: CGPoint(x: width - 14, y: 0), controlPoint2: CGPoint(x: width - 12, y: 2))
		bezierPath.addLine(to: CGPoint(x: width - 12, y: height - 8))
		bezierPath.addLine(to: CGPoint(x: width, y: height))
		bezierPath.addLine(to: CGPoint(x: width - 4, y: height))

		let outgoingMessageLayer = CAShapeLayer()
		outgoingMessageLayer.path = bezierPath.cgPath
		outgoingMessageLayer.frame = CGRect(x: 0,
											   y: 0,
											   width: width,
											   height: height)
		outgoingMessageLayer.fillColor = Colors.ticketDetailChatReceiverBackgroundColor.cgColor

		if let layers = containerView.layer.sublayers {
			for layer in layers where layer is CAShapeLayer {
				layer.removeFromSuperlayer()
			}
		}

		containerView.layer.insertSublayer(outgoingMessageLayer, below: stackView.layer)
		containerView.clipsToBounds = false
	}

}
