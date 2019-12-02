//
//  TicketTableViewCellConfig.swift
//  Desk360
//
//  Created by samet on 5.11.2019.
//

/// Use `SupportMessage` to map JSON object returned from the methods in `SupportService`
public struct TicketTableViewCellConfigModel {

	var title: String?

	var chatBackgroundColor: UIColor?

	var chatBoxStyle: Int?

	var chatSenderBackgroundColor: UIColor?

	var chatSenderTextColor: UIColor?

	var chatSenderFontSize: Int?

	var chatSenderFontWeight: Int?

	var chatSenderDateColor: UIColor?

	var chatSenderShadowIsHidden: Bool?

	var chatReceiverBackgroundColor: UIColor?

	var chatReceiverTextColor: UIColor?

	var chatReceiverFontSize: Int?

	var chatReceiverFontWeight: Int?

	var chatReceiverDateColor: UIColor?

	var chatReceiverShadowIsHidden: Bool?

	var writeMessageBackgroundColor: UIColor?

	var writeMessageBorderColor: UIColor?

	var writeMessageBorderActiveColor: UIColor?

	var writeMessagePlaceHolderText: String?

	var writeMessagePlaceHolderColor: UIColor?

	var writeMessageTextColor: UIColor?

	var writeMessageFontSize: Int?

	var writeMessageFontWeight: Int?

	var writeMessageButtonBackgroundColor: UIColor?

	var writeMessageButtonDisableBackgroundColor: UIColor?

	var writeMessageButtonIconColor: UIColor?

	var writeMessageButtonIconDisableColor: UIColor?

	var buttonText: String?

	var buttonTextColor: UIColor?

	var buttonTextFontSize: Int?

	var buttonTextFontWeight: Int?

	var buttonStyleId: Int?

	var buttonBackgroundColor: UIColor?

	var butttonBorderColor: UIColor?

	var buttonIconIsHidden: Bool?

	var buttonShadowIsHidden: Bool?
}

extension TicketTableViewCellConfigModel: Codable {

	private enum CodingKeys: String, CodingKey {
		case title
		case chat_background_color
		case chat_box_style
		case chat_sender_background_color
		case chat_sender_text_color
		case chat_sender_font_size
		case chat_sender_font_weight
		case chat_sender_date_color
		case chat_sender_shadow_is_hidden
		case chat_receiver_background_color
		case chat_receiver_text_color
		case chat_receiver_font_size
		case chat_receiver_font_weight
		case chat_receiver_date_color
		case chat_receiver_shadow_is_hidden
		case write_message_background_color
		case write_message_border_color
		case write_message_border_active_color
		case write_message_place_holder_text
		case write_message_place_holder_color
		case write_message_text_color
		case write_message_font_size
		case write_message_font_weight
		case write_message_button_background_color
		case write_message_button_background_disable_color
		case write_message_button_icon_color
		case write_message_button_icon_disable_color
		case button_text
		case button_text_color
		case button_text_font_size
		case button_text_font_weight
		case button_style_id
		case button_background_color
		case button_border_color
		case button_icon_is_hidden
		case button_shadow_is_hidden
	}

