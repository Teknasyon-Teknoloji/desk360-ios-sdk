//
//  CreateRequestViewController.swift
//  Desk360
//
//  Created by samet on 18.05.2019.
//

import UIKit
import MediaPlayer
import MobileCoreServices
import Moya
import Photos
import FileProvider

// swiftlint:disable file_length
final class CreateRequestViewController: UIViewController, UIDocumentBrowserViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, Layouting, UIGestureRecognizerDelegate, UIDocumentPickerDelegate {

	typealias ViewType = CreateRequestView
	override func loadView() {
		view = ViewType.create()
	}

	var ticket = [MultipartFormData]()

	var checkLastClass: Bool?

	var isConfigure = false

	var attachmentUrl: URL?

    var newTicket: NewTicket?
    
	convenience init(checkLastClass: Bool) {
		self.init()
		self.checkLastClass = checkLastClass
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		layoutableView.sendButton.addTarget(self, action: #selector(didTapSendRequestButton), for: .touchUpInside)
		layoutableView.attachmentButton.addTarget(self, action: #selector(addFile), for: .touchUpInside)
		layoutableView.attachmentCancelButton.addTarget(self, action: #selector(deleteFile), for: .touchUpInside)
		registerForKeyboardEvents()

		guard let check = checkLastClass, check else { return }
		let count = navigationController?.viewControllers.count ?? 0
        if count >= 2 {
            navigationController?.viewControllers.remove(at: 1)
        }
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		configLayoutableView()

//		fetchTicketType()

		navigationController?.interactivePopGestureRecognizer?.isEnabled = true
		navigationController?.interactivePopGestureRecognizer?.delegate  = self
		navigationItem.rightBarButtonItem = nil

		navigationItem.leftBarButtonItem = NavigationItems.back(target: self, action: #selector(didTapBackButton))
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
			self.layoutableView.bottomScrollView.contentSize = CGSize(width: self.layoutableView.bottomScrollView.frame.size.width, height: self.layoutableView.bottomDescriptionLabel.frame.size.height + self.layoutableView.preferredSpacing * 0.5)
		}
	}

	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)

		isConfigure = false
	}

	@objc func deleteFile() {
		layoutableView.attachmentCancelButton.isEnabled = false
		layoutableView.attachmentCancelButton.isHidden = true
		layoutableView.attachmentLabel.text = ""
		ticket.removeAll()
	}

	@objc func addFile() {
		let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

		let showImagePicker = UIAlertAction(title: Config.shared.model?.generalSettings?.attachmentImagesText ?? "Images", style: .default) { _ in
			self.attachmentButtonConfigure()
			self.didTapImagePicker()
		}
		let showFilePicker = UIAlertAction(title: Config.shared.model?.generalSettings?.attachmentBrowseText ?? "Browse", style: .default) { _ in
			self.attachmentButtonConfigure()
			self.didTapDocumentBrowse()
		}
		let cancelAction = UIAlertAction(title: Config.shared.model?.generalSettings?.attachmentCancelText ?? "Cancel", style: .cancel) { _ in
			self.attachmentButtonConfigure()
		}

		if #available(iOS 11.0, *) {
			alert.addAction(showFilePicker)
		}
		alert.addAction(showImagePicker)
		alert.addAction(cancelAction)

		attachmentButtonConfigure()
		present(alert, animated: true, completion: { () in
			self.attachmentButtonConfigure()
		})
	}

