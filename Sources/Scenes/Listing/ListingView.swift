//
//  ListingView.swift
//  Desk360
//
//  Created by samet on 16.05.2019.
//

import UIKit
import DeviceKit

class ListingView: UIView, Layoutable, Loadingable {

	lazy var placeholderView: ListingPlaceholderView = {
		let view = ListingPlaceholderView.create()
		view.isHidden = true
		return view
	}()

	var segmentControlHeight: CGFloat = {
		let diagonal = Device.current.realDevice.diagonal
		if diagonal >= 6 && diagonal < 7 { return 58.0 }
		if diagonal >= 5 && diagonal < 6 { return 55.0 }
		if diagonal >= 4 && diagonal < 5 { return 45.0 }
		return 50.0
	}()

	var items: [String] {
		return [
			"Current",
			"Past"
		]
	}

	lazy var buttonBar: UIView = {
		let view = UIView()
		view.backgroundColor = .white
		return view
	}()
    
    lazy var notifLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = Colors.unreadIconColor
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.textColor = .white
        label.font = .systemFont(ofSize: 11)
        return label
    }()

	lazy var segmentControl: UISegmentedControl = {
		var segmentControl = UISegmentedControl(items: items)
		segmentControl.selectedSegmentIndex = 0
		segmentControl.backgroundColor = .clear
		segmentControl.tintColor = .clear
		if #available(iOS 13.0, *) {
			segmentControl.selectedSegmentTintColor = .clear
		}
		segmentControl.layer.borderColor = UIColor.clear.cgColor

		let selectedattributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
								  NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .regular)]

		let unSelectedattributes = [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.25),
									NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .regular)]
		segmentControl.setTitleTextAttributes(unSelectedattributes as [NSAttributedString.Key: Any], for: .normal)
		segmentControl.setTitleTextAttributes(selectedattributes as [NSAttributedString.Key: Any], for: .selected)
		segmentControl.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
		segmentControl.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)

		return segmentControl
	}()

	lazy var tableView: UITableView = {
		let view = UITableView()
		view.separatorStyle = .none
		view.contentInset = UIEdgeInsets(top: preferredSpacing, left: 0, bottom: preferredSpacing, right: 0)
		view.rowHeight = UITableView.automaticDimension
		view.estimatedRowHeight = 90.0
		view.showsVerticalScrollIndicator = false
		return view
	}()

	lazy var emptyView: UIView = {
		let view = UIView()
		view.isHidden = true
		view.addSubview(emptyImageView)
		view.addSubview(emptyTextLabel)
		return view
	}()

	lazy var emptyTextLabel: UILabel = {
		let label = UILabel()
		label.numberOfLines = 0
		label.adjustsFontSizeToFitWidth = false
		label.textAlignment = .center
		label.text = "You have no resolved support requests"
		return label
	}()

	private lazy var emptyImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.image = Desk360.Config.Images.emptyIcon
		imageView.contentMode = .scaleAspectFit
		return imageView
	}()

    lazy var desk360BottomView: Desk360View = {
        let view = Desk360View.create()
        view.isHidden = Config.shared.model?.generalSettings?.isLogoHidden ?? false
		return view
	}()

	public override var backgroundColor: UIColor? {
		didSet {
			tableView.backgroundColor = backgroundColor
		}
	}

	func setupViews() {
		backgroundColor = .white
		addSubview(tableView)
		addSubview(emptyView)
		addSubview(desk360BottomView)
		addSubview(placeholderView)
        addSubview(segmentControl)
        addSubview(buttonBar)
        addSubview(notifLabel)
	}

	func setupLayout() {
		emptyImageView.snp.makeConstraints { make in
			make.centerX.equalToSuperview()
			make.top.lessThanOrEqualToSuperview().inset(preferredSpacing * 5 )
		}

		emptyTextLabel.snp.makeConstraints { make in
			make.top.equalTo(emptyImageView.snp.bottom).offset(preferredSpacing  * 2)
			make.leading.trailing.equalToSuperview().inset(preferredSpacing * 2)
		}

		buttonBar.snp.makeConstraints { make in
			make.leading.equalTo(segmentControl.snp.leading)
			make.bottom.equalTo(segmentControl.snp.bottom)
			make.width.equalTo(segmentControl.snp.width).multipliedBy(0.5)
			make.height.equalTo(3)
		}

		segmentControl.snp.makeConstraints { make in
 			make.leading.top.trailing.equalToSuperview()
 			make.height.equalTo(segmentControlHeight)
 		}

		tableView.snp.makeConstraints { make in
            make.top.equalTo(segmentControl.snp.bottom).offset(-20)
			make.leading.trailing.equalToSuperview()
			make.bottom.equalTo(desk360BottomView.snp.top)
		}

		emptyView.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview()
			make.top.equalTo(tableView.snp.top)
			make.bottom.equalTo(tableView.snp.bottom)
		}

		desk360BottomView.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview()
			make.height.equalTo(preferredSpacing * 1.5)
			make.bottom.equalTo(safeArea.bottom)
		}

		placeholderView.snp.makeConstraints { make in
			make.leading.trailing.top.equalToSuperview()
			make.bottom.equalTo(desk360BottomView.snp.top)
		}
        
        notifLabel.snp.makeConstraints { make in
            make.trailing.equalTo(segmentControl).multipliedBy(0.5).inset(20)
            make.top.equalTo(segmentControl).offset(10)
            make.height.equalTo(20)
            make.width.equalTo(20)
        }
	}

	func showPlaceholder(_ show: Bool) {
		placeholderView.isHidden = !show
		placeholderView.configure()
		guard show else { return }
		tableView.backgroundColor = Colors.backgroundColor
	}
}

