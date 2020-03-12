//
//  CreateScreenConfig.swift
//  Desk360
//
//  Created by samet on 5.11.2019.
//

public struct CreateScreenConfigModel {

	var navigationTitle: String?

	var formStyleId: FieldType?

	var formInputColor: UIColor?

	var formInputBackgroundColor: UIColor?

	var formInputBorderColor: UIColor?

	var formInputShadow: String?

	var formInputFocusColor: UIColor?

	var formInputFocusBackgroundColor: UIColor?

	var formInputFocusBorderColor: UIColor?

	var formInputFocusShadow: String?

	var formInputPlaceHolderColor: UIColor?

	var formInputFontSize: Int?

	var formInputFontWeight: Int?

	var labelTextColor: UIColor?

	var labelTextFontSize: Int?

	var labelTextFontWeight: Int?

	var errorLabelTextColor: UIColor?

	var buttonText: String?

	var buttonTextColor: UIColor?

	var buttonTextFontSize: Int?

	var buttonTextFontWeight: Int?

	var buttonStyleId: ButtonType?

	var buttonBackgroundColor: UIColor?

	var butttonBorderColor: UIColor?

	var addedFileIsHidden: Bool?

	var buttonIconIsHidden: Bool?

	var buttonShadowIsHidden: Bool?

	var bottomNoteIsHidden: Bool?

	var bottomNoteText: String?

	var ticketTypes: [TicketType]?

}

extension CreateScreenConfigModel: Codable {

	private enum CodingKeys: String, CodingKey {
		case title
		case form_style_id
		case form_input_color
		case form_input_background_color
		case form_input_border_color
		case form_input_focus_color
		case form_input_focus_background_color
		case form_input_focus_border_color
		case form_input_place_holder_color
		case form_input_font_size
		case form_input_font_weight
		case label_text_color
		case label_text_font_size
		case label_text_font_weight
		case error_label_text_color
		case button_text
		case button_text_color
		case button_text_font_size
		case button_text_font_weight
		case button_style_id
		case button_background_color
		case button_border_color
		case button_icon_is_hidden
		case button_shadow_is_hidden
		case added_file_is_hidden
		case bottom_note_is_hidden
		case bottom_note_text
		case custom_fields
		case types
	}

