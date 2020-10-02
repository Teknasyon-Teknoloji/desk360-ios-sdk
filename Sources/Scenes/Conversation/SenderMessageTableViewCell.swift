//
//  SenderMessageTableViewCell.swift
//  Desk360
//
//  Created by samet on 18.05.2019.
//

import UIKit
import PDFKit
import AVFoundation
import MediaPlayer
import AVKit

final class SenderMessageTableViewCell: UITableViewCell, Reusable, Layoutable {

    private lazy var containerView: UIView = {
        var view = UIView()
        view.clipsToBounds = true
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
        label.font = Desk360.Config.Conversation.MessageCell.Sender.dateFont
        label.textAlignment = .right
        return label
    }()

    private lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [messageTextView ])
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fill
        view.spacing = preferredSpacing * 0.5
        return view
    }()
    
    lazy var videoView: PlayerView = {
        return PlayerView()
    }()

    lazy var cellImageView: UIImageView = {
        return UIImageView()
    }()
    
    lazy var playButton: UIButton = {
        let button = UIButton()
        button.setImage(Desk360.Config.Images.playIcon, for: .normal)
        button.setImage(Desk360.Config.Images.pauseIcon, for: .selected)
        return button
    }()
    
    lazy var previewImageView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var previewVideoView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var previewPdfView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var previewOtherFileView: UIView = {
        let view = UIView()
        return view
    }()
    
    var fileInfoView: UIView?

    @available(iOS 11.0, *)
    lazy var pdfView: PDFView = {
        let pdfView = PDFView()
        return pdfView
    }()

    var table: UITableView?
    
    var workItem: DispatchWorkItem?
    
    private var containerBackgroundColor: UIColor? {
        didSet {
            containerView.backgroundColor = containerBackgroundColor
            messageTextView .backgroundColor = containerBackgroundColor
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
        self.containerView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(self.preferredSpacing / 2)
            make.width.equalTo(UIScreen.main.bounds.size.minDimension - (self.preferredSpacing * 2))
        }
        self.stackView.snp.makeConstraints { $0.edges.equalToSuperview().inset(self.preferredSpacing / 2) }
        self.dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.containerView.snp.leading).offset(self.preferredSpacing * 0.5)
            make.top.equalTo(self.containerView.snp.bottom).offset(self.preferredSpacing * 0.25)
            make.bottom.equalToSuperview().inset(self.preferredSpacing * 0.25)
            make.height.equalTo(self.preferredSpacing)
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()

        roundCorner()

    }
    
    func clearCell() {
        fileInfoView?.removeFromSuperview()
        fileInfoView = nil
        videoView.isHidden = true
        previewImageView.isHidden = true
        previewVideoView.isHidden = true
        previewPdfView.isHidden = true
        previewOtherFileView.isHidden = true
        guard #available(iOS 11.0, *) else { return }
        pdfView.isHidden = true
    }
}

// MARK: - Configure
internal extension SenderMessageTableViewCell {