// MARK: - Config
extension ListingView {

	func configure() {
		self.backgroundColor = Colors.backgroundColor
		emptyView.backgroundColor = Colors.ticketListingScreenBackgroudColor
		tableView.backgroundColor = Colors.ticketListingScreenBackgroudColor
		configureSegmentedControl()
		emptyTextLabel.textColor = Colors.ticketListingScreenTabTextColor
		emptyImageView.tintColor = Colors.ticketListingScreenTabTextActiveColor
		placeholderView.configure()
	}

	func configureSegmentedControl() {
		segmentControl.backgroundColor = Colors.backgroundColor
		buttonBar.backgroundColor = Colors.ticketListingScreenTabActiveBorderColor
		segmentControl.tintColor = .clear
		if #available(iOS 13.0, *) {
			segmentControl.selectedSegmentTintColor = .clear
		}
		segmentControl.isOpaque = true
		segmentControl.layer.borderColor = UIColor.clear.cgColor
		segmentControl.layer.cornerRadius = 0
		segmentControl.layer.masksToBounds = true

		let fontWeight = Font.weight(type: Config.shared.model?.ticketListingScreen?.tabTextFontWeight ?? 400)
		let fontSize = CGFloat(Config.shared.model?.ticketListingScreen?.tabTextFontSize ?? 18)

		let selectedattributes = [NSAttributedString.Key.foregroundColor: Colors.ticketListingScreenTabTextActiveColor,
								  NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize, weight: fontWeight)]

		let unSelectedattributes = [NSAttributedString.Key.foregroundColor: Colors.ticketListingScreenTabTextColor,
									NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize, weight: fontWeight)]

		segmentControl.setTitleTextAttributes(unSelectedattributes as [NSAttributedString.Key: Any], for: .normal)
		segmentControl.setTitleTextAttributes(selectedattributes as [NSAttributedString.Key: Any], for: .selected)
		segmentControl.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
		segmentControl.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
		segmentControl.layer.borderColor = UIColor.clear.cgColor
		segmentControl.setTitle(Config.shared.model?.ticketListingScreen?.tabCurrentText, forSegmentAt: 0)
		segmentControl.setTitle(Config.shared.model?.ticketListingScreen?.tabPastText, forSegmentAt: 1)
	}
}
