//
//  LoadingableConfig.swift
//  Desk360
//
//  Created by samet on 22.05.2019.
//

import UIKit
import NVActivityIndicatorView

/// `LoadingableConfig` contains default configurations for `Loadingable` protocol.
///
/// Overriding values for properties in this class will change the default look for the loading indicator in `Loadingable` views.
public final class LoadingableConfig {

	private init() {}

	/// Loading indicator's type. _default value is NVActivityIndicatorType.ballBeat_
	public static var indicatorType: NVActivityIndicatorType = .ballClipRotate

	/// Loading indicator's tint color. _default value is UIColor.white_
	public static var indicatorTintColor: UIColor? = .black

	/// Loading indicator's background color. _default value is UIColor.black_
	public static var indicatorBackgroundColor: UIColor? = .white

	/// Loading indicator's alpha. _default value is 0.95_
	public static var indicatorAlpha: CGFloat = 0.95

	/// Loading indicator's size. _default value is CGSize(width: 100, height: 100)_
	public static var indicatorSize: CGSize = .init(width: 100, height: 100)

	/// Loading indicator's inner padding. _default value is 25.0_
	public static var indicatorPadding: CGFloat = 25.0

	/// Loading indicator's corner radius. _default value is 8.0_
	public static var indicatorCornerRadius: CGFloat = 8.0

	/// Loading indicator's vertical offset from center. _default value is 0.0_
	public static var indicatorVerticalOffset: CGFloat = 0.0

	/// Loading indicator's horizontal offset from center. _default value is 0.0_
	public static var indicatorHorizontalOffset: CGFloat = 0.0

	/// Disable user interaction while loading. _default value is true_
	public static var disableUserInteraction: Bool = true

}
