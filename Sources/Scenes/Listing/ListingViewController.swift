//
//  ListingViewController.swift
//  Desk360
//
//  Created by samet on 18.05.19
//

import UIKit
import SnapKit

protocol ListingViewControllerDelegate: AnyObject {
    
    func listingViewController(_ viewController: ListingViewController, didSelectTicket ticket: Ticket)
    
}

final class ListingViewController: UIViewController, Layouting, UITableViewDelegate, UITableViewDataSource {
    
    typealias ViewType = ListingView
    
    weak var delegate: ListingViewControllerDelegate?
    
    convenience init(tickets: [Ticket]) {
        self.init()
        self.requests = tickets
    }
    
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
    
    var filterTickets: [Ticket] = []
    var isConfigFethecOnce: Bool = false

    override func loadView() {
        view = ViewType.create()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.setColors(background: .white, text: .white)
        layoutableView.placeholderView.createRequestButton.addTarget(self, action: #selector(didTapCreateRequestButton), for: .touchUpInside)
        layoutableView.segmentControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        
        setLoadingabletConfig()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Desk360.isActive = true
        
        navigationItem.leftBarButtonItem = NavigationItems.close(target: self, action: #selector(didTapCloseButton))
        //		segmentcontrolButtonBarLayout()
        initialView()
        
        try? Stores.registerCacheModel.save(Stores.registerModel.object)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let count = navigationController?.viewControllers.count ?? 0
        guard count > 1 else { return }
        navigationController?.viewControllers.removeSubrange(0..<count-1)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.layoutableView.placeholderView.bottomScrollView.contentSize = CGSize(width: self.layoutableView.placeholderView.bottomScrollView.frame.size.width, height: self.layoutableView.placeholderView.bottomDescriptionLabel.frame.size.height)
        
        self.layoutableView.placeholderView.bottomScrollView.setContentOffset(CGPoint(x: 0, y: 2), animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        setCreateNavButtonItem(show: !requests.isEmpty)
        return filterTickets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(ListingTableViewCell.self)
        cell.configure(for: filterTickets.sorted()[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let request = filterTickets[indexPath.row]
        guard request.id != -1 else { return }
        let viewController = ConversationViewController(request: request)
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isHighlighted = true
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isHighlighted = false
    }
    
    @objc private func didTapCreateBarButtonItem(_ item: UIBarButtonItem) {
        navigationController?.pushViewController(CreateRequestPreviewController(checkLastClass: false), animated: true)
    }
    
    @objc private func didTapCreateRequestButton(_ button: UIButton) {
        navigationController?.pushViewController(CreateRequestViewController(checkLastClass: false), animated: true)
    }
    
}

// MARK: - Desk360 Start
extension ListingViewController {
    
    func initialView() {
        requests = Stores.ticketsStore.allObjects().sorted()
		
        configureLayoutableView()
		
        if layoutableView.segmentControl.selectedSegmentIndex == 0 {
            filterTickets = requests.filter({ $0.status != .expired })
        } else {
            filterTickets = requests.filter({ $0.status == .expired })
        }
        
        filterTickets = filterTickets.sorted()
        
        layoutableView.tableView.dataSource = self
        layoutableView.tableView.delegate = self
        layoutableView.tableView.reloadData()
        
        if let token = Stores.tokenStore.object {
            Desk360.token = token
        }
        
        let registerModel = Stores.registerCacheModel.object
        
        guard registerModel?.appId == Desk360.appId && registerModel?.deviceId == Desk360.deviceId &&  Desk360Environment(rawValue: registerModel?.environment ?? ".test")  == Desk360.environment else {
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
    
    func getAsyncRequest() {
        
        getConfig(showLoading: false)
        //		if Stores.configStore.object != nil {
        //
        //		} else {
        //			getConfig(showLoading: true)
        //		}
        
    }
    
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
    
    func setLoadingabletConfig() {
        LoadingableConfig.indicatorBackgroundColor = .clear
        LoadingableConfig.indicatorType = .circleStrokeSpin
        LoadingableConfig.indicatorTintColor = .black
    }
    
    func setCreateNavButtonItem(show: Bool) {
        guard show else {
            navigationItem.rightBarButtonItem = nil
            return
        }
        navigationItem.rightBarButtonItem = NavigationItems.add(target: self, action: #selector(didTapCreateBarButtonItem(_:)))
    }
    
    func checkNotificationDeeplink() {
        guard let id = Desk360.messageId else { return }
        Desk360.messageId = nil
        for request in requests where request.id == id {
            let viewController = ConversationViewController(request: request)
            viewController.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(viewController, animated: false)
        }
    }
    
}

// MARK: - Actions
extension ListingViewController {
    
    @objc func segmentedControlValueChanged() {
        segmentcontrolButtonBarLayout()
    }
    
    @objc func didTapCloseButton() {
        Desk360.isActive = false
        dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapBackButton() {
        if navigationController?.presentingViewController == nil {
            navigationController?.popViewController(animated: true)
        } else {
            Desk360.isActive = false
            navigationController?.dismiss(animated: true, completion: nil)
        }
    }
}

// MARK: - Networking
private extension ListingViewController {
    
    func register() {
        
        guard Desk360.appId != nil else {
            Alert.showAlertWithDismiss(viewController: self, title: "Desk360", message: "general.error.message".localize(), dissmis: true)
            return
        }
        
        Desk360.apiProvider.request(.register(appKey: Desk360.appId, deviceId: Desk360.deviceId, appPlatform: Desk360.appPlatform, appVersion: Desk360.appVersion, timeZone: Desk360.timeZone, languageCode: Desk360.languageCode)) { [weak self]  result in
            guard let self = self else { return }
            switch result {
            case .failure:
                try? Stores.registerExpiredAt.save(Date().addingTimeInterval(-48 * 3600))
                Alert.showAlertWithDismiss(viewController: self, title: "Desk360", message: "general.error.message".localize(), dissmis: true)
            case .success(let response):
                guard let register = try? response.map(DataResponse<RegisterRequest>.self) else { return }
                Desk360.isRegister = true
                Desk360.token = register.data?.accessToken
                try? Stores.tokenStore.save(register.data?.accessToken)
                try? Stores.registerExpiredAt.save(register.data?.expiredDate)
                Stores.configStore.object == nil ? self.getConfig(showLoading: true) : self.getConfig(showLoading: false)
                
            }
        }
        
    }
    
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
                Alert.showAlertWithDismiss(viewController: self, title: "Desk360", message: "general.error.message".localize(), dissmis: true)
            case .success(let response):
                guard let tickets = try? response.map(DataResponse<[Ticket]>.self) else { return }
                guard let data = tickets.data else { return }
                try? Stores.ticketsStore.save(data)
                Stores.ticketsStore.delete(withId: -1)
                self.requests = Stores.ticketsStore.allObjects().sorted()
                self.refreshView()
                self.layoutableView.showPlaceholder(self.requests.isEmpty)
                self.configureLayoutableView()
                //self.checkNotificationDeeplink()
            }
        }
        
    }
    
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
    
    func getConfig(showLoading: Bool) {
        
        if isConfigFethecOnce {
            return
        }
        
        guard Desk360.isReachable else {
            networkError()
            return
        }
        
        layoutableView.setLoading(showLoading)
        
        Desk360.apiProvider.request(.getConfig(language: Desk360.languageCode)) { [weak self] result in
            guard let self = self else { return }
            self.layoutableView.setLoading(false)
            switch result {
            case .failure(let error):
                if error.response?.statusCode == 400 {
                    Desk360.isRegister = false
                    Alert.showAlertWithDismiss(viewController: self, title: "Desk360", message: "general.error.message".localize(), dissmis: true)
                    return
                }
                Alert.showAlertWithDismiss(viewController: self, title: "Desk360", message: "general.error.message".localize(), dissmis: true)
                print(error.localizedDescription)
                print("error.localizedDescription")
            case .success(let response):
                self.isConfigFethecOnce = true
                guard let config = try? response.map(DataResponse<ConfigModel>.self) else { return }
                guard let configData = config.data else { return }
                Config.shared.updateConfig(configData)
                try? Stores.configStore.save(configData)
                self.fetchRequests(showLoading: false)
            }
        }
        
    }
    
    func refreshView() {
        if layoutableView.segmentControl.selectedSegmentIndex == 0 {
            filterTickets = requests.filter({ $0.status != .expired })
            layoutableView.emptyTextLabel.text = Config.shared.model?.ticketListingScreen?.emptyCurrentText
        } else {
            filterTickets = requests.filter({ $0.status == .expired })
            layoutableView.emptyTextLabel.text = Config.shared.model?.ticketListingScreen?.emptyPastText
        }
        
        filterTickets.sorted()
        layoutableView.emptyView.isHidden = !filterTickets.isEmpty
        
        self.layoutableView.tableView.reloadData()
    }
    
    func networkError() {
        layoutableView.setLoading(false)
        
        let cancel = "cancel.button".localize()
        let tryAgain = "try.again.button".localize()
        
        Alert.shared.showAlert(viewController: self, withType: .info, title: "Desk360", message: "connection.error.message".localize(), buttons: [cancel,tryAgain], dismissAfter: 0.1) { [weak self] value in
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
    
    func configureLayoutableView() {
        var title = ""
        if self.requests.isEmpty {
            title = Config.shared.model?.firstScreen?.navigationTitle ?? ""
        } else {
            title = Config.shared.model?.ticketListingScreen?.title ?? ""
        }
        
        let selectedattributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                  NSAttributedString.Key.font: UIFont.systemFont(ofSize: CGFloat(Config.shared.model?.generalSettings?.navigationTitleFontSize ?? 16), weight: Font.weight(type: Config.shared.model?.generalSettings?.navigationTitleFontWeight ?? 400)), NSAttributedString.Key.shadow: NSShadow() ]
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
        
        guard Config.shared.model?.generalSettings?.navigationShadow ?? false else { return }
        
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize.zero
        self.navigationController?.navigationBar.layer.shadowRadius = 10
        self.navigationController?.navigationBar.layer.shadowOpacity = 1.0
        self.navigationController?.navigationBar.layer.masksToBounds = false
    }
}
