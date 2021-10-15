//
//  ListingViewController.swift
//  Desk360
//
//  Created by samet on 18.05.19
//

import UIKit
import SnapKit

/// `ListingViewController`
final class ListingViewController: UIViewController, Layouting, UITableViewDelegate, UITableViewDataSource {

    typealias ViewType = ListingView

    var refreshIcon = UIImageView()
    var aiv = UIActivityIndicatorView()
    var isDragReleased = false
	
	/// Initializes a document of a specified type.
	/// - Parameter tickets: tickets for listing
    convenience init(tickets: [Ticket]) {
        self.init()
        self.requests = tickets
    }
	
	/// Tickets array for listing
    var requests: [Ticket] = [] {
        didSet {
            if layoutableView.segmentControl.selectedSegmentIndex == 0 {
                filterTickets = requests.filter({ $0.status != .expired })
            } else {
                filterTickets = requests.filter({ $0.status == .expired })
            }
            self.setTicketWithMessageStore()
            filterTickets = filterTickets.sorted()
            layoutableView.placeholderView.isHidden = !requests.isEmpty
            layoutableView.tableView.reloadData()

        }
    }

	/// Filtered tickets array for listing with
    var filterTickets: [Ticket] = []
    var isConfigFethecOnce: Bool = false
	
	/// Creates the view that the controller manages.
    override func loadView() {
        view = ViewType.create()
    }
	
	/// Called after the controller's view is loaded into memory.
    override func viewDidLoad() {
        super.viewDidLoad()
        Desk360.list = self
        self.navigationController?.navigationBar.setColors(background: .white, text: .white)
        layoutableView.placeholderView.createRequestButton.addTarget(self, action: #selector(didTapCreateRequestButton), for: .touchUpInside)
        layoutableView.segmentControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        setLoadingabletConfig()
    }
	
	/// Notifies the view controller that its view is about to be added to a view hierarchy.
	/// - Parameter animated: If true, the view is being added to the window using an animation.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Desk360.isActive = true

        navigationItem.leftBarButtonItem = NavigationItems.close(target: self, action: #selector(didTapCloseButton))
        initialView()

        try? Stores.registerCacheModel.save(Stores.registerModel.object)

        checkForUnreadMessageIcon()
    }
	
	/// Called to notify the view controller that its view has just laid out its subviews.
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.layoutableView.placeholderView.bottomScrollView.contentSize = CGSize(width: self.layoutableView.placeholderView.bottomScrollView.frame.size.width, height: self.layoutableView.placeholderView.bottomDescriptionLabel.frame.size.height)

        self.layoutableView.placeholderView.bottomScrollView.setContentOffset(CGPoint(x: 0, y: 2), animated: true)

    }
	
	/// Tells the data source to return the number of rows in a given section of a table view. Required.
	/// - Parameters:
	///   - tableView: The table-view object requesting this information.
	///   - section: An index number identifying a section in tableView.
	/// - Returns: The number of rows in section.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        setCreateNavButtonItem(show: !requests.isEmpty)
        return filterTickets.count
    }
	
	/// Asks the data source for a cell to insert in a particular location of the table view. Required.
	/// - Parameters:
	///   - tableView: A table-view object requesting the cell.
	///   - indexPath: An index path locating a row in tableView.
	/// - Returns: An object inheriting from UITableViewCell that the table view can use for the specified row. UIKit raises an assertion if you return nil.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(ListingTableViewCell.self)
        cell.configure(for: filterTickets.sorted()[indexPath.row])
        return cell
    }
	
	/// Tells the delegate a row is selected.
	/// - Parameters:
	///   - tableView: A table view informing the delegate about the new row selection.
	///   - indexPath: An index path locating the new selected row in tableView.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let request = filterTickets[indexPath.row]
        guard request.id != -1 else { return }
        let viewController = ConversationViewController(request: request)
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
	
	/// Tells the delegate that the specified row was highlighted.
	/// - Parameters:
	///   - tableView: The table view that highlighted the cell.
	///   - indexPath: The index path of the row that was highlighted.
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isHighlighted = true
    }
	
	/// Tells the delegate that the highlight was removed from the row at the specified index path.
	/// - Parameters:
	///   - tableView: The table view that removed the highlight from the cell.
	///   - indexPath: The index path of the row that had its highlight removed.
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isHighlighted = false
    }
	
	/// Create Bar Button request button action
    @objc private func didTapCreateBarButtonItem() {
        guard let props = Desk360.properties else { return }
        if props.bypassCreateTicketIntro {
            navigationController?.pushViewController(CreateRequestViewController(), animated: true)
        } else {
            navigationController?.pushViewController(CreateRequestPreviewController(), animated: true)
        }
    }
	
	/// Create request button action
    @objc private func didTapCreateRequestButton() {
        navigationController?.pushViewController(CreateRequestViewController(checkLastClass: false), animated: true)
    }
}

