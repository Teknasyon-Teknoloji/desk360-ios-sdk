//
//  TicketListScreenConfig.swift
//  Desk360
//
//  Created by samet on 5.11.2019.
//

/// Use `SupportMessage` to map JSON object returned from the methods in `SupportService`
public struct TicketListScreenConfigModel {

	var title: String?

	var tabTextColor: UIColor?

	var tabTextActiveColor: UIColor?

	var tabBorderColor: UIColor?

	var tabActiveBorderColor: UIColor?

	var tabTextFontSize: Int?

	var tabTextFontWeight: Int?

	var tabCurrentText: String?
	
	var tabPastText: String?

	var emptyIconColor: UIColor?

	var emptyTextColor : UIColor?

	var emptyCurrentText : String?

	var emptyPastText : String?

	var backgroudColor: UIColor?

	var ticketItemBackgroudColor: UIColor?

	var ticketListType: Int?

	var ticketSubjectColor: UIColor?

	var ticketSubjectFontSize: Int?

	var ticketDateColor: UIColor?

	var ticketDateFontSize: Int?

	var ticketItemIconColor: UIColor?

	var ticketItemShadowIsHidden: Bool?
}

extension TicketListScreenConfigModel: Codable {

	private enum CodingKeys: String, CodingKey {
		case title
		case tab_text_color
		case tab_text_active_color
		case tab_border_color
		case tab_active_border_color
		case tab_text_font_size
		case tab_text_font_weight
		case tab_current_text
		case tab_past_text
		case ticket_list_type
		case ticket_list_empty_icon_color
		case ticket_list_empty_text_color
		case ticket_list_empty_current_text
		case ticket_list_empty_past_text
		case ticket_list_backgroud_color
		case ticket_item_backgroud_color
		case ticket_subject_color
		case ticket_subject_font_size
		case ticket_date_color
		case ticket_date_font_size
		case ticket_item_icon_color
		case ticket_item_shadow_is_hidden
	}

