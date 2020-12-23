//
//  Colors.swift
//  Desk360
//
//  Created by samet on 6.11.2019.
//

import UIKit

struct Colors {

	static var backgroundColor: UIColor {
		return Config.shared.model?.generalSettings?.mainBackgroundColor ?? UIColor.init(hex: "FFFFFF")!
	}
	static var navigationBackgroundColor: UIColor {
		return Config.shared.model?.generalSettings?.navigationBackgroundColor ?? UIColor.init(hex: "FFFFFF")!
	}
	static var navigationTextColor: UIColor {
		return Config.shared.model?.generalSettings?.navigationTextColor ?? UIColor.init(hex: "FFFFFF")!
	}
	static var navigationImageViewTintColor: UIColor {
		return Config.shared.model?.generalSettings?.navigationImageViewTintColor ?? UIColor.init(hex: "FFFFFF")!
	}
	static var bottomNoteColor: UIColor {
		return Config.shared.model?.generalSettings?.bottomNoteColor ?? UIColor.init(hex: "FFFFFF")!
	}
	static var copyrightBackgroundColor: UIColor {
		return Config.shared.model?.generalSettings?.copyrightBackgroundColor ?? UIColor.init(hex: "FFFFFF")!
	}
	static var copyrightTextColor: UIColor {
		return Config.shared.model?.generalSettings?.copyrightTextColor ?? UIColor.init(hex: "FFFFFF")!
	}
	static var firstScreenTitleColor: UIColor {
		return Config.shared.model?.firstScreen?.titleColor ?? UIColor.init(hex: "FFFFFF")!
	}
	static var firstScreenDescriptionColor: UIColor {
		return Config.shared.model?.firstScreen?.descriptionColor ?? UIColor.init(hex: "FFFFFF")!
	}
	static var firstScreenButtonTextColor: UIColor {
		return Config.shared.model?.firstScreen?.buttonTextColor ?? UIColor.init(hex: "FFFFFF")!
	}
	static var firstScreenButtonBackgroundColor: UIColor {
		return Config.shared.model?.firstScreen?.buttonBackgroundColor ?? UIColor.init(hex: "FFFFFF")!
	}
	static var firstScreenButttonBorderColor: UIColor {
		return Config.shared.model?.firstScreen?.butttonBorderColor ?? UIColor.init(hex: "FFFFFF")!
	}
	static var createPreScreenTitleColor: UIColor {
		return Config.shared.model?.createPreScreen?.titleColor ?? UIColor.init(hex: "FFFFFF")!
	}
	static var createPreScreenDescriptionColor: UIColor {
		return Config.shared.model?.createPreScreen?.descriptionColor ?? UIColor.init(hex: "FFFFFF")!
	}
	static var createPreScreenButtonTextColor: UIColor {
		return Config.shared.model?.createPreScreen?.buttonTextColor ?? UIColor.init(hex: "FFFFFF")!
	}
	static var createPreScreenButtonBackgroundColor: UIColor {
		return Config.shared.model?.createPreScreen?.buttonBackgroundColor ?? UIColor.init(hex: "FFFFFF")!
	}
	static var createPreScreenButttonBorderColor: UIColor {
		return Config.shared.model?.createPreScreen?.butttonBorderColor ?? UIColor.init(hex: "FFFFFF")!
	}
	static var createScreenFormInputColor: UIColor {
		return Config.shared.model?.createScreen?.formInputColor ?? UIColor.init(hex: "FFFFFF")!
	}
	static var createScreenFormInputBackgroundColor: UIColor {
		return Config.shared.model?.createScreen?.formInputBackgroundColor ?? UIColor.init(hex: "FFFFFF")!
	}
	static var createScreenFormInputBorderColor: UIColor {
		return Config.shared.model?.createScreen?.formInputBorderColor ?? UIColor.init(hex: "FFFFFF")!
	}
	static var createScreenFormInputFocusColor: UIColor {
		return Config.shared.model?.createScreen?.formInputFocusColor ?? UIColor.init(hex: "FFFFFF")!
	}
	static var createScreenFormInputFocusBackgroundColor: UIColor {
		return Config.shared.model?.createScreen?.formInputFocusBackgroundColor ?? UIColor.init(hex: "FFFFFF")!
	}
	static var createScreenFormInputFocusBorderColor: UIColor {
		return Config.shared.model?.createScreen?.formInputFocusBorderColor ?? UIColor.init(hex: "FFFFFF")!
	}
	static var createScreenFormInputPlaceHolderColor: UIColor {
		return Config.shared.model?.createScreen?.formInputPlaceHolderColor ?? UIColor.init(hex: "FFFFFF")!
	}
	static var createScreenLabelTextColor: UIColor {
		return Config.shared.model?.createScreen?.labelTextColor ?? UIColor.init(hex: "FFFFFF")!
	}
	static var createScreenErrorLabelTextColor: UIColor {
		return Config.shared.model?.createScreen?.errorLabelTextColor ?? UIColor.init(hex: "FFFFFF")!
	}
	static var createScreenButtonTextColor: UIColor {
		return Config.shared.model?.createScreen?.buttonTextColor ?? UIColor.init(hex: "FFFFFF")!
	}
	static var createScreenButtonBackgroundColor: UIColor {
		return Config.shared.model?.createScreen?.buttonBackgroundColor ?? UIColor.init(hex: "FFFFFF")!
	}
	static var createScreenButttonBorderColor: UIColor {
		return Config.shared.model?.createScreen?.butttonBorderColor ?? UIColor.init(hex: "FFFFFF")!
	}
	static var ticketListingScreenTabTextColor: UIColor {
		return Config.shared.model?.ticketListingScreen?.tabTextColor ?? UIColor.init(hex: "FFFFFF")!
	}
	static var ticketListingScreenTabTextActiveColor: UIColor {
		return Config.shared.model?.ticketListingScreen?.tabTextActiveColor ?? UIColor.init(hex: "FFFFFF")!
	}
	static var ticketListingScreenTabBorderColor: UIColor {
		return Config.shared.model?.ticketListingScreen?.tabBorderColor ?? UIColor.init(hex: "FFFFFF")!
	}
	static var ticketListingScreenTabActiveBorderColor: UIColor {
		return Config.shared.model?.ticketListingScreen?.tabActiveBorderColor ?? UIColor.init(hex: "FFFFFF")!
	}
	static var ticketListingScreenEmptyIconColor: UIColor {
		return Config.shared.model?.ticketListingScreen?.emptyIconColor ?? UIColor.init(hex: "FFFFFF")!
	}
	static var ticketListingScreenEmptyTextColor: UIColor {
		return Config.shared.model?.ticketListingScreen?.emptyTextColor ?? UIColor.init(hex: "FFFFFF")!
	}
	static var ticketListingScreenBackgroudColor: UIColor {
		return Config.shared.model?.ticketListingScreen?.backgroudColor ?? UIColor.init(hex: "FFFFFF")!
	}
	static var ticketListingScreenItemBackgroudColor: UIColor {
		return Config.shared.model?.ticketListingScreen?.ticketItemBackgroudColor ?? UIColor.init(hex: "FFFFFF")!
	}
	static var ticketListingScreenTicketSubjectColor: UIColor {
		return Config.shared.model?.ticketListingScreen?.ticketSubjectColor ?? UIColor.init(hex: "FFFFFF")!
	}
	static var ticketListingScreenTicketDateColor: UIColor {
		return Config.shared.model?.ticketListingScreen?.ticketDateColor ?? UIColor.init(hex: "FFFFFF")!
	}
	static var ticketListingScreenTicketItemIconColor: UIColor {
		return Config.shared.model?.ticketListingScreen?.ticketItemIconColor ?? UIColor.init(hex: "FFFFFF")!
	}
	static var ticketDetailChatBackgroundColor: UIColor {
		return Config.shared.model?.ticketDetail?.chatBackgroundColor ?? UIColor.init(hex: "FFFFFF")!
	}
	static var ticketDetailChatSenderBackgroundColor: UIColor {
		return Config.shared.model?.ticketDetail?.chatSenderBackgroundColor ?? UIColor.init(hex: "FFFFFF")!
	}
	static var ticketDetailChatSenderTextColor: UIColor {
		return Config.shared.model?.ticketDetail?.chatSenderTextColor ?? UIColor.init(hex: "FFFFFF")!
	}
	static var ticketDetailChatSenderDateColor: UIColor {
		return Config.shared.model?.ticketDetail?.chatSenderDateColor ?? UIColor.init(hex: "FFFFFF")!
	}
	static var ticketDetailChatReceiverBackgroundColor: UIColor {
		return Config.shared.model?.ticketDetail?.chatReceiverBackgroundColor ?? UIColor.init(hex: "FFFFFF")!
	}
	static var ticketDetailChatReceiverTextColor: UIColor {
		return Config.shared.model?.ticketDetail?.chatReceiverTextColor ?? UIColor.init(hex: "FFFFFF")!
	}
	static var ticketDetailChatChatReceiverDateColor: UIColor {
		return Config.shared.model?.ticketDetail?.chatReceiverDateColor ?? UIColor.init(hex: "FFFFFF")!
	}
	static var ticketDetailChatWriteMessageBackgroundColor: UIColor {
		return Config.shared.model?.ticketDetail?.writeMessageBackgroundColor ?? UIColor.init(hex: "FFFFFF")!
	}
	static var ticketDetailWriteMessageTextColor: UIColor {
		return Config.shared.model?.ticketDetail?.writeMessageTextColor ?? UIColor.init(hex: "FFFFFF")!
	}
	static var ticketDetailWriteMessageBorderActiveColor: UIColor {
		return Config.shared.model?.ticketDetail?.writeMessageBorderActiveColor ?? UIColor.init(hex: "FFFFFF")!
	}
	static var ticketDetailWriteMessageBorderColor: UIColor {
		return Config.shared.model?.ticketDetail?.writeMessageBorderColor ?? UIColor.init(hex: "FFFFFF")!
	}
	static var ticketDetailWriteMessageButtonBackgrounColor: UIColor {
		return Config.shared.model?.ticketDetail?.writeMessageBackgroundColor ?? UIColor.init(hex: "FFFFFF")!
	}
	static var ticketDetailButtonBackgroundColor: UIColor {
		return Config.shared.model?.ticketDetail?.buttonBackgroundColor ?? UIColor.init(hex: "FFFFFF")!
	}
	static var ticketDetailButtonBorderColor: UIColor {
		return Config.shared.model?.ticketDetail?.butttonBorderColor ?? UIColor.init(hex: "FFFFFF")!
	}
	static var ticketDetailButtonTextColor: UIColor {
		return Config.shared.model?.ticketDetail?.buttonTextColor ?? UIColor.init(hex: "FFFFFF")!
	}
	static var ticketDetailWriteMessageButtonIconColor: UIColor {
		return Config.shared.model?.ticketDetail?.writeMessageButtonIconColor ?? UIColor.init(hex: "FFFFFF")!
	}
	static var ticketDetailWriteMessageButtonIconDisableColor: UIColor {
		return Config.shared.model?.ticketDetail?.writeMessageButtonIconDisableColor ?? UIColor.init(hex: "FFFFFF")!
	}
	static var ticketDetailWriteMessageButtonBackgroundColor: UIColor {
		return Config.shared.model?.ticketDetail?.writeMessageButtonBackgroundColor ?? UIColor.init(hex: "FFFFFF")!
	}
	static var ticketDetailWriteMessageButtonDisableBackgroundColor: UIColor {
		return Config.shared.model?.ticketDetail?.writeMessageButtonDisableBackgroundColor ?? UIColor.init(hex: "FFFFFF")!
	}
	static var ticketSuccessScreenIconColor: UIColor {
		return Config.shared.model?.successScreen?.iconColor ?? UIColor.init(hex: "FFFFFF")!
	}
	static var ticketSuccessScreenTitleColor: UIColor {
		return Config.shared.model?.successScreen?.titleColor ?? UIColor.init(hex: "FFFFFF")!
	}
	static var ticketSuccessScreenDescriptionColor: UIColor {
		return Config.shared.model?.successScreen?.descriptionColor ?? UIColor.init(hex: "FFFFFF")!
	}
	static var ticketSuccessScreenButtonTextColor: UIColor {
		return Config.shared.model?.successScreen?.buttonTextColor ?? UIColor.init(hex: "FFFFFF")!
	}
	static var ticketSuccessScreenButtonBackgroundColor: UIColor {
		return Config.shared.model?.successScreen?.buttonBackgroundColor ?? UIColor.init(hex: "FFFFFF")!
	}
	static var ticketSuccessScreenButttonBorderColor: UIColor {
		return Config.shared.model?.successScreen?.butttonBorderColor ?? UIColor.init(hex: "FFFFFF")!
	}
    static var pdrColor: UIColor? {
        return UIColor(hex: "#a3d0f5")
    }
    static var receiverFileNameColor: UIColor? {
        return UIColor(hex: "#525a7e")
    }
    static var senderFileNameColor: UIColor? {
        return UIColor(hex: "#ffffff")
    }

    static var unreadIconColor: UIColor? {
        return UIColor(hex: "#58b0fa")
    }
    
    static var attachBgColor: UIColor? {
        return UIColor(hex: "#eeeff0")
    }
    
    static var writeMessagePHTextColor: UIColor? {
        return UIColor(hex: "#9298b1")
    }
    
}