// MARK: - Desk360 Start
extension ListingViewController {
	
	/// Filtering tickets with expire status
    func filterTicketsForSegment() {
        if layoutableView.segmentControl.selectedSegmentIndex == 0 {
            filterTickets = requests.filter({ $0.status != .expired })
        } else {
            filterTickets = requests.filter({ $0.status == .expired })
        }

        filterTickets = filterTickets.sorted()
    }
	
	/// Initialize listing view
    func initialView() {
        requests = Stores.ticketsStore.allObjects().sorted()

        configureLayoutableView()

        filterTicketsForSegment()

        layoutableView.tableView.dataSource = self
        layoutableView.tableView.delegate = self
        layoutableView.tableView.reloadData()

        Desk360.token = Stores.tokenStore.object()

		guard let registerModel = Stores.registerCacheModel.object else { return }
		guard let desk360Properties = Desk360.properties else { return }

		guard registerModel.appId == desk360Properties.appID &&
				registerModel.deviceId == desk360Properties.deviceID &&
				registerModel.environment == desk360Properties.environment.stringValue else {
			layoutableView.placeholderView.isHidden = true
            Stores.ticketsStore.deleteAll()
            Stores.tokenStore.delete()
            Stores.registerCacheModel.delete()
            try? Stores.registerExpiredAt.save(Date().addingTimeInterval(-36 * 3600))
            requests = []
            layoutableView.setLoading(true)
            register()
            return
        }

        guard let expiredAt = Stores.registerExpiredAt.object else {
            register()
            return
        }

        guard expiredAt > Date() else {
            register()
            return
        }

        checkNotificationDeeplink()
        getAsyncRequest()
    }
}

// MARK: - Helpers
extension ListingViewController {
	
	/// Checking unread message icon
    func checkForUnreadMessageIcon() {
        let undreadCount = filterTickets.filter({$0.status == .unread}).count
        layoutableView.notifLabel.isHidden = undreadCount <= 0
        guard undreadCount > 0 else { return }
        layoutableView.notifLabel.isHidden = false
        layoutableView.notifLabel.text = "\(undreadCount)"
    }
	
	/// Fetching config for listing view from backend. This request is async so that the user does not wait
    func getAsyncRequest() {

        getConfig(showLoading: false)
    }
	
	/// Remake segmented control button bar layouts with animation
    func segmentcontrolButtonBarLayout() {
        self.layoutableView.buttonBar.snp.remakeConstraints { make in
            make.leading.equalTo((self.layoutableView.segmentControl.frame.width / CGFloat(self.layoutableView.segmentControl.numberOfSegments)) * CGFloat(self.layoutableView.segmentControl.selectedSegmentIndex))
            make.bottom.equalTo(self.layoutableView.segmentControl.snp.bottom)
            make.width.equalTo(UIScreen.main.bounds.width * 0.5)
            make.height.equalTo(3)
        }

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.3, options: .curveEaseInOut, animations: {
            self.layoutableView.layoutIfNeeded()
            self.refreshView()
        }, completion: nil )
    }
	
	/// Set loading indicator config
    func setLoadingabletConfig() {
        LoadingableConfig.indicatorBackgroundColor = .clear
        LoadingableConfig.indicatorType = .circleStrokeSpin
        LoadingableConfig.indicatorTintColor = .black
    }
	
	/// Create navigation right bar button
	/// - Parameter show: Bool value for showing create button
    func setCreateNavButtonItem(show: Bool) {
        guard show else {
            navigationItem.rightBarButtonItem = nil
            return
        }
        navigationItem.rightBarButtonItem = NavigationItems.add(target: self, action: #selector(didTapCreateBarButtonItem))
    }

	/// Check Notification direction deeplink
    func checkNotificationDeeplink() {
        guard let id = Desk360.messageId else { return }
        if UIApplication.shared.applicationState != .active {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.checkNotificationDeeplink()
            }
            return
        }
        Desk360.messageId = nil
        Desk360.didTapNotification = false
        for request in requests where request.id == id {
            let viewController = ConversationViewController(request: request)
            viewController.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(viewController, animated: false)
        }
    }

}