	func attachmentButtonConfigure() {
		if UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft {
			layoutableView.attachmentButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: layoutableView.preferredSpacing * 0.5, bottom: 0, right: 0)
		} else {
			layoutableView.attachmentButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: layoutableView.preferredSpacing * 0.5)
		}

	}

	@objc func didTapDocumentBrowse() {

		let documentPicker = UIDocumentPickerViewController(documentTypes: ["com.adobe.pdf"], in: .import)
		documentPicker.delegate = self
		documentPicker.modalPresentationStyle = .fullScreen
		self.present(documentPicker, animated: true) {
			self.isConfigure = true
		}

	}

	func getDocumentsDirectory() -> URL {
		let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		return paths[0]
	}

	func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {

		guard let url = urls.first else { return }
		attachmentUrl = url
		guard let pdfData = try? Data(contentsOf: url) else { return }
		guard let name = url.pathComponents.last else { return }
		guard pdfData.count < 20971520 else {
			controller.dismiss(animated: true) {
				Alert.showAlert(viewController: self, title: "Desk360", message: Config.shared.model?.generalSettings?.fileSizeErrorText ?? "")
			}
			return
		}
		ticket.removeAll()
		ticket.append(Moya.MultipartFormData(provider: .data(pdfData as Data), name: "attachment", fileName: name, mimeType: "pdf"))
		layoutableView.attachmentLabel.text = name
		layoutableView.attachmentCancelButton.isHidden = false
		layoutableView.attachmentCancelButton.isEnabled = true

		controller.dismiss(animated: true)

	}

	@objc func didTapImagePicker() {
		let imagePicker: UIImagePickerController = UIImagePickerController()
		imagePicker.delegate = self
		imagePicker.modalPresentationStyle = .fullScreen
		imagePicker.allowsEditing = false
		imagePicker.mediaTypes = ["public.image", "public.movie"]
		imagePicker.sourceType = .photoLibrary

		PHPhotoLibrary.requestAuthorization { [weak self] result in
			if result == .authorized {
				DispatchQueue.main.async {
					self?.present(imagePicker, animated: true) {
						self?.isConfigure = true
					}
				}
			} else {
				DispatchQueue.main.async {
					self?.showAlert()
				}
			}
		}
	}

	func showAlert() {

		let alert = UIAlertController(title: "Desk360", message: Config.shared.model?.generalSettings?.galleryPermissionErrorMessage, preferredStyle: .alert)

		let okayAction = UIAlertAction(title: Config.shared.model?.generalSettings?.galleryPermissionErrorButtonText ?? "ok.button".localize(), style: .default) { _ in }
		alert.addAction(okayAction)

		present(alert, animated: true, completion: nil)

	}

	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
		guard let imgUrl = info[UIImagePickerController.InfoKey.referenceURL] as? URL else { return }
		guard var name = imgUrl.pathComponents.last else { return }

		attachmentUrl = imgUrl
		if #available(iOS 11.0, *) {
			if let asset = info[UIImagePickerController.InfoKey.phAsset] as? PHAsset {
				let assetResources = PHAssetResource.assetResources(for: asset)
				name = assetResources.first?.originalFilename ?? ""
			}
		}

		ticket.removeAll()
		if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
			guard let data = image.jpegData(compressionQuality: 0.3) as NSData? else { return }
			guard data.length < 20971520 else {
				picker.dismiss(animated: true) {
					Alert.showAlert(viewController: self, title: "Desk360", message: Config.shared.model?.generalSettings?.fileSizeErrorText ?? "")
				}
				return
			}
			ticket.append(Moya.MultipartFormData(provider: .data(data as Data), name: "attachment", fileName: name, mimeType: "image/jpeg"))
		} else {
			if let videoUrl = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
				attachmentUrl = videoUrl
				guard let data = try? NSData(contentsOf: videoUrl as URL, options: .mappedIfSafe) else { return }
				guard data.length < 20971520 else {
					picker.dismiss(animated: true) {
						Alert.showAlert(viewController: self, title: "Desk360", message: Config.shared.model?.generalSettings?.fileSizeErrorText ?? "")
					}
					return
				}
				ticket.append(Moya.MultipartFormData(provider: .data(data as Data), name: "attachment", fileName: name, mimeType: "video"))
			}
		}

		layoutableView.attachmentLabel.text = name
		layoutableView.attachmentCancelButton.isHidden = false
		layoutableView.attachmentCancelButton.isEnabled = true
		picker.dismiss(animated: true)
	}

	@objc private func didTapSendRequestButton() {

		checkChangeFrame()
		guard let name = layoutableView.nameTextField.trimmedText, name.count > 2 else {
			layoutableView.nameErrorLabel.isHidden = false
			layoutableView.scrollView.setContentOffset(CGPoint(x: 0, y: layoutableView.nameTextField.frame.origin.y + layoutableView.preferredSpacing * 0.25), animated: true)
			layoutableView.nameTextField.shake()
			layoutableView.nameTextField.becomeFirstResponder()
			checkChangeFrame()
			return
		}

		layoutableView.nameErrorLabel.isHidden = true

		guard layoutableView.emailTextField.emailAddress != nil else {
			layoutableView.emailErrorLabel.isHidden = false
			layoutableView.scrollView.setContentOffset(CGPoint(x: 0, y: layoutableView.emailTextField.frame.origin.y + layoutableView.preferredSpacing * 0.25), animated: true)
			layoutableView.emailTextField.shake()
			layoutableView.emailTextField.becomeFirstResponder()
			checkChangeFrame()
			return
		}

		checkChangeFrame()
		layoutableView.nameErrorLabel.isHidden = true

		guard layoutableView.dropDownListView.getSelectedIndex != -1 else {
			layoutableView.dropDownListView.shake()
			layoutableView.scrollView.setContentOffset(CGPoint(x: 0, y: layoutableView.dropDownListView.frame.origin.y + layoutableView.preferredSpacing * 0.25), animated: true)
			layoutableView.dropDownListView.showList()
			return
		}

		guard let message = layoutableView.messageTextView.messageTextView.trimmedText, message.count > 0 else {
			layoutableView.messageTextViewErrorLabel.isHidden = false
			layoutableView.messageTextView.messageTextView.shake()
			layoutableView.scrollView.setContentOffset(CGPoint(x: 0, y: layoutableView.messageTextView.messageTextView.frame.origin.y + layoutableView.preferredSpacing * 0.25 + layoutableView.messageTextView.frame.size.height), animated: true)
			layoutableView.messageTextView.messageTextView.becomeFirstResponder()
			return
		}
		layoutableView.messageTextViewErrorLabel.isHidden = true

		let ticketTypes = layoutableView.ticketTypes
		guard ticketTypes.count > 0 else { return }
		_ = ticketTypes[layoutableView.dropDownListView.getSelectedIndex].id

		try? Stores.userName.save(name)
		try? Stores.userMail.save(layoutableView.emailTextField.emailAddress)

		sendRequest()
	}

	func checkChangeFrame() {
		HADropDown.frameChange = 0
		if layoutableView.nameErrorLabel.isHidden == false && layoutableView.emailErrorLabel.isHidden == false {
			HADropDown.frameChange = UITextField.preferredHeight * 1.2
		} else if layoutableView.nameErrorLabel.isHidden && layoutableView.emailErrorLabel.isHidden {
			HADropDown.frameChange = 0
		} else {
			HADropDown.frameChange = UITextField.preferredHeight * 0.6
		}
	}

	@objc func didTapBackButton() {
		self.layoutableView.endEditing(true)
		navigationController?.popViewController(animated: true)
	}
}

