//
//  HADropDown.swift
//  MyDropDown
//
//  Created by Hassan Aftab on 22/02/2017.
//  Copyright © 2017 Hassan Aftab. All rights reserved.
//
import UIKit

protocol HADropDownDelegate: class {
	func didSelectItem(dropDown: HADropDown, at index: Int)
	func didShow(dropDown: HADropDown)
	func didHide(dropDown: HADropDown)
	func willHide(dropDown: HADropDown)
	func willShow(dropDown: HADropDown)
}

extension HADropDownDelegate {
	func didSelectItem(dropDown: HADropDown, at index: Int) { }
	func didShow(dropDown: HADropDown) {}
	func didHide(dropDown: HADropDown) {}
	func willShow(dropDown: HADropDown) {}
}

@IBDesignable
// swiftlint:disable file_length
// swiftlint:disable type_body_length
class HADropDown: UIView {

	weak var delegate: HADropDownDelegate!
	fileprivate var label = UILabel()

	fileprivate var placeHolderlabel = UILabel()
	static var frameChange: CGFloat = 0

	static var placeHolderText: String = ""

	@IBInspectable
	var placeHolderText: String {
		set {
			placeHolderlabel.text = newValue
		}
		get {
			return placeHolderlabel.text ?? ""
		}
	}

	@IBInspectable
	var title: String {
		set {
			label.frame = CGRect(x: (UIScreen.main.bounds.size.minDimension * 0.054) * 0.5, y: 0, width: self.frame.width - (UIScreen.main.bounds.size.minDimension * 0.054), height: self.frame.height)
			label.text = newValue
			if UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft {
				label.textAlignment = .right
			} else {
				label.textAlignment = .left
			}

		}
		get {
			return label.text ?? ""
		}
	}

	// swiftlint:disable valid_ibinspectable
	// swiftlint:disable unused_setter_value
	@IBInspectable
	var textAllignment: NSTextAlignment {
		set {
			if UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft {
				label.textAlignment = .right
			} else {
				label.textAlignment = .left
			}
		}
		get {
			return label.textAlignment
		}
	}

	@IBInspectable
	var titleColor: UIColor {
		set {
			label.textColor = newValue
		}
		get {
			return label.textColor
		}
	}

	@IBInspectable
	var titleFontSize: CGFloat {
		set {
			titleFontSize1 = newValue
		}
		get {
			return titleFontSize1
		}
	}
	fileprivate var titleFontSize1: CGFloat = 14.0

	@IBInspectable
	var itemHeight: Double {
		get {
			return itemHeight1
		}
		set {
			itemHeight1 = newValue
		}
	}
	@IBInspectable
	var itemBackground: UIColor {
		set {
			itemBackgroundColor = newValue
		}
		get {
			return itemBackgroundColor
		}
	}

	fileprivate var itemBackgroundColor = UIColor.white

	@IBInspectable
	var itemTextColor: UIColor {
		set {
			itemFontColor = newValue
			if UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft {
				label.textAlignment = .right
			} else {
				label.textAlignment = .left
			}

		}
		get {
			return itemFontColor
		}
	}
	fileprivate var itemFontColor = UIColor.black

	fileprivate var itemHeight1 = 40.0

	@IBInspectable
	var itemFontSize: CGFloat {
		set {
			itemFontSize1 = newValue
		}
		get {
			return itemFontSize1
		}
	}
	fileprivate var itemFontSize1: CGFloat = 14.0

	var itemFont = UIFont.systemFont(ofSize: 14)

	var font: UIFont {
		set {
			selectedFont = newValue
			label.font = selectedFont
		}
		get {
			return selectedFont
		}
	}
	fileprivate var selectedFont = UIFont.systemFont(ofSize: 14)

	var items = [String]()
	fileprivate var selectedIndex = -1

	var isCollapsed = true
	private var table = UITableView()

	// swiftlint:disable implicit_getter
	var getSelectedIndex: Int {
		get {
			return selectedIndex
		}
	}

	private var tapGestureBackground: UITapGestureRecognizer!

	override func prepareForInterfaceBuilder() {
		label.frame = CGRect(x: (UIScreen.main.bounds.size.minDimension * 0.054) * 0.5, y: 0, width: self.frame.width - (UIScreen.main.bounds.size.minDimension * 0.054), height: self.frame.height)
		font = UIFont(descriptor: font.fontDescriptor, size: titleFontSize)
		label.font = font
		self.addSubview(label)
		textAllignment = .left
	}