// MARK: - Actions
extension ListingViewController {
	
	/// After segmented control value changed
    @objc func segmentedControlValueChanged() {
        segmentcontrolButtonBarLayout()
    }
	
	/// Close Button Action
    @objc func didTapCloseButton() {
        Desk360.isActive = false
        Desk360.conVC = nil
        Desk360.list = nil
        dismiss(animated: true, completion: nil)
    }
	
	/// Back button action
    @objc func didTapBackButton() {
        if navigationController?.presentingViewController == nil {
            navigationController?.popViewController(animated: true)
        } else {
            Desk360.isActive = false
            navigationController?.dismiss(animated: true, completion: nil)
        }
    }
	
	/// Fecthing request for tickets
    func fetchList() {
        fetchRequests(showLoading: false)
    }
}

// MARK: - Networking
private extension ListingViewController {
	
	/// Registiration for device from backend
    func register() {

        guard let props = Desk360.properties else {
            Alert.showAlertWithDismiss(viewController: self, title: "Desk360", message: "general.error.message".localize(), dissmis: true)
            return
        }

        Desk360.apiProvider.request(.register(appKey: props.appID, deviceId: props.deviceID, appPlatform: props.appPlatform, appVersion: Desk360.appVersion, timeZone: props.timeZone, languageCode: props.language)) { [weak self]  result in
            guard let self = self else { return }
            switch result {
            case .failure:
                try? Stores.registerExpiredAt.save(Date().addingTimeInterval(-48 * 3600))
                Alert.showAlertWithDismiss(viewController: self, title: "Desk360", message: "general.error.message".localize(), dissmis: true)
            case .success(let response):
                guard let register = try? response.map(DataResponse<RegisterRequest>.self) else { return }
                Desk360.isRegister = true
                Desk360.token = register.data?.accessToken
                try? Stores.tokenStore.save(register.data?.accessToken ?? "")
                try? Stores.registerExpiredAt.save(register.data?.expiredDate)
                Stores.configStore.object == nil ? self.getConfig(showLoading: true) : self.getConfig(showLoading: false)

            }
        }
    }
	
	/// Fetching tickets for list from backend
	/// - Parameter showLoading: Bool value for loading showing
    func fetchRequests(showLoading: Bool) {
        if showLoading {
            layoutableView.setLoading(true)
        }

        guard Desk360.isReachable else {
            networkError()
            return
        }

        Desk360.apiProvider.request(.getTickets) { [weak self] result in
            guard let self = self else { return }
            self.layoutableView.setLoading(false)
            switch result {
            case .failure(let error):
                if error.response?.statusCode == 400 {
                    Desk360.isRegister = false
                    Alert.showAlertWithDismiss(viewController: self, title: "Desk360", message: "general.error.message".localize(), dissmis: true)
                    return
                }
            case .success(let response):
                guard let tickets = try? response.map(DataResponse<[Ticket]>.self) else { return }
                guard let data = tickets.data else { return }
                try? Stores.ticketsStore.save(data)
                Stores.ticketsStore.delete(withId: -1)
                self.requests = Stores.ticketsStore.allObjects().sorted()
                self.refreshView()
                self.filterTicketsForSegment()
                self.layoutableView.showPlaceholder(self.requests.isEmpty)
                self.configureLayoutableView()
                self.checkForUnreadMessageIcon()
                // self.checkNotificationDeeplink()
            }
        }
    }
	
