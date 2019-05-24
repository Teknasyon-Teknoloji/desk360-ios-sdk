//
//  Loadingable.swift
//  Desk360
//
//  Created by samet on 22.05.2019.
//

import UIKit
import NVActivityIndicatorView
import SnapKit

/// `Loadingable` protocol offers a convenient way to show loading in `UIView` objects.
///
/// Override properties in `LoadingableDefaultConfig` to set them globally in your app.
public protocol Loadingable: AnyObject {

	/// Set view's current state to loading, shows a nice loading indicator.
	///
	/// - Parameter loading: whether the view is loading or not.
	func setLoading(_ loading: Bool)

	/// Loading indicator's type.
	///
	/// Override the default value globally by setting `indicatorType` property value in `LoadingableDefaultConfig`
	var indicatorType: NVActivityIndicatorType { get }

	/// Loading indicator's tint color.
	///
	/// Override the default value globally by setting `indicatorTintColor` property value in `LoadingableDefaultConfig`
	var indicatorTintColor: UIColor? { get }

	/// Loading indicator's background color.
	///
	/// Override the default value globally by setting `indicatorBackgroundColor` property value in `LoadingableDefaultConfig`
	var indicatorBackgroundColor: UIColor? { get }

	/// Loading indicator's alpha.
	///
	/// Override the default value globally by setting `indicatorAlpha` property value in `LoadingableDefaultConfig`
	var indicatorAlpha: CGFloat { get }

	/// Loading indicator's size.
	///
	/// Override the default value globally by setting `indicatorSize` property value in `LoadingableDefaultConfig`
	var indicatorSize: CGSize { get }

	/// Loading indicator's inner padding.
	///
	/// Override the default value globally by setting `indicatorPadding` property value in `LoadingableDefaultConfig`
	var indicatorPadding: CGFloat { get }

	/// Loading indicator's corner radius.
	///
	/// Override the default value globally by setting `indicatorCornerRadius` property value in `LoadingableDefaultConfig`
	var indicatorCornerRadius: CGFloat { get }

	/// Loading indicator's vertical offset from center.
	///
	/// Override the default value globally by setting `indicatorVerticallOffset` property value in `LoadingableDefaultConfig`
	var indicatorVerticalOffset: CGFloat { get }

	/// Loading indicator's horizontal offset from center.
	///
	/// Override the default value globally by setting `indicatorHorizontalOffset` property value in `LoadingableDefaultConfig`
	var indicatorHorizontalOffset: CGFloat { get }

	/// Disable user interaction while loading.
	///
	/// Override the default value globally by setting `disableUserInteraction` property value in `LoadingableDefaultConfig`
	var disableUserInteraction: Bool { get }

	/// Whether the app should use `NVActivityIndicatorView` shared instance to present the indicator. _default is `false`_
	var useSharedIndicatorPresenter: Bool { get }

	/// Optional loading message. _default is `nil`_
	var loadingMessage: String? { get }

	/// Optional loading message font. _default is `nil`_
	var loadingMessageFont: UIFont? { get }

	/// Optional loading message text color. _default is `nil`_
	var loadingMessageColor: UIColor? { get }

}

// MARK: - Default implementation for UIView.
public extension Loadingable where Self: UIView {

	/// Loading indicator's type.
	///
	/// Override the default value globally by setting `indicatorType` property value in `LoadingableDefaultConfig`
	var indicatorType: NVActivityIndicatorType {
		return LoadingableConfig.indicatorType
	}

	/// Loading indicator's tint color.
	///
	/// Override the default value globally by setting `indicatorTintColor` property value in `LoadingableDefaultConfig`
	var indicatorTintColor: UIColor? {
		return LoadingableConfig.indicatorTintColor
	}

	/// Loading indicator's background color.
	///
	/// Override the default value globally by setting `indicatorBackgroundColor` property value in `LoadingableDefaultConfig`
	var indicatorBackgroundColor: UIColor? {
		return LoadingableConfig.indicatorBackgroundColor
	}

	/// Loading indicator's alpha.
	///
	/// Override the default value globally by setting `indicatorAlpha` property value in `LoadingableDefaultConfig`
	var indicatorAlpha: CGFloat {
		return LoadingableConfig.indicatorAlpha
	}