	override func layoutSubviews() {
		super.layoutSubviews()

		label.frame = CGRect(x: (UIScreen.main.bounds.size.minDimension * 0.054) * 0.5, y: 0, width: self.frame.width - (UIScreen.main.bounds.size.minDimension * 0.054), height: self.frame.height)
		self.addSubview(label)
		textAllignment = .left

		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap(gesture:)))
		self.addGestureRecognizer(tapGesture)
		table.delegate = self
		table.dataSource = self
		var rootView = self.superview

		// here we getting top superview to add table on that.
		while rootView?.superview != nil {
			rootView = rootView?.superview
		}

		let newFrame: CGRect = self.superview!.convert(self.frame, to: rootView)
		self.tableFrame = newFrame
		self.table.frame = CGRect(x: newFrame.origin.x, y: HADropDown.frameChange + (newFrame.origin.y) + (newFrame.height)+5, width: (newFrame.width), height: 0)

		table.backgroundColor = itemBackgroundColor
	}
	// Default tableview frame
	var tableFrame = CGRect.zero

	@objc func didTapBackground(gesture: UIGestureRecognizer) {
		hideList()
	}

	func hideList() {
		isCollapsed = true
		collapseTableView()
	}

	func addTopLabel(text: String, textColor: UIColor, font: UIFont) {
		let label = UILabel()
		label.tag = 1
		label.font = font
		label.frame.size.width = UIScreen.main.bounds.width - ((UIScreen.main.bounds.size.minDimension * 0.054) * 2.5)
		label.frame.size.height = UIScreen.main.bounds.size.minDimension * 0.054 * 0.8
		label.frame.origin.x = 0
		label.frame.origin.y = -(UIScreen.main.bounds.size.minDimension * 0.054) * 0.4
		if UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft {
			label.textAlignment = .right
		} else {
			label.textAlignment = .left
		}
		label.text = text
		label.textColor = textColor
		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.firstLineHeadIndent = UIScreen.main.bounds.size.minDimension * 0.054 * 0.5
		label.attributedText = NSAttributedString(string: text, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
		label.baselineAdjustment = .alignBaselines
		self.clipsToBounds = false
		self.addSubview(label)
	}

	// swiftlint:disable function_body_length
	func addTopLabel2(text: String, textColor: UIColor, font: UIFont) {
		let label = UILabel()
		label.tag = 1
		label.font = font
		label.frame.size.width = UIScreen.main.bounds.width - ((UIScreen.main.bounds.size.minDimension * 0.054) * 2.5)
		label.frame.size.height = UIScreen.main.bounds.size.minDimension * 0.054 * 0.8
		label.frame.origin.x = 0
		label.frame.origin.y = -(UIScreen.main.bounds.size.minDimension * 0.054) * 0.4
		label.text = text
		label.textColor = textColor
		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.firstLineHeadIndent = UIScreen.main.bounds.size.minDimension * 0.054 * 0.5
		label.attributedText = NSAttributedString(string: text, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
		label.baselineAdjustment = .alignBaselines
		self.addSubview(label)

		label.sizeToFit()

		let width = UIScreen.main.bounds.width - ((UIScreen.main.bounds.size.minDimension * 0.054) * 2)
		let height = UITextField.preferredHeight * 1.2

		let bezierPath = UIBezierPath()
		bezierPath.move(to: CGPoint(x: width - 4, y: height))
		bezierPath.addLine(to: CGPoint(x: 4, y: height))
		bezierPath.addCurve(to: CGPoint(x: 0, y: height - 4), controlPoint1: CGPoint(x: 2, y: height), controlPoint2: CGPoint(x: 0, y: height - 2))
		bezierPath.addLine(to: CGPoint(x: 0, y: 4))
		bezierPath.addCurve(to: CGPoint(x: 4, y: 0), controlPoint1: CGPoint(x: 0, y: 2), controlPoint2: CGPoint(x: 2, y: 0))
		bezierPath.addLine(to: CGPoint(x: ((UIScreen.main.bounds.size.minDimension * 0.054) * 0.4), y: 0))
		bezierPath.move(to: CGPoint(x: ((UIScreen.main.bounds.size.minDimension * 0.054) * 0.2) + label.frame.size.width, y: 0))
		bezierPath.addLine(to: CGPoint(x: width - 4, y: 0))
		bezierPath.addCurve(to: CGPoint(x: width, y: 4), controlPoint1: CGPoint(x: width - 2, y: 0), controlPoint2: CGPoint(x: width, y: 2))
		bezierPath.addLine(to: CGPoint(x: width, y: height - 4))
		bezierPath.addCurve(to: CGPoint(x: width - 4, y: height), controlPoint1: CGPoint(x: width, y: height - 2), controlPoint2: CGPoint(x: width - 2, y: height))

		let specialFrameLayer = CAShapeLayer()
		specialFrameLayer.path = bezierPath.cgPath
		specialFrameLayer.frame = CGRect(x: 0,
											y: 0,
											width: width,
											height: height)
		specialFrameLayer.strokeColor = Colors.createScreenFormInputFocusBorderColor.cgColor
		specialFrameLayer.fillColor = UIColor.clear.cgColor
		specialFrameLayer.name = "specialLayer"

		let bezierPathBorder = UIBezierPath()
		bezierPathBorder.move(to: CGPoint(x: width - 4, y: height))
		bezierPathBorder.addLine(to: CGPoint(x: 4, y: height))
		bezierPathBorder.addCurve(to: CGPoint(x: 0, y: height - 4), controlPoint1: CGPoint(x: 2, y: height), controlPoint2: CGPoint(x: 0, y: height - 2))
		bezierPathBorder.addLine(to: CGPoint(x: 0, y: 4))
		bezierPathBorder.addCurve(to: CGPoint(x: 4, y: 0), controlPoint1: CGPoint(x: 0, y: 2), controlPoint2: CGPoint(x: 2, y: 0))
		bezierPathBorder.addLine(to: CGPoint(x: width - 4, y: 0))
		bezierPathBorder.addCurve(to: CGPoint(x: width, y: 4), controlPoint1: CGPoint(x: width - 2, y: 0), controlPoint2: CGPoint(x: width, y: 2))
		bezierPathBorder.addLine(to: CGPoint(x: width, y: height - 4))
		bezierPathBorder.addCurve(to: CGPoint(x: width - 4, y: height), controlPoint1: CGPoint(x: width, y: height - 2), controlPoint2: CGPoint(x: width - 2, y: height))

		let borderLayer = CAShapeLayer()
		borderLayer.path = bezierPathBorder.cgPath
		borderLayer.frame = CGRect(x: 0,
								   y: 0,
								   width: width,
								   height: height)
		borderLayer.strokeColor = Colors.createScreenFormInputBorderColor.cgColor
		borderLayer.fillColor = UIColor.clear.cgColor
		borderLayer.name = "borderLayer"

		if let layers = self.superview?.layer.sublayers {
			for layer in layers where layer is CAShapeLayer {
				layer.removeFromSuperlayer()
			}
		}

		specialFrameLayer.isHidden = true
		self.layer.insertSublayer(borderLayer, below: specialFrameLayer)
		self.layer.insertSublayer(specialFrameLayer, below: label.layer)
	}

	func addTopLabel3(text: String, textColor: UIColor, font: UIFont) {
		let label = UILabel()
		label.tag = 1
		label.font = font
		label.frame.size.width = UIScreen.main.bounds.width - ((UIScreen.main.bounds.size.minDimension * 0.054) * 2.5)
		label.frame.size.height = UIScreen.main.bounds.size.minDimension * 0.054 * 0.8
		label.frame.origin.x = 0
		label.frame.origin.y = 2
		if UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft {
			label.textAlignment = .right
		} else {
			label.textAlignment = .left
		}
		label.adjustsFontSizeToFitWidth = true
		label.text = text
		label.textColor = textColor
		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.firstLineHeadIndent = UIScreen.main.bounds.size.minDimension * 0.054 * 0.5
		label.attributedText = NSAttributedString(string: text, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
		label.baselineAdjustment = .alignCenters
		label.minimumScaleFactor = 0.3
		self.clipsToBounds = false
		self.addSubview(label)
	}

	func addArrowIcon(tintColor: UIColor) {
		let imageView = UIImageView()
		imageView.tag = 2
		imageView.contentMode = .scaleAspectFit
		imageView.image = Desk360.Config.Images.arrowIcon
		imageView.tintColor = tintColor
		self.addSubview(imageView)

		imageView.snp.makeConstraints { make in
			make.trailing.equalToSuperview().inset(UIScreen.main.bounds.size.minDimension * 0.054 * 0.5)
			make.centerY.equalToSuperview()
		}
	}

	func showList() {
		isCollapsed = !isCollapsed
		if !isCollapsed {
			if delegate != nil {
				delegate.willShow(dropDown: self)
			}
			let height: CGFloat = CGFloat(items.count > 5 ? itemHeight*5 : itemHeight*Double(items.count)) + 10
			self.table.layer.zPosition = 1

			self.table.removeFromSuperview()
			self.table.layer.borderColor = Colors.createScreenFormInputFocusColor.cgColor
			self.table.layer.borderWidth = 1
			self.table.layer.cornerRadius = 8
			var rootView = self.superview
			// adding tableview to root view( we can say first view in hierarchy)
			while rootView?.superview != nil {
				rootView = rootView?.superview
			}

			rootView?.addSubview(self.table)

			self.table.reloadData()

//			self.layoutIfNeeded()

			self.table.snp.remakeConstraints { make in
				make.top.equalTo(self.snp.bottom)
				make.leading.equalTo(self.snp.leading)
				make.width.equalTo(self.snp.width)
			}

			UIView.animate(withDuration: 0.1, animations: {
				self.table.snp.makeConstraints { make in
					make.height.equalTo(height)
				}
				self.layoutIfNeeded()
			})

			if delegate != nil {
				delegate.didShow(dropDown: self)
			}
			let view = UIView(frame: UIScreen.main.bounds)
			view.tag = 99121
			rootView?.insertSubview(view, belowSubview: table)

			tapGestureBackground = UITapGestureRecognizer(target: self, action: #selector(didTapBackground(gesture:)))
			view.addGestureRecognizer(tapGestureBackground)
		} else {
			collapseTableView()
		}
	}

	@objc private func didTap(gesture: UIGestureRecognizer) {
		showList()
	}

	func collapseTableView() {
		if delegate != nil {
			delegate.willHide(dropDown: self)
		}

		if isCollapsed {
			// removing tableview from rootview
			UIView.animate(withDuration: 0.1, animations: {
				self.table.frame = CGRect(x: self.tableFrame.origin.x, y: HADropDown.frameChange + self.tableFrame.origin.y+self.frame.height, width: self.frame.width, height: 0)
			})
			var rootView = self.superview

			while rootView?.superview != nil {
				rootView = rootView?.superview
			}
			UIView.animate(withDuration: 0.1, animations: {
				self.table.snp.updateConstraints { make in
					make.height.equalTo(0)
				}
				self.table.superview?.layoutIfNeeded()
			})

			rootView?.viewWithTag(99121)?.removeFromSuperview()
			self.superview?.viewWithTag(99121)?.removeFromSuperview()
			if delegate != nil {
				delegate.didHide(dropDown: self)
			}
		}
	}
}
extension HADropDown: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return items.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
		if cell == nil {
			cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
		}
		cell?.textLabel?.textAlignment = textAllignment
		cell?.textLabel?.text = items[indexPath.row]
		let font = UIFont.systemFont(ofSize: CGFloat(Config.shared.model?.createScreen?.formInputFontSize ?? 16), weight: Font.weight(type: Config.shared.model?.createScreen?.formInputFontWeight ?? 400))

		cell?.textLabel?.font = font

		cell?.textLabel?.textColor = itemTextColor

		if indexPath.row == selectedIndex {
			cell?.accessoryType = .checkmark
		} else {
			cell?.accessoryType = .none
		}

		cell?.backgroundColor = itemBackgroundColor

		cell?.tintColor = self.tintColor

		return cell ?? UITableViewCell()
	}

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return CGFloat(itemHeight)
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		selectedIndex = indexPath.row
		label.text = items[selectedIndex]
		isCollapsed = true
		collapseTableView()
		if delegate != nil {
			delegate.didSelectItem(dropDown: self, at: selectedIndex)
		}
	}

	func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		return UIView()
	}
}