	/// Set tickets from local cache.
    func setTicketWithMessageStore() {
        let tickets = Stores.ticketsStore.allObjects().sorted()
        let ticketsWithMessages = Stores.ticketWithMessageStore.allObjects()
        Stores.ticketWithMessageStore.deleteAll()
        for ticket in tickets {
            let currentTicketWithMessage = ticketsWithMessages.filter({ $0.id == ticket.id })
            var currentTicket = ticket
            if !currentTicketWithMessage.isEmpty {
                currentTicket.messages = currentTicketWithMessage.first?.messages ?? []
            }
            try? Stores.ticketWithMessageStore.save(currentTicket)
        }
    }
	
	/// Fetching config for listing view from backend
	/// - Parameter showLoading: Bool value for loading showing
    func getConfig(showLoading: Bool) {
        fetchRequests(showLoading: false)
        if isConfigFethecOnce {
            return
        }

        guard Desk360.isReachable else {
            networkError()
            return
        }

        layoutableView.setLoading(showLoading)
        guard let props = Desk360.properties else {
            Alert.showAlertWithDismiss(viewController: self, title: "Desk360", message: "general.error.message".localize(), dissmis: true)
            return }
        Desk360.apiProvider.request(.getConfig(language: props.language, country: props.country)) { [weak self] result in
            guard let self = self else { return }
            self.layoutableView.setLoading(false)
            switch result {
            case .failure(let error):
                if error.response?.statusCode == 400 {
                    Desk360.isRegister = false
                    Alert.showAlertWithDismiss(viewController: self, title: "Desk360", message: "general.error.message".localize(), dissmis: true)
                    return
                }
            case .success(let response):
                self.isConfigFethecOnce = true
                guard let config = try? response.map(DataResponse<ConfigModel>.self) else { return }
                guard let configData = config.data else { return }
                Config.shared.updateConfig(configData)
                try? Stores.configStore.save(configData)
                self.fetchRequests(showLoading: false)
                self.layoutableView.desk360BottomView.isHidden = Config.shared.model?.generalSettings?.isLogoHidden ?? false
            }
        }
    }
	
	/// View Refreshing
    func refreshView() {
        if layoutableView.segmentControl.selectedSegmentIndex == 0 {
            filterTickets = requests.filter({ $0.status != .expired })
            layoutableView.emptyTextLabel.text = Config.shared.model?.ticketListingScreen?.emptyCurrentText
        } else {
            filterTickets = requests.filter({ $0.status == .expired })
            layoutableView.emptyTextLabel.text = Config.shared.model?.ticketListingScreen?.emptyPastText
        }

        filterTickets.sort()
        layoutableView.emptyView.isHidden = !filterTickets.isEmpty

        self.layoutableView.tableView.reloadData()
    }
	
	/// Network Error Alert Showing
    func networkError() {
        layoutableView.setLoading(false)

        let cancel = "cancel.button".localize()
        let tryAgain = "try.again.button".localize()

        Alert.shared.showAlert(viewController: self, withType: .info, title: "Desk360", message: "connection.error.message".localize(), buttons: [cancel, tryAgain], dismissAfter: 0.1) { [weak self] value in
            guard let self = self else { return }
            if value == 1 {
                self.dismiss(animated: true, completion: nil)
            } else {
                self.initialView()
            }
        }
    }
}

// MARK: - Config
extension ListingViewController {