	/// Creates a new instance by decoding from the given decoder.
	///
	/// - Parameter decoder: The decoder to read data from.
	/// - Throws: Decoding error.
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)

		do {
			title = try (container.decodeIfPresent(String.self, forKey: .title))
			if let tabTextHexValue = try container.decodeIfPresent(String.self, forKey: .tab_text_color) {
				tabTextColor = UIColor.init(hex: tabTextHexValue)
			}
			if let tabTextActiveHexValue = try container.decodeIfPresent(String.self, forKey: .tab_text_active_color) {
				tabTextActiveColor = UIColor.init(hex: tabTextActiveHexValue)
			}
			if let tabBorderHexValue = try container.decodeIfPresent(String.self, forKey: .tab_border_color) {
				tabBorderColor = UIColor.init(hex: tabBorderHexValue)
			}
			if let tabActiveBorderHexValue = try container.decodeIfPresent(String.self, forKey: .tab_active_border_color) {
				tabActiveBorderColor = UIColor.init(hex: tabActiveBorderHexValue)
			}
			tabTextFontSize = try (container.decodeIfPresent(Int.self, forKey: .tab_text_font_size))
			tabTextFontWeight = try (container.decodeIfPresent(Int.self, forKey: .tab_text_font_weight))
			tabCurrentText = try (container.decodeIfPresent(String.self, forKey: .tab_current_text))
			tabPastText = try (container.decodeIfPresent(String.self, forKey: .tab_past_text))
			if let ticketListemptyIconHexValue = try container.decodeIfPresent(String.self, forKey: .ticket_list_empty_icon_color) {
				emptyIconColor = UIColor.init(hex: ticketListemptyIconHexValue)
			}
			if let ticketListemptyTextHexValue = try container.decodeIfPresent(String.self, forKey: .ticket_list_empty_text_color) {
				emptyTextColor = UIColor.init(hex: ticketListemptyTextHexValue)
			}
			emptyCurrentText = try (container.decodeIfPresent(String.self, forKey: .ticket_list_empty_current_text))
			emptyPastText = try (container.decodeIfPresent(String.self, forKey: .ticket_list_empty_past_text))
			if let ticketListBackgroudHexValue = try container.decodeIfPresent(String.self, forKey: .ticket_list_backgroud_color) {
				backgroudColor = UIColor.init(hex: ticketListBackgroudHexValue)
			}
			if let ticketItemBackgroudHexValue = try container.decodeIfPresent(String.self, forKey: .ticket_item_backgroud_color) {
				ticketItemBackgroudColor = UIColor.init(hex: ticketItemBackgroudHexValue)
			}
			ticketListType = try (container.decodeIfPresent(Int.self, forKey: .ticket_list_type))

			if let ticketSubjectHexValue  = try container.decodeIfPresent(String.self, forKey: .ticket_subject_color) {
				ticketSubjectColor = UIColor.init(hex: ticketSubjectHexValue)
			}
			ticketSubjectFontSize = try (container.decodeIfPresent(Int.self, forKey: .ticket_subject_font_size))
			if let ticketDateHexValue  = try container.decodeIfPresent(String.self, forKey: .ticket_date_color) {
				ticketDateColor = UIColor.init(hex: ticketDateHexValue)
			}
			ticketDateFontSize = try (container.decodeIfPresent(Int.self, forKey: .ticket_date_font_size))
			if let ticketItemIconHexValue  = try container.decodeIfPresent(String.self, forKey: .ticket_item_icon_color) {
				ticketItemIconColor = UIColor.init(hex: ticketItemIconHexValue)
			}
			ticketItemShadowIsHidden = try (container.decodeIfPresent(Bool.self, forKey: .ticket_item_shadow_is_hidden))

		} catch let error as DecodingError {
			print(error)
			throw error
		}
	}

	/// Encodes this value into the given encoder.
	///
	/// - Parameter encoder: The encoder to write data to.
	/// - Throws: Encoding error.
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)

		do {
			try container.encodeIfPresent(title, forKey: .title)
			try container.encodeIfPresent(tabTextColor?.hexString(includeAlpha: true), forKey: .tab_text_color)
			try container.encodeIfPresent(tabTextActiveColor?.hexString(includeAlpha: true), forKey: .tab_text_active_color)
			try container.encodeIfPresent(tabBorderColor?.hexString(includeAlpha: true), forKey: .tab_border_color)
			try container.encodeIfPresent(tabActiveBorderColor?.hexString(includeAlpha: true), forKey: .tab_active_border_color)
			try container.encodeIfPresent(tabTextFontSize, forKey: .tab_text_font_size)
			try container.encodeIfPresent(tabTextFontWeight, forKey: .tab_text_font_weight)
			try container.encodeIfPresent(tabCurrentText, forKey: .tab_current_text)
			try container.encodeIfPresent(tabPastText, forKey: .tab_past_text)
			try container.encodeIfPresent(emptyIconColor?.hexString(includeAlpha: true), forKey: .ticket_list_empty_icon_color)
			try container.encodeIfPresent(emptyTextColor?.hexString(includeAlpha: true), forKey: .ticket_list_empty_text_color)
			try container.encodeIfPresent(emptyCurrentText, forKey: .ticket_list_empty_current_text)
			try container.encodeIfPresent(emptyPastText, forKey: .ticket_list_empty_past_text)
			try container.encodeIfPresent(backgroudColor?.hexString(includeAlpha: true), forKey: .ticket_list_backgroud_color)
			try container.encodeIfPresent(ticketItemBackgroudColor?.hexString(includeAlpha: true), forKey: .ticket_item_backgroud_color)
			try container.encodeIfPresent(ticketListType, forKey: .ticket_list_type)
			try container.encodeIfPresent(ticketSubjectColor?.hexString(includeAlpha: true), forKey: .ticket_subject_color)
			try container.encodeIfPresent(ticketSubjectFontSize, forKey: .ticket_subject_font_size)
			try container.encodeIfPresent(ticketDateColor?.hexString(includeAlpha: true), forKey: .ticket_date_color)
			try container.encodeIfPresent(ticketDateFontSize, forKey: .ticket_date_font_size)
			try container.encodeIfPresent(ticketItemIconColor?.hexString(includeAlpha: true), forKey: .ticket_item_icon_color)
			try container.encodeIfPresent(ticketItemShadowIsHidden, forKey: .ticket_item_shadow_is_hidden)
		} catch let error as EncodingError {
			print(error)
			throw error
		}
	}

}
