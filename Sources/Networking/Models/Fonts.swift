//
//  Fonts.swift
//  Desk360
//
//  Created by OsmanYıldırım on 24.06.2022.
//

import Foundation
import UIKit

enum Fonts {
    enum FontNames: String, CaseIterable {
        case bold = "Montserrat-Bold"
        case light = "Montserrat-Light"
        case medium = "Montserrat-Medium"
        case regular = "Montserrat-Regular"
        case semiBold = "Montserrat-SemiBold"
        case thin = "Montserrat-Thin"
    }

    enum Montserrat: CaseIterable {
        static let bold = UIFont(name: FontNames.bold.name, size: 18)!
        static let light = UIFont(name: FontNames.light.name, size: 18)!
        static let medium = UIFont(name: FontNames.medium.name, size: 18)!
        static let regular = UIFont(name: FontNames.regular.name, size: 18)!
        static let semiBold = UIFont(name: FontNames.semiBold.name, size: 18)!
        static let thin = UIFont(name: FontNames.thin.name, size: 18)!

        static func registerFonts() {
            _ = Fonts.FontNames.allCases.map({ UIFont.registerFont($0.path) })
        }
    }
}

extension Fonts.FontNames {
    var name: String { rawValue }

    var path: String { "Fonts/\(name).otf" }
}

extension UIFont {
    func font(size: CGFloat) -> UIFont {
        return self.withSize(size)
    }

    static func registerFont(_ font: String) {
        guard let path = Bundle.fontsBundle?.path(forResource: font, ofType: nil),
              let data = NSData(contentsOfFile: path),
              let dataProvider = CGDataProvider(data: data),
              let fontReference = CGFont(dataProvider)else { return }
        CTFontManagerRegisterGraphicsFont(fontReference, nil)
    }
}
