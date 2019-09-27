//
//  Theme.swift
//  Desk360
//
//  Created by samet on 11.06.2019.
//

import UIKit

public protocol DeskTheme {

	var backgroundColor: UIColor { get }

	var textColor: UIColor { get }

	var listingCellBackgroundColor: UIColor { get }

	var listingCellTintColor: UIColor { get }

	var listingCellLineColor: UIColor { get }

	var listingCellTitleColor: UIColor { get }

	var listingCellDateTextColor: UIColor { get }

	var listingCellImageViewTintColor: UIColor { get }

	var listingPlaceholderTextColor: UIColor { get }

	var listingPlaceholderImageTintColor: UIColor { get }

	var requestBackgroundColor: UIColor { get }

	var requestTextColor: UIColor { get }

	var requestTintColor: UIColor { get }

	var requestPlaceholderTextColor: UIColor { get }

	var dropDownListTextColor: UIColor { get }

	var dropDownListBackgroundColor: UIColor { get }

	var arrowIconTintColor: UIColor { get }

	var requestSendButtonBackgroundColor: UIColor { get }

	var requestSendButtonTintColor: UIColor { get }

	var requestBorderColor: UIColor { get }

	var conversationBackgroundColor: UIColor { get }

	var conversationInputTextColor: UIColor { get }

	var conversationInputBorderColor: UIColor { get }

	var conversationSendButtonTintColor: UIColor { get }

	var recieverCellBackgroundColor: UIColor { get }

	var recieverCellMessageTextColor: UIColor { get }

	var recieverCellDateTextColor: UIColor { get }

	var senderCellBackgroundColor: UIColor { get }

	var senderCellMessageTextColor: UIColor { get }

	var senderCellDateTextColor: UIColor { get }

	var desk360LabelTextColor: UIColor { get }

	var desk360ViewBackgroundColor: UIColor { get }

	var navItemTintColor: UIColor { get }
}
