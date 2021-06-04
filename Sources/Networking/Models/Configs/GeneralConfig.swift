//
//  GeneralConfig.swift
//  Desk360
//
//  Created by samet on 4.11.2019.
//

/// Use `SupportMessage` to map JSON object returned from the methods in `SupportService`
public struct GeneralConfigModel {
	var fontType: String?
	var mainBackgroundColor: UIColor?
	var navigationBackgroundColor: UIColor?
	var navigationTextColor: UIColor?
	var navigationTitleFontSize: Int?
	var navigationTitleFontWeight: Int?
	var navigationImageViewTintColor: UIColor?
	var navigationShadow: Bool?
	var bottomNoteColor: UIColor?
	var bottomNoteFontSize: Int?
	var bottomNoteFontWeight: Int?
	var copyrightBackgroundColor: UIColor?
	var copyrightTextColor: UIColor?
	var nameFieldText: String?
	var emailFieldText: String?
	var messageFieldText: String?
	var subjectFieldText: String?
	var addFileText: String?
	var requiredFieldMessage: String?
	var requiredMessageViewMessage: String?
	var attachmentBrowseText: String?
	var attachmentImagesText: String?
	var attachmentCancelText: String?
	var galleryPermissionErrorMessage: String?
	var requiredEmailFieldMessage: String?
	var galleryPermissionErrorButtonText: String?
	var fileSizeErrorText: String?
    let isLogoHidden: Bool
}

extension GeneralConfigModel: Codable {

	private enum CodingKeys: String, CodingKey {
		case font_type
		case main_background_color
		case header_background_color
		case header_text_color
		case header_text_font_size
		case header_text_font_weight
		case header_icon_color
		case header_shadow_is_hidden
		case bottom_note_color
		case bottom_note_font_size
		case bottom_note_font_weight
		case copyright_background_color
		case copyright_text_color
		case name_field_text
		case email_field_text
		case message_field_text
		case subject_field_text
		case add_file_text
		case required_field_message
		case required_textarea_message
		case required_email_field_message
		case attachment_browse_text
		case attachment_images_text
		case attachment_cancel_text
		case gallery_permission_error_message
		case gallery_permission_error_button_text
		case file_size_error_text
        case copyright_logo_is_show
	}

