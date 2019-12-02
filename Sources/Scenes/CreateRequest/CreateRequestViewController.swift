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

final class CreateRequestViewController: UIViewController, UIDocumentBrowserViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, Layouting, UIGestureRecognizerDelegate, UIDocumentPickerDelegate {

	typealias ViewType = CreateRequestView
	override func loadView() {
		view = ViewType.create()
	}

	var ticket = [MultipartFormData]()

	var checkLastClass: Bool?

	var isConfigure = false

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
		navigationController?.viewControllers.removeSubrange(count-2..<count-1)

	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		configLayoutableView()

		fetchTicketType()

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


		let showImagePicker = UIAlertAction(title: NSLocalizedString("Images", comment: ""), style: .default) { action in
			self.attachmentButtonConfigure()
			self.didTapImagePicker()
		}
		let showFilePicker = UIAlertAction(title: "Browse", style: .default)   { action in
			self.attachmentButtonConfigure()
			self.didTapDocumentBrowse()
		}
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
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
		guard let pdfData = try? Data(contentsOf: url) else { return }
		guard let name = url.pathComponents.last else { return }
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

		let alert = UIAlertController(title: "Des360", message: "Test", preferredStyle: .alert)

		let okayAction = UIAlertAction(title: "OK", style: .default) { _ in }
		alert.addAction(okayAction)

		present(alert, animated: true, completion: nil)

	}


	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		guard let imgUrl = info[UIImagePickerController.InfoKey.referenceURL] as? URL else { return }
		guard var name = imgUrl.pathComponents.last else { return }
		guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
		guard let data = image.jpegData(compressionQuality: 0.3) as? NSData else { return }

		if #available(iOS 11.0, *) {
			if let asset = info[UIImagePickerController.InfoKey.phAsset] as? PHAsset {
				let assetResources = PHAssetResource.assetResources(for: asset)
				name = assetResources.first?.originalFilename ?? ""
			}
		}
		ticket.removeAll()
		ticket.append(Moya.MultipartFormData(provider: .data(data as Data), name: "attachment", fileName: name, mimeType: "image/jpeg"))
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

		guard let email = layoutableView.emailTextField.emailAddress else {
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

		guard let message = layoutableView.messageTextView.trimmedText, message.count > 0 else {
			layoutableView.messageTextViewErrorLabel.isHidden = false
			layoutableView.messageTextView.shake()
			layoutableView.scrollView.setContentOffset(CGPoint(x: 0, y: layoutableView.messageTextView.frame.origin.y + layoutableView.preferredSpacing * 0.25), animated: true)
			layoutableView.messageTextView.becomeFirstResponder()
			return
		}
		layoutableView.messageTextViewErrorLabel.isHidden = true

		let ticketTypes = layoutableView.ticketTypes
		guard ticketTypes.count > 0 else { return }
		let ticketTypeId = ticketTypes[layoutableView.dropDownListView.getSelectedIndex].id
		sendRequest(name: name, email: email, ticketType: String(ticketTypeId), message: message)
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

	@objc
	func didTapBackButton() {
		navigationController?.popViewController(animated: true)
	}
}

// MARK: - Config
extension CreateRequestViewController {
	func configLayoutableView() {

		let selectedattributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
		NSAttributedString.Key.font: UIFont.systemFont(ofSize: CGFloat(Config.shared.model.generalSettings?.navigationTitleFontSize ?? 16) , weight: Font.weight(type: Config.shared.model.generalSettings?.navigationTitleFontWeight ?? 400)), NSAttributedString.Key.shadow: NSShadow() ]
		let navigationTitle = NSAttributedString(string: Config.shared.model.createScreen?.navigationTitle ?? "", attributes: selectedattributes as [NSAttributedString.Key: Any])
		var titleLabel = UILabel()
		titleLabel.attributedText = navigationTitle
		titleLabel.sizeToFit()
		titleLabel.textAlignment = .center
		titleLabel.textColor = Colors.navigationTextColor
		navigationItem.titleView = titleLabel

		navigationItem.title = Config.shared.model.createScreen?.navigationTitle
		self.navigationController?.navigationBar.setColors(background: Colors.navigationBackgroundColor, text: Colors.navigationTextColor ?? .black)
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

	func keyboardDidHide(_ notification: KeyboardNotification?) {}
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
					Alert.showAlert(viewController: self, title: "Desk360", message: "connection.error.message".localize(), dissmis: true)
					return
				}
				Alert.showAlert(viewController: self, title: "Desk360", message: "connection.error.message".localize(), dissmis: false)
				print(error.localizedDescription)
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
		ticket.append(Moya.MultipartFormData(provider: .data(fieldData) , name: name))
	}

	func addDropDownList(view: HADropDown) {
		guard view.getSelectedIndex != -1 else { return }
		if view == layoutableView.dropDownListView {
			let ticketTypeId = layoutableView.ticketTypes[layoutableView.dropDownListView.getSelectedIndex].id
			let name = view.accessibilityIdentifier ?? ""
			let fieldData = String(ticketTypeId).data(using: String.Encoding.utf8) ?? Data()
			ticket.append(Moya.MultipartFormData(provider: .data(fieldData) , name: name))
		} else {
			let text = view.title
			let name = view.accessibilityIdentifier ?? ""
			let fieldData = text.data(using: String.Encoding.utf8) ?? Data()
			ticket.append(Moya.MultipartFormData(provider: .data(fieldData) , name: name))
		}


	}

	func addTextView(view: UITextView) {
		guard let text = view.trimmedText, text.count > 0  else { return }
		let name = view.accessibilityIdentifier ?? ""
		let fieldData = text.data(using: String.Encoding.utf8) ?? Data()
		ticket.append(Moya.MultipartFormData(provider: .data(fieldData) , name: name))
	}

	func sendRequest(name: String, email: String, ticketType: String, message: String) {
		let request = TicketRequest(name: name, email: email, message: message, type_id: ticketType, source: "App", platform: "iOS", country_code: Locale.current.countryCode)


		let fields = layoutableView.fields

		for field in fields {

			if let currentField = field as? UITextField {
				addField(field: currentField)
			}

			if let currentDropDown = field as? HADropDown {
				addDropDownList(view: currentDropDown)
			}

			if let currentTextView = field as? UITextView {
				addTextView(view: currentTextView)
			}

		}

		let sourceData = "App".data(using: String.Encoding.utf8) ?? Data()
		ticket.append(Moya.MultipartFormData(provider: .data(sourceData) , name: "source"))

		let platformData = "iOS".data(using: String.Encoding.utf8) ?? Data()
		ticket.append(Moya.MultipartFormData(provider: .data(platformData) , name: "platform"))

		let countryCodeData = Locale.current.countryCode.data(using: String.Encoding.utf8) ?? Data()
		ticket.append(Moya.MultipartFormData(provider: .data(countryCodeData) , name: "country_code"))


		layoutableView.endEditing(true)
		layoutableView.setLoading(true)


		Desk360.apiProvider.request(.create(ticket: ticket)) { [weak self] result in
			guard let self = self else { return }
			self.layoutableView.setLoading(false)
			switch result {
			case .failure(let error):
				print(error.localizedServerDescription)
				if error.response?.statusCode == 400 {
					Desk360.isRegister = false
					Alert.showAlert(viewController: self, title: "Desk360", message: "connection.error.message".localize(), dissmis: true)
					return
				}
				Alert.showAlert(viewController: self, title: "Desk360", message: "connection.error.message".localize(), dissmis: false)
			case .success:
				self.navigationController?.pushViewController(SuccsessViewController(checkLastClass: true), animated: true)
			}
		}
	}

}