	/// Creates a new instance by decoding from the given decoder.
	///
	/// - Parameter decoder: The decoder to read data from.
	/// - Throws: Decoding error.
	// swiftlint:disable function_body_length
	// swiftlint:disable cyclomatic_complexity
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)

		do {
			title = try (container.decodeIfPresent(String.self, forKey: .title))
			if let chatBackgroundHexValue = try container.decodeIfPresent(String.self, forKey: .chat_background_color) {
				chatBackgroundColor = UIColor.init(hex: chatBackgroundHexValue)
			}
			chatBoxStyle = try (container.decodeIfPresent(Int.self, forKey: .chat_box_style))
			if let chatSenderBackgroundHexValue = try container.decodeIfPresent(String.self, forKey: .chat_sender_background_color) {
				chatSenderBackgroundColor = UIColor.init(hex: chatSenderBackgroundHexValue)
			}
			if let chatSenderTextHexValue = try container.decodeIfPresent(String.self, forKey: .chat_sender_text_color) {
				chatSenderTextColor = UIColor.init(hex: chatSenderTextHexValue)
			}
			chatSenderFontSize = try (container.decodeIfPresent(Int.self, forKey: .chat_sender_font_size))
			chatSenderFontWeight = try (container.decodeIfPresent(Int.self, forKey: .chat_sender_font_weight))
			if let chatSenderDateHexValue = try container.decodeIfPresent(String.self, forKey: .chat_sender_date_color) {
				chatSenderDateColor = UIColor.init(hex: chatSenderDateHexValue)
			}
			chatSenderShadowIsHidden = try (container.decodeIfPresent(Bool.self, forKey: .chat_sender_shadow_is_hidden))
			if let chatReceiverBackgroundHexValue  = try container.decodeIfPresent(String.self, forKey: .chat_receiver_background_color) {
				chatReceiverBackgroundColor = UIColor.init(hex: chatReceiverBackgroundHexValue)
			}
			if let chatReceiverTextHexValue  = try container.decodeIfPresent(String.self, forKey: .chat_receiver_text_color) {
				chatReceiverTextColor = UIColor.init(hex: chatReceiverTextHexValue)
			}
			chatReceiverFontSize = try (container.decodeIfPresent(Int.self, forKey: .chat_receiver_font_size))
			chatReceiverFontWeight = try (container.decodeIfPresent(Int.self, forKey: .chat_receiver_font_weight))
			if let chatReceiverDateHexValue  = try container.decodeIfPresent(String.self, forKey: .chat_receiver_date_color) {
				chatReceiverDateColor = UIColor.init(hex: chatReceiverDateHexValue)
			}
			chatReceiverShadowIsHidden = try (container.decodeIfPresent(Bool.self, forKey: .chat_receiver_shadow_is_hidden))
			if let writeMessageBackgroundHexValue  = try container.decodeIfPresent(String.self, forKey: .write_message_background_color) {
				writeMessageBackgroundColor = UIColor.init(hex: writeMessageBackgroundHexValue)
			}
			if let writeMessageBorderValue  = try container.decodeIfPresent(String.self, forKey: .write_message_border_color) {
				writeMessageBorderColor = UIColor.init(hex: writeMessageBorderValue)
			}
			if let writeMessageBorderActiveValue  = try container.decodeIfPresent(String.self, forKey: .write_message_border_active_color) {
				writeMessageBorderActiveColor = UIColor.init(hex: writeMessageBorderActiveValue)
			}
			writeMessagePlaceHolderText = try (container.decodeIfPresent(String.self, forKey: .write_message_place_holder_text))
			if let writeMessagePlaceHolderHexValue  = try container.decodeIfPresent(String.self, forKey: .write_message_place_holder_color) {
				writeMessagePlaceHolderColor = UIColor.init(hex: writeMessagePlaceHolderHexValue)
			}
			writeMessageFontSize = try (container.decodeIfPresent(Int.self, forKey: .write_message_font_size))
			writeMessageFontWeight = try (container.decodeIfPresent(Int.self, forKey: .write_message_font_weight))
			if let writeMessageTextHexValue  = try container.decodeIfPresent(String.self, forKey: .write_message_text_color) {
				writeMessageTextColor = UIColor.init(hex: writeMessageTextHexValue)
			}
			if let buttonBackgroundHexValue  = try container.decodeIfPresent(String.self, forKey: .write_message_button_background_color) {
				writeMessageButtonBackgroundColor = UIColor.init(hex: buttonBackgroundHexValue)
			}
			if let buttonBackgroundDisableHexValue  = try container.decodeIfPresent(String.self, forKey: .write_message_button_background_disable_color) {
				writeMessageButtonDisableBackgroundColor = UIColor.init(hex: buttonBackgroundDisableHexValue)
			}
			if let buttonIconHexValue  = try container.decodeIfPresent(String.self, forKey: .write_message_button_icon_color) {
				writeMessageButtonIconColor = UIColor.init(hex: buttonIconHexValue)
			}
			if let buttonIconDisableHexValue  = try container.decodeIfPresent(String.self, forKey: .write_message_button_icon_disable_color) {
				writeMessageButtonIconDisableColor = UIColor.init(hex: buttonIconDisableHexValue)
			}
			buttonText = try (container.decodeIfPresent(String.self, forKey: .button_text))
			if let buttonTextHexValue = try container.decodeIfPresent(String.self, forKey: .button_text_color) {
				buttonTextColor = UIColor.init(hex: buttonTextHexValue)
			}
			buttonTextFontSize = try (container.decodeIfPresent(Int.self, forKey: .button_text_font_size))
			buttonTextFontWeight = try (container.decodeIfPresent(Int.self, forKey: .button_text_font_weight))
			buttonStyleId = try (container.decodeIfPresent(Int.self, forKey: .button_style_id))
			if let buttonBackgroundHexValue = try container.decodeIfPresent(String.self, forKey: .button_background_color) {
				buttonBackgroundColor = UIColor.init(hex: buttonBackgroundHexValue)
			}
			if let buttonBorderHexValue = try container.decodeIfPresent(String.self, forKey: .button_border_color) {
				butttonBorderColor = UIColor.init(hex: buttonBorderHexValue)
			}
			buttonIconIsHidden = try (container.decodeIfPresent(Bool.self, forKey: .button_icon_is_hidden))
			buttonShadowIsHidden = try (container.decodeIfPresent(Bool.self, forKey: .button_shadow_is_hidden))

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
			try container.encodeIfPresent(chatBackgroundColor?.hexString(includeAlpha: true), forKey: .chat_background_color)
			try container.encodeIfPresent(chatBoxStyle, forKey: .chat_box_style)
			try container.encodeIfPresent(chatSenderBackgroundColor?.hexString(includeAlpha: true), forKey: .chat_sender_background_color)
			try container.encodeIfPresent(chatSenderTextColor?.hexString(includeAlpha: true), forKey: .chat_sender_text_color)
			try container.encodeIfPresent(chatSenderFontSize, forKey: .chat_sender_font_size)
			try container.encodeIfPresent(chatSenderFontWeight, forKey: .chat_sender_font_weight)
			try container.encodeIfPresent(chatSenderDateColor?.hexString(includeAlpha: true), forKey: .chat_sender_date_color)
			try container.encodeIfPresent(chatSenderShadowIsHidden, forKey: .chat_sender_shadow_is_hidden)
			try container.encodeIfPresent(chatReceiverBackgroundColor?.hexString(includeAlpha: true), forKey: .chat_receiver_background_color)
			try container.encodeIfPresent(chatReceiverTextColor?.hexString(includeAlpha: true), forKey: .chat_receiver_text_color)
			try container.encodeIfPresent(chatReceiverFontSize, forKey: .chat_receiver_font_size)
			try container.encodeIfPresent(chatReceiverFontWeight, forKey: .chat_receiver_font_weight)
			try container.encodeIfPresent(chatReceiverDateColor?.hexString(includeAlpha: true), forKey: .chat_receiver_date_color)
			try container.encodeIfPresent(chatReceiverShadowIsHidden, forKey: .chat_receiver_shadow_is_hidden)
			try container.encodeIfPresent(writeMessageBackgroundColor?.hexString(includeAlpha: true), forKey: .write_message_background_color)
			try container.encodeIfPresent(writeMessageBorderColor?.hexString(includeAlpha: true), forKey: .write_message_border_color)
			try container.encodeIfPresent(writeMessageBorderActiveColor?.hexString(includeAlpha: true), forKey: .write_message_border_active_color)
			try container.encodeIfPresent(writeMessagePlaceHolderText, forKey: .write_message_place_holder_text)
			try container.encodeIfPresent(writeMessageTextColor?.hexString(includeAlpha: true), forKey: .write_message_text_color)
			try container.encodeIfPresent(writeMessageFontSize, forKey: .write_message_font_size)
			try container.encodeIfPresent(writeMessageFontWeight, forKey: .write_message_font_weight)
			try container.encodeIfPresent(writeMessageButtonBackgroundColor?.hexString(includeAlpha: true), forKey: .write_message_button_background_color)
			try container.encodeIfPresent(writeMessageButtonDisableBackgroundColor?.hexString(includeAlpha: true), forKey: .write_message_button_background_disable_color)
			try container.encodeIfPresent(writeMessageButtonIconColor?.hexString(includeAlpha: true), forKey: .write_message_button_icon_color)
			try container.encodeIfPresent(writeMessageButtonIconDisableColor?.hexString(includeAlpha: true), forKey: .write_message_button_icon_disable_color)
			try container.encodeIfPresent(buttonText, forKey: .button_text)
			try container.encodeIfPresent(buttonTextColor?.hexString(includeAlpha: true), forKey: .button_text_color)
			try container.encodeIfPresent(buttonTextFontSize, forKey: .button_text_font_size)
			try container.encodeIfPresent(buttonTextFontWeight, forKey: .button_text_font_weight)
			try container.encodeIfPresent(buttonStyleId, forKey: .button_style_id)
			try container.encodeIfPresent(buttonBackgroundColor?.hexString(includeAlpha: true), forKey: .button_background_color)
			try container.encodeIfPresent(butttonBorderColor?.hexString(includeAlpha: true), forKey: .button_border_color)
			try container.encodeIfPresent(buttonIconIsHidden, forKey: .button_icon_is_hidden)
			try container.encodeIfPresent(buttonShadowIsHidden, forKey: .button_shadow_is_hidden)

		} catch let error as EncodingError {
			print(error)
			throw error
		}
	}

}
