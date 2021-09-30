//
//  Config.swift
//  Desk360
//
//  Created by samet on 4.11.2019.
//

// import PersistenceKit

public struct Config {

	public private(set) static var shared = Config()

	public private(set) var model = Stores.configStore.object

	public func updateConfig(_ newModel: ConfigModel) {
		Config.shared.model = newModel
	}

}

enum FieldType: Int, Codable {
	case line = 1
	case box = 2
	case shadow = 3
}

enum ButtonType: Int, Codable {
	case radius1 = 1
	case radius2 = 2
	case sharp = 3
	case fullWidth = 4
}

/// Use `SupportMessage` to map JSON object returned from the methods in `SupportService`ss
public struct ConfigModel {

	/// General settings all config.
	var generalSettings: GeneralConfigModel?

	/// First screen all config.
	var firstScreen: FirstScreenConfigModel?

	/// Createpre screen all config.
	var createPreScreen: CreatePreScreenConfigModel?

	/// Create screen all config.
	var createScreen: CreateScreenConfigModel?

	/// listing screen all config.
	var ticketListingScreen: TicketListScreenConfigModel?

	/// Listing detail screen all config.
	var ticketDetail: TicketTableViewCellConfigModel?

	/// Succsess screen all config.
	var successScreen: TicketSuccessScreenConfigModel?

	var customFields: [Field]?

}

extension ConfigModel: Codable {

	private enum CodingKeys: String, CodingKey {
		case first_screen
		case general_settings
		case create_pre_screen
		case create_screen
		case ticket_list_screen
		case ticket_detail_screen
		case ticket_success_screen
		case custom_fields
	}

	/// Creates a new instance by decoding from the given decoder.
	///
	/// - Parameter decoder: The decoder to read data from.
	/// - Throws: Decoding error.
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)

		do {
			firstScreen = try? container.decode(FirstScreenConfigModel.self, forKey: .first_screen)
			generalSettings = try? container.decode(GeneralConfigModel.self, forKey: .general_settings)
			createPreScreen = try? container.decode(CreatePreScreenConfigModel.self, forKey: .create_pre_screen)
			createScreen = try? container.decode(CreateScreenConfigModel.self, forKey: .create_screen)
			ticketListingScreen = try? container.decode(TicketListScreenConfigModel.self, forKey: .ticket_list_screen)
			ticketDetail = try? container.decode(TicketTableViewCellConfigModel.self, forKey: .ticket_detail_screen)
			successScreen = try? container.decode(TicketSuccessScreenConfigModel.self, forKey: .ticket_success_screen)
			customFields = try (container.decodeIfPresent([Field].self, forKey: .custom_fields))

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
			try container.encode(firstScreen, forKey: .first_screen)
			try container.encode(generalSettings, forKey: .general_settings)
			try container.encode(createPreScreen, forKey: .create_pre_screen)
			try container.encode(createScreen, forKey: .create_screen)
			try container.encode(ticketListingScreen, forKey: .ticket_list_screen)
			try container.encode(ticketDetail, forKey: .ticket_detail_screen)
			try container.encode(successScreen, forKey: .ticket_success_screen)
			try container.encodeIfPresent(customFields, forKey: .custom_fields)

		} catch let error as EncodingError {
			print(error)
			throw error
		}
	}

}
