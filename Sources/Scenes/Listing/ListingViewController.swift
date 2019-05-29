//
//  ListingViewController.swift
//  Desk360
//
//  Created by Omar on 5/16/19.
//

import UIKit

final class ListingViewController: UIViewController, Layouting, UITableViewDelegate, UITableViewDataSource {

	typealias ViewType = ListingView

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

	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		navigationItem.title = Desk360.Strings.Support.createTitle
//		navigationController?.navigationBar.makeTransparent(withTint: Desk360.Config.Requests.Listing.NavItem.tintColor)

		if let icon = Desk360.Config.Requests.Listing.backBarButtonIcon {
			navigationController?.navigationBar.backIndicatorImage = icon
			navigationController?.navigationBar.backIndicatorTransitionMaskImage = icon
			navigationItem.backBarButtonItem = .init(title: "", style: .plain, target: nil, action: nil)
		}

		navigationController?.navigationBar.setColors(background: Desk360.Config.backgroundColor, text: Desk360.Config.Requests.Listing.NavItem.tintColor)

		requests = Stores.ticketsStore.allObjects().sorted()
		fetchRequests(showLoading: requests.isEmpty)
		layoutableView.tableView.reloadData()
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		setCreateNavButtonItem(show: !requests.isEmpty)
		return requests.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(RequestTableViewCell.self)
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

	func setCreateNavButtonItem(show: Bool) {
		guard show else {
			navigationItem.rightBarButtonItem = nil
			return
		}

		if let icon = Desk360.Config.Requests.Listing.NavItem.icon {
			navigationItem.rightBarButtonItem = UIBarButtonItem(image: icon, style: .plain, target: self, action: #selector(didTapCreateBarButtonItem(_:)))
			navigationItem.rightBarButtonItem?.tintColor = Desk360.Config.Requests.Listing.NavItem.tintColor
		} else {
			navigationItem.rightBarButtonItem = UIBarButtonItem(title: Desk360.Strings.Support.listingNavButtonTitle, style: .plain, target: self, action: #selector(didTapCreateBarButtonItem(_:)))
		}
	}

}

// MARK: - Actions
extension ListingViewController {

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

		Desk360.apiProvider.request(.getTickets) { [weak self] result in
			self?.layoutableView.setLoading(false)
			guard let self = self else { return }
			switch result {
			case .failure(let error):
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

}