	/// Creates a new instance by decoding from the given decoder.
	///
	/// - Parameter decoder: The decoder to read data from.
	/// - Throws: Decoding error.
	// swiftlint:disable cyclomatic_complexity
	// swiftlint:disable function_body_length
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)

		do {
			navigationTitle = try (container.decodeIfPresent(String.self, forKey: .title))
			formStyleId = try (container.decodeIfPresent(FieldType.self, forKey: .form_style_id))
			if let formInputHexValue = try container.decodeIfPresent(String.self, forKey: .form_input_color) {
				formInputColor = UIColor.init(hex: formInputHexValue)
			}
			if let formInputBackgroundHexValue = try container.decodeIfPresent(String.self, forKey: .form_input_background_color) {
				formInputBackgroundColor = UIColor.init(hex: formInputBackgroundHexValue)
			}
			if let formInputBorderHexValue = try container.decodeIfPresent(String.self, forKey: .form_input_border_color) {
				formInputBorderColor = UIColor.init(hex: formInputBorderHexValue)
			}
			if let formInputFocusHexValue = try container.decodeIfPresent(String.self, forKey: .form_input_focus_color) {
				formInputFocusColor = UIColor.init(hex: formInputFocusHexValue)
			}
			if let formInputFocusBackgroundHexValue = try container.decodeIfPresent(String.self, forKey: .form_input_focus_background_color) {
				formInputFocusBackgroundColor = UIColor.init(hex: formInputFocusBackgroundHexValue)
			}
			if let formInputFocusBorderHexValue = try container.decodeIfPresent(String.self, forKey: .form_input_focus_border_color) {
				formInputFocusBorderColor = UIColor.init(hex: formInputFocusBorderHexValue)
			}
			if let formInputPlaceHolderHexValue = try container.decodeIfPresent(String.self, forKey: .form_input_place_holder_color) {
				formInputPlaceHolderColor = UIColor.init(hex: formInputPlaceHolderHexValue)
			}
			formInputFontSize = try (container.decodeIfPresent(Int.self, forKey: .form_input_font_size))
			formInputFontWeight = try (container.decodeIfPresent(Int.self, forKey: .form_input_font_weight))
			if let labelTextHexValue = try container.decodeIfPresent(String.self, forKey: .label_text_color) {
				labelTextColor = UIColor.init(hex: labelTextHexValue)
			}
			labelTextFontSize = try (container.decodeIfPresent(Int.self, forKey: .label_text_font_size))
			labelTextFontWeight = try (container.decodeIfPresent(Int.self, forKey: .label_text_font_weight))
			if let errorLabelTextHexValue = try container.decodeIfPresent(String.self, forKey: .error_label_text_color) {
				errorLabelTextColor = UIColor.init(hex: errorLabelTextHexValue)
			}
			buttonText = try (container.decodeIfPresent(String.self, forKey: .button_text))
			if let buttonTextHexValue = try container.decodeIfPresent(String.self, forKey: .button_text_color) {
				buttonTextColor = UIColor.init(hex: buttonTextHexValue)
			}
			buttonTextFontSize = try (container.decodeIfPresent(Int.self, forKey: .button_text_font_size))
			buttonTextFontWeight = try (container.decodeIfPresent(Int.self, forKey: .button_text_font_weight))
			buttonStyleId = try (container.decodeIfPresent(ButtonType.self, forKey: .button_style_id))
			if let buttonBackgroundHexValue = try container.decodeIfPresent(String.self, forKey: .button_background_color) {
				buttonBackgroundColor = UIColor.init(hex: buttonBackgroundHexValue)
			}
			if let buttonBorderHexValue = try container.decodeIfPresent(String.self, forKey: .button_border_color) {
				butttonBorderColor = UIColor.init(hex: buttonBorderHexValue)
			}
			buttonIconIsHidden = try (container.decodeIfPresent(Bool.self, forKey: .button_icon_is_hidden))
			buttonShadowIsHidden = try (container.decodeIfPresent(Bool.self, forKey: .button_shadow_is_hidden))
			addedFileIsHidden = try (container.decodeIfPresent(Bool.self, forKey: .added_file_is_hidden))
			bottomNoteIsHidden = try (container.decodeIfPresent(Bool.self, forKey: .bottom_note_is_hidden))
			bottomNoteText = try (container.decodeIfPresent(String.self, forKey: .bottom_note_text))
			ticketTypes = try (container.decodeIfPresent([TicketType].self, forKey: .types))

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
			try container.encodeIfPresent(navigationTitle, forKey: .title)
			try container.encodeIfPresent(formStyleId, forKey: .form_style_id)
			try container.encodeIfPresent(formInputColor?.hexString(includeAlpha: true), forKey: .form_input_color)
			try container.encodeIfPresent(formInputBackgroundColor?.hexString(includeAlpha: true), forKey: .form_input_background_color)
			try container.encodeIfPresent(formInputBorderColor?.hexString(includeAlpha: true), forKey: .form_input_border_color)
			try container.encodeIfPresent(formInputFocusColor?.hexString(includeAlpha: true), forKey: .form_input_focus_color)
			try container.encodeIfPresent(formInputFocusBackgroundColor?.hexString(includeAlpha: true), forKey: .form_input_focus_background_color)
			try container.encodeIfPresent(formInputFocusBorderColor?.hexString(includeAlpha: true), forKey: .form_input_focus_border_color)
			try container.encodeIfPresent(formInputFontSize, forKey: .form_input_font_size)
			try container.encodeIfPresent(formInputFontWeight, forKey: .form_input_font_weight)
			try container.encodeIfPresent(formInputPlaceHolderColor?.hexString(includeAlpha: true), forKey: .form_input_place_holder_color)
			try container.encodeIfPresent(labelTextFontSize, forKey: .label_text_font_size)
			try container.encodeIfPresent(labelTextFontWeight, forKey: .label_text_font_weight)
			try container.encodeIfPresent(errorLabelTextColor?.hexString(includeAlpha: true), forKey: .error_label_text_color)
			try container.encodeIfPresent(buttonText, forKey: .button_text)
			try container.encodeIfPresent(buttonTextColor?.hexString(includeAlpha: true), forKey: .button_text_color)
			try container.encodeIfPresent(buttonTextFontSize, forKey: .button_text_font_size)
			try container.encodeIfPresent(buttonTextFontWeight, forKey: .button_text_font_weight)
			try container.encodeIfPresent(buttonStyleId, forKey: .button_style_id)
			try container.encodeIfPresent(buttonBackgroundColor?.hexString(includeAlpha: true), forKey: .button_background_color)
			try container.encodeIfPresent(butttonBorderColor?.hexString(includeAlpha: true), forKey: .button_border_color)
			try container.encodeIfPresent(addedFileIsHidden, forKey: .added_file_is_hidden)
			try container.encodeIfPresent(buttonIconIsHidden, forKey: .button_icon_is_hidden)
			try container.encodeIfPresent(buttonShadowIsHidden, forKey: .button_shadow_is_hidden)
			try container.encodeIfPresent(bottomNoteIsHidden, forKey: .bottom_note_is_hidden)
			try container.encodeIfPresent(bottomNoteText, forKey: .bottom_note_text)
			try container.encodeIfPresent(ticketTypes, forKey: .types)

		} catch let error as EncodingError {
			print(error)
			throw error
		}
	}

}