	/// Loading indicator's size.
	///
	/// Override the default value globally by setting `indicatorSize` property value in `LoadingableDefaultConfig`
	var indicatorSize: CGSize {
		return LoadingableConfig.indicatorSize
	}

	/// Loading indicator's inner padding.
	///
	/// Override the default value globally by setting `indicatorPadding` property value in `LoadingableDefaultConfig`
	var indicatorPadding: CGFloat {
		return LoadingableConfig.indicatorPadding
	}

	/// Loading indicator's corner radius.
	///
	/// Override the default value globally by setting `indicatorCornerRadius` property value in `LoadingableDefaultConfig`
	var indicatorCornerRadius: CGFloat {
		return LoadingableConfig.indicatorCornerRadius
	}

	/// Loading indicator's vertical offset from center.
	///
	/// Override the default value globally by setting `indicatorVerticallOffset` property value in `LoadingableDefaultConfig`
	var indicatorVerticalOffset: CGFloat {
		return LoadingableConfig.indicatorVerticalOffset
	}

	/// Loading indicator's horizontal offset from center.
	///
	/// Override the default value globally by setting `indicatorHorizontalOffset` property value in `LoadingableDefaultConfig`
	var indicatorHorizontalOffset: CGFloat {
		return LoadingableConfig.indicatorHorizontalOffset
	}

	/// Disable user interaction while loading.
	///
	/// Override the default value globally by setting `disableUserInteraction` property value in `LoadingableDefaultConfig`
	var disableUserInteraction: Bool {
		return LoadingableConfig.disableUserInteraction
	}

	/// Whether the app should use `NVActivityIndicatorView` shared instance to present the indicator. _default is `false`_
	var useSharedIndicatorPresenter: Bool {
		return false
	}

	/// Optional loading message. _default is `nil`_
	var loadingMessage: String? { return nil }

	/// Optional loading message font. _default is `nil`_
	var loadingMessageFont: UIFont? { return nil }

	/// Optional loading message text color. _default is `nil`_
	var loadingMessageColor: UIColor? { return nil }

	/// Set view's current state to loading, shows a nice loading indicator.
	///
	/// - Parameter loading: whether the view is loading or not.
	func setLoading(_ loading: Bool) {
		if let data = createActivityData() {
			loading ? NVActivityIndicatorPresenter.sharedInstance.startAnimating(data) : NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
			return
		}

		if disableUserInteraction {
			isUserInteractionEnabled = !loading
		}

		if loading {
			if let indicator = subviews.first(where: { $0.tag == 314 }) as? NVActivityIndicatorView {
				indicator.startAnimating()
			} else {
				createIndicator().startAnimating()
			}

		} else {
			if let indicator = subviews.first(where: { $0.tag == 314 }) as? NVActivityIndicatorView {
				indicator.stopAnimating()
				indicator.snp.removeConstraints()
				indicator.removeFromSuperview()
			}
		}
	}

}

// MARK: - Private helpers
private extension Loadingable where Self: UIView {

	/// Creates a loading indicator view and adds it above current view.
	///
	/// - Returns: `NVActivityIndicatorView` indicator view.
	func createIndicator() -> NVActivityIndicatorView {
		let indicator = NVActivityIndicatorView(frame: frame, type: indicatorType, color: indicatorTintColor, padding: indicatorPadding)
		indicator.tag = 314
		indicator.backgroundColor = indicatorBackgroundColor
		indicator.alpha = indicatorAlpha
		indicator.layer.cornerRadius = indicatorCornerRadius

		addSubview(indicator)
		indicator.snp.makeConstraints { make in
			make.centerX.equalToSuperview().offset(indicatorHorizontalOffset)
			make.centerY.equalToSuperview().offset(indicatorVerticalOffset)
			make.width.equalTo(indicatorSize.width)
			make.height.equalTo(indicatorSize.height)
		}
		return indicator
	}

	func createActivityData() -> ActivityData? {
		guard useSharedIndicatorPresenter else { return nil }
		return ActivityData(
			size: CGSize(width: indicatorSize.width / 2.5, height: indicatorSize.height / 2.5),
			message: loadingMessage,
			messageFont: loadingMessageFont,
			messageSpacing: 20.0,
			type: indicatorType,
			color: indicatorTintColor,
			backgroundColor: indicatorBackgroundColor?.withAlphaComponent(indicatorAlpha),
			textColor: loadingMessageColor ?? indicatorTintColor
		)
	}

}
