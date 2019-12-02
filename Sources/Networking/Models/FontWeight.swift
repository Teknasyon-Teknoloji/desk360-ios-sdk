//
//  FontWeight.swift
//  Desk360
//
//  Created by samet on 5.11.2019.
//

public final class Font {

	static func weight(type: Int) -> UIFont.Weight {

		switch type {
		case 100:
			return UIFont.Weight.ultraLight
		case 200:
			return UIFont.Weight.thin
		case 300:
			return UIFont.Weight.light
		case 400:
			return UIFont.Weight.regular
		case 500:
			return UIFont.Weight.medium
		case 600:
			return UIFont.Weight.semibold
		case 700:
			return UIFont.Weight.bold
		case 800:
			return UIFont.Weight.heavy
		case 900:
			return UIFont.Weight.black
		default:
			return UIFont.Weight.regular
		}
	}

}