	/// Creates a new instance by decoding from the given decoder.
	///
	/// - Parameter decoder: The decoder to read data from.
	/// - Throws: Decoding error.
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)

		do {
			fontType = try (container.decodeIfPresent(String.self, forKey: .font_type))
			if let navigationBackgroundHexValue = try container.decodeIfPresent(String.self, forKey: .header_background_color) {
				navigationBackgroundColor = UIColor.init(hex: navigationBackgroundHexValue)
			}
			if let navigationTitleHexValue = try container.decodeIfPresent(String.self, forKey: .header_text_color) {
				navigationTextColor = UIColor.init(hex: navigationTitleHexValue)
			}
			navigationTitleFontSize = try (container.decodeIfPresent(Int.self, forKey: .header_text_font_size))
			navigationTitleFontWeight = try (container.decodeIfPresent(Int.self, forKey: .header_text_font_weight))
			if let navigationIconTintHexValue = try container.decodeIfPresent(String.self, forKey: .header_icon_color) {
				navigationImageViewTintColor = UIColor.init(hex: navigationIconTintHexValue)
			}
			navigationShadow = try (container.decodeIfPresent(Bool.self, forKey: .header_shadow_is_hidden))
			if let mainBackgroundHexValue = try container.decodeIfPresent(String.self, forKey: .main_background_color) {
				mainBackgroundColor = UIColor.init(hex: mainBackgroundHexValue)
			}
			if let bottomNoteHexValue  = try container.decodeIfPresent(String.self, forKey: .bottom_note_color) {
				bottomNoteColor = UIColor.init(hex: bottomNoteHexValue)
			}
			bottomNoteFontSize = try (container.decodeIfPresent(Int.self, forKey: .bottom_note_font_size))
			bottomNoteFontWeight = try (container.decodeIfPresent(Int.self, forKey: .bottom_note_font_weight))
			if let copyrightBackgroundHexValue  = try container.decodeIfPresent(String.self, forKey: .copyright_background_color) {
				copyrightBackgroundColor = UIColor.init(hex: copyrightBackgroundHexValue)
			}
			if let copyrightTextHexValue  = try container.decodeIfPresent(String.self, forKey: .copyright_text_color) {
				copyrightTextColor = UIColor.init(hex: copyrightTextHexValue)
			}
			nameFieldText = try (container.decodeIfPresent(String.self, forKey: .name_field_text))
			emailFieldText = try (container.decodeIfPresent(String.self, forKey: .email_field_text))
			messageFieldText = try (container.decodeIfPresent(String.self, forKey: .message_field_text))
			subjectFieldText = try (container.decodeIfPresent(String.self, forKey: .subject_field_text))
			addFileText = try (container.decodeIfPresent(String.self, forKey: .add_file_text))
			requiredFieldMessage = try (container.decodeIfPresent(String.self, forKey: .required_field_message))
			requiredEmailFieldMessage = try (container.decodeIfPresent(String.self, forKey: .required_email_field_message))
			requiredMessageViewMessage = try (container.decodeIfPresent(String.self, forKey: .required_textarea_message))
			attachmentBrowseText = try (container.decodeIfPresent(String.self, forKey: .attachment_browse_text))
			attachmentImagesText = try (container.decodeIfPresent(String.self, forKey: .attachment_images_text))
			attachmentCancelText = try (container.decodeIfPresent(String.self, forKey: .attachment_cancel_text))
			galleryPermissionErrorMessage = try (container.decodeIfPresent(String.self, forKey: .gallery_permission_error_message))
			galleryPermissionErrorButtonText = try (container.decodeIfPresent(String.self, forKey: .gallery_permission_error_button_text))
			fileSizeErrorText = try (container.decodeIfPresent(String.self, forKey: .file_size_error_text))
            isLogoHidden = !(try container.decodeIfPresent(Bool.self, forKey: .copyright_logo_is_show) ?? true)
            print("hahah", isLogoHidden)
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
			try container.encodeIfPresent(fontType, forKey: .font_type)
			try container.encodeIfPresent(mainBackgroundColor?.hexString(includeAlpha: true), forKey: .main_background_color)
			try container.encodeIfPresent(navigationBackgroundColor?.hexString(includeAlpha: true), forKey: .header_background_color)
			try container.encodeIfPresent(navigationTextColor?.hexString(includeAlpha: true), forKey: .header_text_color)
			try container.encodeIfPresent(navigationTitleFontSize, forKey: .header_text_font_size)
			try container.encodeIfPresent(navigationTitleFontWeight, forKey: .bottom_note_font_weight)
			try container.encodeIfPresent(navigationImageViewTintColor?.hexString(includeAlpha: true), forKey: .header_icon_color)
			try container.encodeIfPresent(navigationShadow, forKey: .header_shadow_is_hidden)
			try container.encodeIfPresent(bottomNoteColor?.hexString(includeAlpha: true), forKey: .bottom_note_color)
			try container.encodeIfPresent(bottomNoteFontSize, forKey: .bottom_note_font_size)
			try container.encodeIfPresent(bottomNoteFontWeight, forKey: .bottom_note_font_weight)
			try container.encodeIfPresent(copyrightBackgroundColor?.hexString(includeAlpha: true), forKey: .copyright_background_color)
			try container.encodeIfPresent(copyrightTextColor?.hexString(includeAlpha: true), forKey: .copyright_text_color)
			try container.encodeIfPresent(nameFieldText, forKey: .name_field_text)
			try container.encodeIfPresent(emailFieldText, forKey: .email_field_text)
			try container.encodeIfPresent(messageFieldText, forKey: .message_field_text)
			try container.encodeIfPresent(subjectFieldText, forKey: .subject_field_text)
			try container.encodeIfPresent(addFileText, forKey: .add_file_text)
			try container.encodeIfPresent(requiredFieldMessage, forKey: .required_field_message)
			try container.encodeIfPresent(requiredEmailFieldMessage, forKey: .required_email_field_message)
			try container.encodeIfPresent(requiredMessageViewMessage, forKey: .required_textarea_message)
			try container.encodeIfPresent(attachmentBrowseText, forKey: .attachment_browse_text)
			try container.encodeIfPresent(attachmentImagesText, forKey: .attachment_images_text)
			try container.encodeIfPresent(attachmentCancelText, forKey: .attachment_cancel_text)
			try container.encodeIfPresent(galleryPermissionErrorMessage, forKey: .gallery_permission_error_message)
			try container.encodeIfPresent(galleryPermissionErrorButtonText, forKey: .gallery_permission_error_button_text)
			try container.encodeIfPresent(fileSizeErrorText, forKey: .file_size_error_text)
			} catch let error as EncodingError {
			print(error)
			throw error
		}
	}

}
