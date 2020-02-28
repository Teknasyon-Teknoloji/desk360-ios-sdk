//
//  MessageTextView.swift
//  Desk360
//
//  Created by samet on 31.01.2020.
//

import UIKit

final class CustomMessageTextView: UIView, Layoutable {

	lazy var messageTextView: UITextView = {
		var view = UITextView()
		view.font = UIFont.systemFont(ofSize: CGFloat(Config.shared.model.createScreen?.formInputFontSize ?? 16), weight: Font.weight(type: Config.shared.model.createScreen?.formInputFontWeight ?? 400))
		view.backgroundColor = .clear
		view.textAlignment = UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft ? .right: .left
		return view
	}()

	lazy var frameView: UIView = {
		var view = UIView()
		view.backgroundColor = .clear
		return view
	}()

	func setupViews() {
		addSubview(frameView)
		addSubview(messageTextView)
	}

	func setupLayout() {

		messageTextView.snp.makeConstraints { $0.edges.equalToSuperview() }

		frameView.snp.makeConstraints { $0.edges.equalToSuperview() }

	}

}