// MARK: - Config
extension CreateRequestViewController {
	func configLayoutableView() {

		let selectedattributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
		NSAttributedString.Key.font: UIFont.systemFont(ofSize: CGFloat(Config.shared.model?.generalSettings?.navigationTitleFontSize ?? 16), weight: Font.weight(type: Config.shared.model?.generalSettings?.navigationTitleFontWeight ?? 400)), NSAttributedString.Key.shadow: NSShadow() ]
		let navigationTitle = NSAttributedString(string: Config.shared.model?.createScreen?.navigationTitle ?? "", attributes: selectedattributes as [NSAttributedString.Key: Any])
		let titleLabel = UILabel()
		titleLabel.attributedText = navigationTitle
		titleLabel.sizeToFit()
		titleLabel.textAlignment = .center
		titleLabel.textColor = Colors.navigationTextColor
		navigationItem.titleView = titleLabel

		navigationItem.title = Config.shared.model?.createScreen?.navigationTitle
		self.navigationController?.navigationBar.setColors(background: Colors.navigationBackgroundColor, text: Colors.navigationTextColor)
		navigationController?.navigationBar.tintColor = Colors.navigationImageViewTintColor
		self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
		self.navigationController?.navigationBar.shadowImage = UIImage()
		guard !isConfigure else { return }
		isConfigure = true
		layoutableView.configure()
	}
}

// MARK: - KeyboardObserving
extension CreateRequestViewController: KeyboardObserving {

	func keyboardWillShow(_ notification: KeyboardNotification?) {
		layoutableView.keyboardWillShow(notification)
	}

	func keyboardWillHide(_ notification: KeyboardNotification?) {
		layoutableView.keyboardWillHide(notification)
	}

	func keyboardDidHide(_ notification: KeyboardNotification?) {
		layoutableView.keyboardDidHide(notification)
	}
	func keyboardDidShow(_ notification: KeyboardNotification?) {}
	func keyboardWillChangeFrame(_ notification: KeyboardNotification?) {
		layoutableView.keyboardWillChangeFrame(notification)
	}
	func keyboardDidChangeFrame(_ notification: KeyboardNotification?) {}

}

// MARK: - Networking
private extension CreateRequestViewController {

