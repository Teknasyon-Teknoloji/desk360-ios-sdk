//
//  CreatePreScreenConfig.swift
//  Desk360
//
//  Created by samet on 5.11.2019.
//

public struct CreatePreScreenConfigModel {

	var navigationTitle: String?

	var title: String?

	var titleColor: UIColor?

	var titleFontSize: Int?

	var titleFontWeight: Int?

	var description: String?

	var descriptionColor: UIColor?

	var descriptionFontSize: Int?

	var descriptionFontWeight: Int?

	var buttonText: String?

	var buttonTextColor: UIColor?

	var buttonTextFontSize: Int?

	var buttonTextFontWeight: Int?

	var buttonStyleId: Int?

	var buttonBackgroundColor: UIColor?

	var butttonBorderColor: UIColor?

	var buttonIconIsHidden: Bool?

	var buttonShadowIsHidden: Bool?

	var bottomNoteIsHidden: Bool?

	var bottomNoteText: String?

}

extension CreatePreScreenConfigModel: Codable {

	private enum CodingKeys: String, CodingKey {
		case title
		case sub_title
		case sub_title_color
		case sub_title_font_size
		case sub_title_font_weight
		case description
		case description_color
		case description_font_size
		case description_font_weight
		case button_text
		case button_text_color
		case button_text_font_size
		case button_text_font_weight
		case button_style_id
		case button_background_color
		case button_border_color
		case button_icon_is_hidden
		case button_shadow_is_hidden
		case bottom_note_is_hidden
		case bottom_note_text
	}

	/// Creates a new instance by decoding from the given decoder.
	///
	/// - Parameter decoder: The decoder to read data from.
	/// - Throws: Decoding error.
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)

		do {
			navigationTitle = try (container.decodeIfPresent(String.self, forKey: .title))
			title = try (container.decodeIfPresent(String.self, forKey: .sub_title))
			if let titleHexValue = try container.decodeIfPresent(String.self, forKey: .sub_title_color) {
				titleColor = UIColor.init(hex: titleHexValue)
			}
			titleFontSize = try (container.decodeIfPresent(Int.self, forKey: .sub_title_font_size))
			titleFontWeight = try (container.decodeIfPresent(Int.self, forKey: .sub_title_font_weight))
			description =  try (container.decodeIfPresent(String.self, forKey: .description))
			if let descriptionHexValue = try container.decodeIfPresent(String.self, forKey: .description_color) {
				descriptionColor = UIColor.init(hex: descriptionHexValue)
			}
			descriptionFontSize =  try (container.decodeIfPresent(Int.self, forKey: .description_font_size))
			descriptionFontWeight =  try (container.decodeIfPresent(Int.self, forKey: .description_font_weight))
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
			bottomNoteIsHidden = try (container.decodeIfPresent(Bool.self, forKey: .bottom_note_is_hidden))
			bottomNoteText = try (container.decodeIfPresent(String.self, forKey: .bottom_note_text))

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
			try container.encodeIfPresent(title, forKey: .sub_title)
			try container.encodeIfPresent(titleColor?.hexString(includeAlpha: true), forKey: .sub_title_color)
			try container.encodeIfPresent(titleFontSize, forKey: .sub_title_font_size)
			try container.encodeIfPresent(titleFontWeight, forKey: .sub_title_font_weight)
			try container.encodeIfPresent(description, forKey: .description)
			try container.encodeIfPresent(descriptionColor?.hexString(includeAlpha: true), forKey: .description_color)
			try container.encodeIfPresent(descriptionFontSize, forKey: .description_font_size)
			try container.encodeIfPresent(descriptionFontWeight, forKey: .description_font_weight)
			try container.encodeIfPresent(buttonText, forKey: .button_text)
			try container.encodeIfPresent(buttonTextColor?.hexString(includeAlpha: true), forKey: .button_text_color)
			try container.encodeIfPresent(buttonTextFontSize, forKey: .button_text_font_size)
			try container.encodeIfPresent(buttonTextFontWeight, forKey: .button_text_font_weight)
			try container.encodeIfPresent(buttonStyleId, forKey: .button_style_id)
			try container.encodeIfPresent(buttonBackgroundColor?.hexString(includeAlpha: true), forKey: .button_background_color)
			try container.encodeIfPresent(butttonBorderColor?.hexString(includeAlpha: true), forKey: .button_border_color)
			try container.encodeIfPresent(buttonIconIsHidden, forKey: .button_icon_is_hidden)
			try container.encodeIfPresent(buttonShadowIsHidden, forKey: .button_shadow_is_hidden)
			try container.encodeIfPresent(bottomNoteIsHidden, forKey: .bottom_note_is_hidden)
			try container.encodeIfPresent(bottomNoteText, forKey: .bottom_note_text)

		} catch let error as EncodingError {
			print(error)
			throw error
		}
	}

}