	/// Configuration for Listing View Controller
    func configureLayoutableView() {
        var title = ""
        if self.requests.isEmpty {
            title = Config.shared.model?.firstScreen?.navigationTitle ?? ""
        } else {
            title = Config.shared.model?.ticketListingScreen?.title ?? ""
        }

        let selectedattributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: CGFloat(Config.shared.model?.generalSettings?.navigationTitleFontSize ?? 16), weight: Font.weight(type: Config.shared.model?.generalSettings?.navigationTitleFontWeight ?? 400)), NSAttributedString.Key.shadow: NSShadow()
        ]

        let navigationTitle = NSAttributedString(string: title, attributes: selectedattributes as [NSAttributedString.Key: Any])
        let titleLabel = UILabel()
        titleLabel.attributedText = navigationTitle
        titleLabel.sizeToFit()
        titleLabel.textAlignment = .center
        titleLabel.textColor = Colors.navigationTextColor
        navigationItem.titleView = titleLabel
        self.navigationController?.navigationBar.setColors(background: Colors.navigationBackgroundColor, text: Colors.navigationTextColor )
        navigationController?.navigationBar.tintColor = Colors.navigationImageViewTintColor
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()

        layoutableView.configure()

        aiv = UIActivityIndicatorView(style: .gray)
        aiv.color = Colors.pdrColor
        aiv.frame.size.height = 20
        refreshIcon = UIImageView(image: Desk360.Config.Images.arrowDownIcon)
        let view = UIView(frame: CGRect(x: (UIScreen.main.bounds.size.width / 2)-17, y: 0, width: 34, height: 20))
        view.backgroundColor = layoutableView.tableView.backgroundColor
        refreshIcon.frame = CGRect(x: (view.frame.size.width / 2)-7, y: 0, width: 14, height: 19)
        refreshIcon.backgroundColor = layoutableView.tableView.backgroundColor
        refreshIcon.isHidden = true
        aiv.hidesWhenStopped = false
        view.addSubview(refreshIcon)
        aiv.addSubview(view)
        layoutableView.tableView.tableHeaderView = aiv

        guard Config.shared.model?.generalSettings?.navigationShadow ?? false else { return }

        self.navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize.zero
        self.navigationController?.navigationBar.layer.shadowRadius = 10
        self.navigationController?.navigationBar.layer.shadowOpacity = 1.0
        self.navigationController?.navigationBar.layer.masksToBounds = false
    }
	
	/// Tells the delegate when dragging ended in the scroll view.
	/// - Parameters:
	///   - scrollView: The scroll-view object that finished scrolling the content view.
	///   - decelerate: YES if the scrolling movement will continue, but decelerate, after a touch-up gesture during a dragging operation. If the value is NO, scrolling stops immediately upon touch-up.
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if aiv.isAnimating == false {
            hidePDR()
        }
    }
	
	/// Tells the delegate that the scroll view has ended decelerating the scrolling movement.
	/// - Parameter scrollView: The scroll-view object that is decelerating the scrolling of the content view.
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if aiv.isAnimating == false {
            hidePDR()
        }
    }
	
	/// Tells the delegate when the scroll view is about to start scrolling the content.
	/// - Parameter scrollView: The scroll-view object that is about to scroll the content view.
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isDragReleased = false
        refreshIcon.isHidden = false
        if aiv.isAnimating {
            return
        }
    }
	
	/// Tells the delegate when the user finishes scrolling the content.
	/// - Parameters:
	///   - scrollView: The scroll-view object where the user ended the touch..
	///   - velocity: The velocity of the scroll view (in points) at the moment the touch was released.
	///   - targetContentOffset: The expected offset when the scrolling action decelerates to a stop.
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        isDragReleased = true
        if aiv.isAnimating == false {
            hidePDR()
        }
    }
	
	/// Tells the delegate when the user scrolls the content view within the receiver.
	/// - Parameter scrollView: The scroll-view object in which the scrolling occurred.
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
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

            UIView.animate(withDuration: 0.1, animations: {
                self.aiv.startAnimating()
                self.refreshIcon.transform = CGAffineTransform(rotationAngle: .pi)

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.refreshIcon.isHidden = true
                    self.refreshIcon.superview!.isHidden = true
                    self.aiv.hidesWhenStopped = false
                    self.fetchRequests(showLoading: false)
                }
            })
            return
        }
    }
	
	/// hidePDR
    func hidePDR() {
		//TODO: Ali ile konuş
        refreshIcon.isHidden = true
        self.refreshIcon.superview!.isHidden = true
        aiv.hidesWhenStopped = true
        self.aiv.stopAnimating()
        self.refreshIcon.transform = CGAffineTransform(rotationAngle: 0)
    }
	
	/// showPDR
    func showPDR() {
        refreshIcon.isHidden = true
        self.refreshIcon.superview!.isHidden = true
        aiv.hidesWhenStopped = false
        self.aiv.startAnimating()
    }

}
