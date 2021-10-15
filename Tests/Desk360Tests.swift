//
//  Tests.swift
//  Tests
//
//  Created by Samet Aktaş on 10/1/21.
//

import Quick
import Nimble
@testable import Desk360

final class Desk360Tests: QuickSpec {

	override func spec() {
		let window = UIWindow()
		window.makeKeyAndVisible()
		let viewController = UIViewController()
		viewController.loadView()
		viewController.beginAppearanceTransition(true, animated: false)
		window.rootViewController = viewController
		
		let properties = Desk360Properties(appID: "123456")
		
		let desk360 = Desk360(properties: properties)
		
		let pushNotification = self.fakePushNotification(ticketID: 12)
		let brokenPushNotification = self.fakeBrokenPushNotification(ticketID: 12)
		
		let openTicket = Ticket(id: 1, name: "Test", email: "test@test.com", status: .open, createdAt: Date(), message: "Test message", messages: [Message(id: 1, message: "Test", isAnswer: false, createdAt: "06.10.2021", attachments: nil)], attachmentUrl: nil, createDateString: "06.10.2021")
		let readTicket = Ticket(id: 1, name: "Test", email: "test@test.com", status: .read, createdAt: Date(), message: "Test message", messages: [Message(id: 1, message: "Test", isAnswer: false, createdAt: "06.10.2021", attachments: nil)], attachmentUrl: nil, createDateString: "06.10.2021")
		let unreadTicket = Ticket(id: 1, name: "Test", email: "test@test.com", status: .unread, createdAt: Date(), message: "Test message", messages: [Message(id: 1, message: "Test", isAnswer: false, createdAt: "06.10.2021", attachments: nil)], attachmentUrl: nil, createDateString: "06.10.2021")
		let expiredTicket = Ticket(id: 1, name: "Test", email: "test@test.com", status: .expired, createdAt: Date(), message: "Test message", messages: [Message(id: 1, message: "Test", isAnswer: false, createdAt: "06.10.2021", attachments: nil)], attachmentUrl: nil, createDateString: "06.10.2021")
		
		beforeEach {
			try? Stores.registerModel.save(.init(appId: "123456", deviceId: "5421", environment: .sandbox, language: "en", country: "TR"))
		}
		describe("when setting push token") {
			it("should not be null") {
				let pushData = Data("12345".utf8)
				Desk360.setPushToken(deviceToken: pushData)
				expect(Desk360.pushToken).notTo(beNil())
			}
		}
		
		describe("when launched from notification") {
			
			let pushNotification = self.fakePushNotification(ticketID: 12)
			
			it("should open Desk360 if user info not empty") {
				Desk360.applicationLaunchChecker([.remoteNotification: pushNotification])
				
				expect(Desk360.didTapNotification).to(beTrue())
				expect(Desk360.applaunchChecker).to(beTrue())
				expect(Desk360.messageId).to(equal(12))
			}
			
			it("should open with deeplink if showWithPushDeeplink called") {
			
				Desk360.applicationLaunchChecker([.remoteNotification: pushNotification])
				Desk360.willNotificationPresent(pushNotification)
				Desk360.showWithPushDeeplink(on: window.rootViewController)
				expect(window.rootViewController?.presentedViewController).notTo(beNil())
				
			}
		}
		
		describe("when start Desk360") {
			Desk360.start(using: properties)
			
			it("should not be null") {
				expect(Stores.registerModel.object).notTo(beNil())
			}
		}
		
		describe("when show Desk360") {
			it("should not be null") {
				Desk360.show(on: viewController)
				expect(viewController.presentedViewController).notTo(beNil())
			}
		}
		
		describe("when showDetails Desk360") {
			it("should not be null") {
				Desk360.showDetails(ofTicket: openTicket, on: viewController)
				expect(viewController.presentedViewController).notTo(beNil())
			}
		}
		
		describe("when canHandleNotfication Desk360") {
			it("should be false") {
				let canHandleForBrokenPush = Desk360.canHandleNotfication(brokenPushNotification)
				expect(canHandleForBrokenPush).to(beFalse())
			}
			
			it("should be true") {
				let canHandle = Desk360.canHandleNotfication(pushNotification)
				expect(canHandle).to(beTrue())
			}
			
		}
		
		describe("when configure CreatRequestPreView") {
			it("should be equal") {
				let createPreRequestView = CreatRequestPreView.create()
				createPreRequestView.configure()
				
				expect(createPreRequestView.backgroundColor).to(equal(Colors.backgroundColor))
				expect(createPreRequestView.titleLabel.textColor).to(equal(Colors.createPreScreenTitleColor))
				expect(createPreRequestView.descriptionLabel.textColor).to(equal(Colors.createPreScreenDescriptionColor))
				
				expect(createPreRequestView.createRequestButton.backgroundColor).to(equal(Colors.createPreScreenDescriptionColor))
				expect(createPreRequestView.createRequestButton.layer.borderColor).to(equal(Colors.createPreScreenButttonBorderColor.cgColor))
				expect(createPreRequestView.createRequestButton.titleLabel?.textColor).to(equal(Colors.createPreScreenButtonTextColor))
				expect(createPreRequestView.createRequestButton.tintColor).to(equal(Colors.createPreScreenButtonTextColor))
				expect(createPreRequestView.bottomDescriptionLabel.textColor).to(equal(Colors.bottomNoteColor))
				
			}
		}
		
		describe("when configure ListingPlaceholderView") {
			it("should be equal") {
				let listingPlaceholderView = ListingPlaceholderView.create()
				listingPlaceholderView.configure()
				
				expect(listingPlaceholderView.titleLabel.textColor).to(equal(Colors.firstScreenTitleColor))
				expect(listingPlaceholderView.createRequestButton.backgroundColor).to(equal(Colors.firstScreenButtonBackgroundColor))
				expect(listingPlaceholderView.createRequestButton.layer.borderColor).to(equal(Colors.firstScreenButttonBorderColor.cgColor))
				expect(listingPlaceholderView.createRequestButton.tintColor).to(equal(Colors.firstScreenButtonTextColor))
				expect(listingPlaceholderView.bottomDescriptionLabel.textColor).to(equal(Colors.bottomNoteColor))
			}
		}
		
		describe("when configure ListingTableViewCell") {
			it("should be equal") {
				let tableView = UITableView()
				let listingTableViewCell = tableView.dequeueReusableCell(ListingTableViewCell.self)
				listingTableViewCell.configure(for: openTicket)
				
				expect(listingTableViewCell.backgroundColor).to(equal(Colors.ticketListingScreenBackgroudColor))
				
			}
		}
		
		describe("when configure ListingView") {
			it("should be equal") {
				let listingView = ListingView.create()
				listingView.configure()
				
				expect(listingView.backgroundColor).to(equal(Colors.backgroundColor))
				expect(listingView.emptyView.backgroundColor).to(equal(Colors.ticketListingScreenBackgroudColor))
				expect(listingView.tableView.backgroundColor).to(equal(Colors.ticketListingScreenBackgroudColor))
				expect(listingView.emptyTextLabel.textColor).to(equal(Colors.ticketListingScreenTabTextColor))
				
				listingView.configureSegmentedControl()
				
				expect(listingView.segmentControl.backgroundColor).to(equal(Colors.backgroundColor))
				expect(listingView.segmentControl.tintColor).to(equal(.clear))
				expect(listingView.buttonBar.backgroundColor).to(equal(Colors.ticketListingScreenTabActiveBorderColor))
			}
		}
		
		describe("when filterTicketsForSegment ListingViewController") {
			it("should be equal") {
				let listingViewController = ListingViewController(tickets: [openTicket, readTicket, expiredTicket, expiredTicket])
				listingViewController.checkForUnreadMessageIcon()
				
				expect(Desk360.isActive).to(be(true))
				
				expect(listingViewController.layoutableView.notifLabel.isHidden).to(beTrue())
				
				listingViewController.filterTicketsForSegment()
				expect(listingViewController.requests.count).to(equal(4))
				
				let tickets = listingViewController.filterTickets
				expect(tickets.count).to(equal(2))
				
				listingViewController.didTapCloseButton()
				
				expect(Desk360.isActive).to(be(false))
				expect(Desk360.conVC).to(beNil())
				expect(Desk360.list).to(beNil())
				
				listingViewController.configureLayoutableView()
				
				expect(listingViewController.aiv.color).toNot(equal(Colors.backgroundColor))
				expect(listingViewController.aiv.color).to(equal(Colors.pdrColor))
				expect(listingViewController.aiv.frame.size.height).to(equal(20))
				expect(listingViewController.refreshIcon.isHidden).to(beTrue())
				
				let listingViewControllerForUnread = ListingViewController(tickets: [unreadTicket, openTicket, expiredTicket, expiredTicket])
				listingViewControllerForUnread.checkForUnreadMessageIcon()
				
				expect(listingViewController.layoutableView.notifLabel.isHidden).to(beTrue())
			}
		}
		
		describe("when initialize SuccessView") {
			it("should be equal") {
				let successView = SuccessView.create()
				successView.configure()
				
				expect(successView.backgroundColor).to(equal(Colors.backgroundColor))
				expect(successView.titleLabel.textColor).to(equal(Colors.ticketSuccessScreenTitleColor))
				expect(successView.descriptionLabel.textColor).to(equal(Colors.ticketSuccessScreenDescriptionColor))
				expect(successView.showListButton.backgroundColor).to(equal(Colors.ticketSuccessScreenButtonBackgroundColor))
				expect(successView.showListButton.tintColor).to(equal(Colors.ticketSuccessScreenButtonTextColor))
				expect(successView.showListButton.layer.borderColor).to(equal(Colors.ticketSuccessScreenButttonBorderColor.cgColor))
				expect(successView.imageView.tintColor).to(equal(Colors.ticketSuccessScreenIconColor))
				expect(successView.bottomDescriptionLabel.textColor).to(equal(Colors.bottomNoteColor))
				
			}
		}
		
		describe("when initialize CreateRequestView") {
			it("should be equal") {
				let createRequestView = CreateRequestView.create()
				createRequestView.configure()
				
				expect(createRequestView.backgroundColor).to(equal(Colors.backgroundColor))
				expect(createRequestView.bottomDescriptionLabel.textColor).to(equal(Colors.bottomNoteColor))
				let label = UILabel()
				createRequestView.configureErrorLabels(label)
				
				expect(label.isHidden).to(beTrue())
				expect(label.font).to(equal(UIFont.systemFont(ofSize: 11)))
				
				createRequestView.configure()
				
				expect(createRequestView.backgroundColor).to(equal(Colors.backgroundColor))
				expect(createRequestView.messageTextView.messageTextView.textColor).to(equal(Colors.createScreenFormInputFocusColor))
				expect(createRequestView.messageTextView.messageTextView.tintColor).to(equal(Colors.createScreenFormInputFocusColor))
				expect(createRequestView.messageTextViewLabel.textColor).to(equal(Colors.createScreenFormInputColor))
				expect(createRequestView.sendButton.layer.borderColor).to(equal(Colors.createScreenButttonBorderColor.cgColor))
				
				createRequestView.configureDropDownListView()
				
				expect(createRequestView.dropDownListView.itemTextColor).to(equal(Colors.createScreenFormInputFocusColor))
				expect(createRequestView.dropDownListView.titleColor).to(equal(Colors.createScreenFormInputColor))
				expect(createRequestView.dropDownListView.itemBackground).to(equal(Colors.backgroundColor))
				
				createRequestView.configureButton()
				
				expect(createRequestView.sendButton.backgroundColor).to(equal(Colors.createScreenButtonBackgroundColor))
				expect(createRequestView.sendButton.layer.borderColor).to(equal(Colors.createScreenButtonBackgroundColor.cgColor))
				expect(createRequestView.sendButton.tintColor).to(equal(Colors.backgroundColor))
				
			}
		}
		
		describe("when configLayoutableView CreateRequestViewController") {
			it("should be equal") {
				let createRequestViewController = CreateRequestViewController()
				
				let email = "test@test.com"
				let userName = "username"
				
				try? Stores.userMail.save(email)
				try? Stores.userName.save(userName)
				
				createRequestViewController.configLayoutableView()
				
				expect(createRequestViewController.layoutableView.emailTextField.text).to(equal(email))
				expect(createRequestViewController.layoutableView.nameTextField.text).to(equal(userName))
				
			}
		}
		
		describe("when configure ConversationView") {
			it("should be equal") {
				let conversationView = ConversationView.create()
				
				conversationView.configure()
				
				expect(conversationView.backgroundColor).to(equal(Colors.ticketDetailChatBackgroundColor))
				expect(conversationView.tableView.backgroundColor).to(equal(Colors.ticketDetailChatBackgroundColor))
				
			}
		}

	}

}

private extension Desk360Tests {
	
	func fakePushNotification(ticketID: Int) -> [String: Any] {
		
		let jsonString = """
		 {
			"data" : {
				"hermes" : {
					"target_detail" : {
						"target_category": "Desk360Deeplink",
						"target_id": "\(ticketID)"
					}
				}
			}
		}
		"""
		// swiftlint:disable force_cast
		let jsonObject = try! JSONSerialization.jsonObject(with: jsonString.data(using: .utf8) ?? .init(), options: []) as! [String : Any]
		return jsonObject
	}
	
	func fakeBrokenPushNotification(ticketID: Int) -> [String: Any] {
		
		let jsonString = """
		 {
			"test" : {
				"test" : {
					"test" : {
						"test": "test",
						"test": "\(ticketID)"
					}
				}
			}
		}
		"""
		// swiftlint:disable force_cast
		let jsonObject = try! JSONSerialization.jsonObject(with: jsonString.data(using: .utf8) ?? .init(), options: []) as! [String : Any]
		return jsonObject
	}
}
