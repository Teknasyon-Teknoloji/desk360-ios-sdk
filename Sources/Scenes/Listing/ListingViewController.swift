//
//  ListingViewController.swift
//  Desk360
//
//  Created by Omar on 5/16/19.
//

import UIKit

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
			layoutableView.tableView.reloadData()
		}
	}

	override func loadView() {
		view = ViewType.create()
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		layoutableView.tableView.dataSource = self
		layoutableView.tableView.delegate = self

		layoutableView.placeholderView.createRequestButton.addTarget(self, action: #selector(didTapCreateRequestButton), for: .touchUpInside)

		setLoadingabletConfig()

	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		navigationItem.title = Desk360.Strings.Support.listingNavTitle
		navigationItem.leftBarButtonItem = NavigationItems.close(target: self, action: #selector(didTapCloseButton))

		requests = Stores.ticketsStore.allObjects().sorted()
		fetchRequests(showLoading: requests.isEmpty)
		layoutableView.tableView.reloadData()
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		setCreateNavButtonItem(show: !requests.isEmpty)
		return requests.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(ListingTableViewCell.self)
		cell.configure(for: requests[indexPath.row])
		return cell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let request = requests[indexPath.row]
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
		navigationController?.pushViewController(CreateRequestViewController(checkLastClass: false), animated: true)
	}

	@objc private func didTapCreateRequestButton(_ button: UIButton) {
		navigationController?.pushViewController(CreateRequestViewController(checkLastClass: false), animated: true)
	}

}

// MARK: - Helpers
private extension ListingViewController {

	func setLoadingabletConfig() {
		LoadingableConfig.indicatorBackgroundColor = .clear
		LoadingableConfig.indicatorType = .circleStrokeSpin
		LoadingableConfig.indicatorTintColor = Desk360.Config.currentTheme.listingCellTintColor
	}

	func setCreateNavButtonItem(show: Bool) {
		guard show else {
			navigationItem.rightBarButtonItem = nil
			return
		}

		navigationItem.rightBarButtonItem = NavigationItems.add(target: self, action: #selector(didTapCreateBarButtonItem(_:)))

	}

}

// MARK: - Actions
extension ListingViewController {

	@objc
	func didTapCloseButton() {
		dismiss(animated: true, completion: nil)
	}

	@objc func didTapBackButton() {
		if navigationController?.presentingViewController == nil {
			navigationController?.popViewController(animated: true)
		} else {
			navigationController?.dismiss(animated: true, completion: nil)
		}
	}
}

// MARK: - Networking
private extension ListingViewController {

	func fetchRequests(showLoading: Bool) {

		if showLoading {
			layoutableView.setLoading(true)
		}

		guard Desk360.isReachable else {
			networkError()
			return
		}

		Desk360.apiProvider.request(.getTickets) { [weak self] result in
			self?.layoutableView.setLoading(false)
			guard let self = self else { return }
			switch result {
			case .failure(let error):
				if error.response?.statusCode == 400 {
					Desk360.register()
					Alert.showAlert(viewController: self, title: "Desk360", message: "connection.error.message".localize(), dissmis: true)
					return
				}
				Alert.showAlert(viewController: self, title: "Desk360", message: "connection.error.message".localize(), dissmis: true)
				print(error.localizedDescription)
			case .success(let response):
				guard let tickets = try? response.map(DataResponse<[Ticket]>.self) else { return }
				guard let data = tickets.data else { return }
				try? Stores.ticketsStore.save(data.sorted())
				self.requests = data
				self.layoutableView.tableView.reloadData()
				self.layoutableView.showPlaceholder(self.requests.isEmpty)
			}
		}

	}

	func networkError() {
		layoutableView.setLoading(false)
		Alert.showAlert(viewController: self, title: "Desk360", message: "connection.error.message".localize(), dissmis: true)
	}

}