    func killBackgroundThread() {
        if Desk360.conVC == nil {
            self.workItem?.cancel()
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.killBackgroundThread()
            }
        }
    }

    func configure(for request: Message, table: UITableView, hasAttach: Bool = false) {
        if Desk360.conVC == nil { return }
        self.table = table
        containerView.backgroundColor = Colors.ticketDetailChatSenderBackgroundColor
        messageTextView.text = request.message
        messageTextView.textColor = Colors.ticketDetailChatSenderTextColor
        messageTextView.font = UIFont.systemFont(ofSize: CGFloat(Config.shared.model?.ticketDetail?.chatSenderFontSize ?? 18), weight: Font.weight(type: Config.shared.model?.ticketDetail?.chatSenderFontWeight ?? 400))
        dateLabel.textColor = Colors.ticketDetailChatSenderDateColor

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

        if hasAttach == false { return }

        if let images = request.attachments?.images {
            let val = images.filter({$0 != nil })
            if val.count > 1 {
                for image in val {
                    if let url = URL(string: image.url) {
                        self.checkFile(url, fileName: image.name)
                    }
                }
            }
            else if val.count == 1 {
                if let url = URL(string: val[0].url) {
                    self.checkFile(url, fileName: val[0].name)
                }
            }
        }
        if let videos = request.attachments?.videos {
            let val = videos.filter({$0 != nil })
            if val.count > 1 {
                for video in val {
                    if let url = URL(string: video.url) {
                        self.checkFile(url, fileName: video.name)
                    }
                }
            }
            else if val.count == 1 {
                if let url = URL(string: val[0].url) {
                    self.checkFile(url, fileName: val[0].name)
                }
            }
        }
        if let files = request.attachments?.files {
            let val = files.filter({$0 != nil })
            if val.count > 1 {
                for file in val {
                    if let url = URL(string: file.url) {
                        self.checkFile(url, fileName: file.name)
                    }
                }
            }
            else if val.count == 1 {
                if let url = URL(string: val[0].url) {
                    self.checkFile(url, fileName: val[0].name)
                }
            }
        }
        if let otherFiles = request.attachments?.others {
            let val = otherFiles.filter({$0 != nil })
            if val.count > 1 {
                for otherFile in val {
                    if let url = URL(string: otherFile.url) {
                        self.checkFile(url, fileName: otherFile.name)
                    }
                }
            }
            else if val.count == 1 {
                if let url = URL(string: val[0].url) {
                    self.checkFile(url, fileName: val[0].name)
                }
            }
        }

    }

    func checkFile(_ url: URL, fileName: String) {

        if Desk360.conVC == nil { return }
        guard let path = url.pathComponents.last else { return }
        let words = path.split(separator: ".")
        guard var word = words.last else { return }
        if word == "pdf" {
            self.addPdf(url, fileName: fileName)
        } else if word == "png" || word == "jpeg" {
            self.addImageView(url, fileExt: String(word), fileName: fileName)
        } else if word == "avi" || word == "mkv" || word == "mov" || word == "wmv" || word == "mp4" || word == "3gp" {
            if word == "mkv" || word == "wmv" || word == "3gp" { word = "mp4" }
            self.addVideoView(url, fileExt: String(word), fileName: fileName)
        } else {
            self.addOtherView(url, fileExt: String(word), fileName: fileName)
        }
    }
    
    func addVideoView(_ url: URL, fileExt: String, fileName: String) {

        if Desk360.conVC == nil { return }
        
        previewImageView.isHidden = true
        previewPdfView.isHidden = true
        previewOtherFileView.isHidden = true
        videoView.isHidden = false
        self.previewVideoView.isHidden = false
        if #available(iOS 11.0, *) { pdfView.isHidden = true }
        
        self.stackView.addArrangedSubview(self.previewVideoView)
        self.previewVideoView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(self.previewVideoView.snp.width)
        }

        self.previewVideoView.addSubview(self.videoView)
        self.previewVideoView.addSubview(self.playButton)

        self.playButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(self.preferredSpacing * 2)
        }

        self.playButton.addTarget(self, action: #selector(self.didTapPlayButton), for: .touchUpInside)
        self.playButton.tintColor = Colors.ticketDetailWriteMessageButtonIconColor
        
        self.videoView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().inset(32)
        }

        let avPlayer = AVPlayer(url: url);
        videoView.playerLayer.player = avPlayer;
        
        self.addFileInfoView(supView: self.previewVideoView, fullFileName: fileName, fileExt: fileExt, url: url.absoluteString)
        if Desk360.conVC == nil { return }
    }

    func addImageView(_ url: URL, fileExt: String, fileName: String) {

        if Desk360.conVC == nil { return }
        
        videoView.isHidden = true
        previewVideoView.isHidden = true
        previewPdfView.isHidden = true
        previewOtherFileView.isHidden = true
        if #available(iOS 11.0, *) { pdfView.isHidden = true }
        
        if cellImageView.image == nil {
            self.imageFromUrl(url: url)
        }
        
        self.stackView.addArrangedSubview(self.previewImageView)
        self.previewImageView.snp.makeConstraints { remake in
            remake.leading.trailing.equalToSuperview()
            remake.height.equalTo(self.previewImageView.snp.width)
        }
        self.previewImageView.addSubview(self.cellImageView)
        
        self.previewImageView.isHidden = false
        self.cellImageView.snp.makeConstraints { remake in
            remake.leading.trailing.equalToSuperview()
            remake.top.equalToSuperview()
            remake.bottom.equalToSuperview().inset(32)
        }
        self.cellImageView.contentMode = .scaleAspectFill
        self.cellImageView.clipsToBounds = true
        self.addFileInfoView(supView: self.previewImageView, fullFileName: fileName, fileExt: fileExt, url: url.absoluteString)
        if Desk360.conVC == nil { return }
    }

    func addPdf(_ url: URL, fileName: String) {
        guard #available(iOS 11.0, *) else { return }

        if Desk360.conVC == nil { return }
        videoView.isHidden = true
        previewImageView.isHidden = true
        previewVideoView.isHidden = true
        previewOtherFileView.isHidden = true
        
        self.stackView.addArrangedSubview(self.previewPdfView)
        self.previewPdfView.snp.makeConstraints { remake in
            remake.leading.trailing.equalToSuperview()
            remake.height.equalTo(self.previewPdfView.snp.width)
        }
        self.previewPdfView.addSubview(self.pdfView)
        
        self.pdfView.snp.makeConstraints { remake in
            remake.leading.trailing.equalToSuperview()
            remake.top.equalToSuperview()
            remake.bottom.equalToSuperview().inset(32)
        }
        self.previewPdfView.isHidden = false
        self.pdfView.translatesAutoresizingMaskIntoConstraints = false
        self.pdfView.isHidden = false

        guard let document = PDFDocument(url: url) else { return }
        self.pdfView.document = document
        self.addFileInfoView(supView: self.previewPdfView, fullFileName: fileName, fileExt: "pdf", url: url.absoluteString)
        
        if Desk360.conVC == nil { return }
    }
    
    func addOtherView(_ url: URL, fileExt: String, fileName: String) {
        if Desk360.conVC == nil { return }
        videoView.isHidden = true
        previewImageView.isHidden = true
        previewVideoView.isHidden = true
        previewPdfView.isHidden = true
        if #available(iOS 11.0, *) { pdfView.isHidden = true }

        self.stackView.addArrangedSubview(self.previewOtherFileView)
        self.previewOtherFileView.snp.makeConstraints { remake in
            remake.leading.trailing.equalToSuperview()
            remake.height.equalTo(40)
        }
        self.previewOtherFileView.isHidden = false
        self.addFileInfoView(supView: self.previewOtherFileView, fullFileName: fileName, fileExt: fileExt, url: url.absoluteString, isOther: true)

        if Desk360.conVC == nil { return }
    }
    
    func addFileInfoView(supView: UIView, fullFileName: String, fileExt: String, url: String, isOther: Bool = false)/* -> UIView */{
        if Desk360.conVC == nil { return }
        fileInfoView?.removeFromSuperview()
        fileInfoView = nil
        fileInfoView = UIView()
        supView.addSubview(fileInfoView!)
        let fileImageView = UIImageView(frame: CGRect(x: 0, y: 2, width: 22, height: 25))
        if isOther {
            fileInfoView?.snp.makeConstraints{ remake in
                remake.trailing.leading.equalToSuperview()
                remake.bottom.equalToSuperview().inset(5)
                remake.top.equalToSuperview().inset(5)
            }
            fileImageView.image = Desk360.Config.Images.createImageOriginal(resources: "Images/fileext")
        } else {
            fileInfoView?.snp.makeConstraints{ remake in
                remake.trailing.leading.equalToSuperview()
                remake.height.equalTo(30)
                remake.bottom.equalToSuperview().inset(-2)
            }
            fileImageView.image = Desk360.Config.Images.createImageOriginal(resources: "Images/\(fileExt)")
        }
        fileInfoView?.addSubview(fileImageView)
        let fileNameLabel = UILabel(frame: CGRect(x: 36, y: 5, width: 200, height: 20))
        fileNameLabel.text = fullFileName
        fileNameLabel.font = Desk360.Config.Conversation.MessageCell.fileNameFont
        fileNameLabel.textColor = Colors.senderFileNameColor
        fileInfoView?.addSubview(fileNameLabel)
        let downloadButton = UIButton()
        fileInfoView!.addSubview(downloadButton)
        downloadButton.snp.makeConstraints{ remake in
            remake.trailing.equalToSuperview()
            remake.width.height.equalTo(30)
            remake.centerY.equalToSuperview()
        }
        downloadButton.setImage(Desk360.Config.Images.senderDownloadFile, for: .normal)
        downloadButton.contentHorizontalAlignment = .right
        downloadButton.accessibilityLabel = url
        downloadButton.titleLabel?.accessibilityLabel = fullFileName
        downloadButton.addTarget(self, action: #selector(self.downloadFile(sender:)), for: .touchUpInside)

        if Desk360.conVC == nil { return }
    }
    
    @objc func downloadFile(sender: UIButton) {
        if Desk360.conVC == nil { return }
        
        guard let url = URL(string: sender.accessibilityLabel ?? "") else { return }
        downloadFile(url: url.absoluteString, fileName: sender.titleLabel?.accessibilityLabel ?? "file" , complection: { (path, str) in
            guard let localPath = path, str == nil else {
                return
            }
            let documentController = UIDocumentPickerViewController(url: localPath, in: .moveToService)
            Desk360.conVC!.present(documentController, animated: true, completion: nil)
            
        })
    }
    
    func downloadFile(url: String, fileName: String, complection: @escaping(URL?, String?) -> Void ) {
        let finaleURL = url
        let tempFileExt = fileName
        guard let url = URL(string: finaleURL) else {
            DispatchQueue.main.async {
                complection(nil, nil)
            }
            return
        }
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            guard let data = data, err == nil else {
                DispatchQueue.main.async {
                    complection(nil, err?.localizedDescription ?? nil)
                }
                return
            }
            let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(tempFileExt)
            do {
                try data.write(to: tempURL)
            } catch let fileErr {
                DispatchQueue.main.async {
                    complection(nil, fileErr.localizedDescription)
                    return
                }
            }
            DispatchQueue.main.async {
                complection(tempURL, nil)
            }
            }.resume()
    }
    
    @objc func didTapPlayButton() {
        if Desk360.conVC == nil { return }
        playButton.isSelected = !playButton.isSelected
        guard playButton.isSelected else {
            videoView.player?.pause()
            return
        }
        videoView.player?.play()
    }
    
    func imageFromUrl(url: URL) {
        let request = URLRequest(url: url as URL)
        let task = URLSession.shared.dataTask(with: request) { (data, _, _) in
            if let imageData = data {
                DispatchQueue.main.async {
                    self.cellImageView.image = UIImage(data: imageData)
                }
            }
        }
        task.resume()
    }

    func roundCorner() {
        let type = Config.shared.model?.ticketDetail?.chatBoxStyle

        let containerShadowIsHidden = Config.shared.model?.ticketDetail?.chatSenderShadowIsHidden ?? true

        switch type {
        case 1:
            containerView.roundCorners([.topLeft, .bottomRight, .topRight], radius: 10, isShadow: !containerShadowIsHidden)
        case 2:
            containerView.roundCorners([.topLeft, .bottomRight, .topRight], radius: 30, isShadow: !containerShadowIsHidden)
        case 3:
            containerView.roundCorners([.topLeft, .bottomRight, .topRight], radius: 19, isShadow: !containerShadowIsHidden)
        case 4:
            containerView.layer.cornerRadius = 0
            addSubLayerChatBubble()
            containerBackgroundColor = .clear
        default:
            containerView.roundCorners([.topLeft, .bottomRight, .topRight], radius: 10, isShadow: !containerShadowIsHidden)
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

        stackView.snp.makeConstraints { remake in
            remake.leading.equalToSuperview().inset(preferredSpacing)
            remake.top.trailing.bottom.equalToSuperview().inset(preferredSpacing / 2)
        }
        let width = containerView.frame.width
        let height = containerView.frame.height

        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 0, y: height))
        bezierPath.addLine(to: CGPoint(x: width - 4, y: height))
        bezierPath.addCurve(to: CGPoint(x: width, y: height - 4), controlPoint1: CGPoint(x: width - 2, y: height), controlPoint2: CGPoint(x: width, y: height - 2))
        bezierPath.addLine(to: CGPoint(x: width, y: 4))
        bezierPath.addCurve(to: CGPoint(x: width - 4, y: 0), controlPoint1: CGPoint(x: width, y: 2), controlPoint2: CGPoint(x: width - 2, y: 0))
        bezierPath.addLine(to: CGPoint(x: 16, y: 0))
        bezierPath.addCurve(to: CGPoint(x: 12, y: 4), controlPoint1: CGPoint(x: 14, y: 0), controlPoint2: CGPoint(x: 12, y: 2))
        bezierPath.addLine(to: CGPoint(x: 12, y: height - 8))
        bezierPath.addLine(to: CGPoint(x: 4, y: height))

        let incomingMessageLayer = CAShapeLayer()
        incomingMessageLayer.path = bezierPath.cgPath
        incomingMessageLayer.frame = CGRect(x: 0,
                                            y: 0,
                                            width: width,
                                            height: height)
        incomingMessageLayer.fillColor = Colors.ticketDetailChatSenderBackgroundColor.cgColor

        if let layers = containerView.layer.sublayers {
            for layer in layers where layer is CAShapeLayer {
                layer.removeFromSuperlayer()
            }
        }

        containerView.layer.insertSublayer(incomingMessageLayer, below: stackView.layer)
        containerView.clipsToBounds = false
    }

}