	func fetchTicketType() {

		Desk360.apiProvider.request(.ticketTypeList) { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .failure(let error):
				if error.response?.statusCode == 400 {
					Desk360.isRegister = false
					Alert.showAlertWithDismiss(viewController: self, title: "Desk360", message: "general.error.message".localize(), dissmis: true)
					return
				}
			case .success(let response):
				guard let ticketTypes = try? response.map(DataResponse<[TicketType]>.self) else { return }
				guard let ticketsTypes = ticketTypes.data else { return }
				self.layoutableView.ticketTypes.removeAll()
				self.layoutableView.ticketTypes = ticketsTypes
				self.layoutableView.setTicketType(ticketTypes: ticketsTypes)
			}
		}
	}

	func addField(field: UITextField) {
		guard let text = field.trimmedText, text.count > 0  else { return }
		let name = field.accessibilityIdentifier ?? ""
		let fieldData = text.data(using: String.Encoding.utf8) ?? Data()
		ticket.append(Moya.MultipartFormData(provider: .data(fieldData), name: name))
	}

	func addDropDownList(view: HADropDown) {
		guard view.getSelectedIndex != -1 else { return }
		if view == layoutableView.dropDownListView {
			let ticketTypeId = layoutableView.ticketTypes[layoutableView.dropDownListView.getSelectedIndex].id
			let name = view.accessibilityIdentifier ?? ""
			let fieldData = String(ticketTypeId).data(using: String.Encoding.utf8) ?? Data()
			ticket.append(Moya.MultipartFormData(provider: .data(fieldData), name: name))
		} else {
			let text = view.title
			let name = view.accessibilityIdentifier ?? ""
			let fieldData = text.data(using: String.Encoding.utf8) ?? Data()
			ticket.append(Moya.MultipartFormData(provider: .data(fieldData), name: name))
		}

	}

	func addTextView(view: UITextView) {
		guard let text = view.trimmedText, text.count > 0  else { return }
		let name = view.accessibilityIdentifier ?? ""
		let fieldData = text.data(using: String.Encoding.utf8) ?? Data()
		ticket.append(Moya.MultipartFormData(provider: .data(fieldData), name: name))
	}

	// swiftlint:disable cyclomatic_complexity
	func sendRequest() {

		layoutableView.endEditing(true)

		guard Desk360.isReachable else {
			networkError()
			return
		}

		let fields = layoutableView.fields

		for field in fields {
			if let currentField = field as? UITextField {
				addField(field: currentField)
			}

			if let currentDropDown = field as? HADropDown {
				addDropDownList(view: currentDropDown)
			}

			if let currentView = field as? CustomMessageTextView {
				addTextView(view: currentView.messageTextView)
			}
		}

		let sourceData = "App".data(using: String.Encoding.utf8) ?? Data()
		ticket.append(Moya.MultipartFormData(provider: .data(sourceData), name: "source"))

		let platformData = "iOS".data(using: String.Encoding.utf8) ?? Data()
		ticket.append(Moya.MultipartFormData(provider: .data(platformData), name: "platform"))

		let countryCodeData = Locale.current.countryCode.data(using: String.Encoding.utf8) ?? Data()
		ticket.append(Moya.MultipartFormData(provider: .data(countryCodeData), name: "country_code"))

		if let json = Desk360.jsonInfo {
			if let jsonData = try? JSONSerialization.data(withJSONObject: json) {
				ticket.append(Moya.MultipartFormData(provider: .data(jsonData), name: "settings"))
			}
		}

		if let pushTokenString = Desk360.pushToken {
			let pushTokenData = pushTokenString.data(using: String.Encoding.utf8) ?? Data()
			ticket.append(Moya.MultipartFormData(provider: .data(pushTokenData), name: "push_token"))
		}
        self.layoutableView.setLoading(true)
		Desk360.apiProvider.request(.create(ticket: ticket)) { [weak self] result in
			guard let self = self else { return }
			self.layoutableView.setLoading(false)
			switch result {
			case .failure(let error):
                self.cacheTicket()
				print(error.localizedServerDescription)
				if error.response?.statusCode == 400 {
					Desk360.isRegister = false
					Alert.showAlertWithDismiss(viewController: self, title: "Desk360", message: "general.error.message".localize(), dissmis: true)
					return
				}
			case .success(let response):
                guard let tickets = try? response.map(DataResponse<NewTicket>.self) else { return }
                guard let data = tickets.data else { return }
                self.newTicket = data
                self.cacheTicket()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.navigationController?.pushViewController(SuccsessViewController(checkLastClass: true), animated: true)
                }
                
				break
			}
		}
	}

	func cacheTicket() {
		guard let name = layoutableView.nameTextField.text else { return  }
		guard let email = layoutableView.emailTextField.text else { return }
		guard let message = layoutableView.messageTextView.messageTextView.text else { return }

		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
		let dateString = formatter.string(from: Date())

		let currentMessage = Message(id: -1, message: message, isAnswer: false, createdAt: dateString)

        let ticket = Ticket(id: newTicket?.id ?? -1, name: name, email: email, status: .open, createdAt: Date(), message: message, messages: [currentMessage], attachmentUrl: attachmentUrl, createDateString: dateString)

		try? Stores.ticketsStore.save(ticket)
	}

	func networkError() {
		layoutableView.setLoading(false)

		let cancel = "cancel.button".localize()
		let tryAgain = "try.again.button".localize()

		Alert.shared.showAlert(viewController: self, withType: .info, title: "Desk360", message: "connection.error.message".localize(), buttons: [cancel,tryAgain], dismissAfter: 0.1) { [weak self] value in
			guard let self = self else { return }
			if value == 2 {
				self.sendRequest()
			}
		}
	}

}
