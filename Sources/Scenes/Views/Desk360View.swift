//
//  Desk360View.swift
//  Desk360
//
//  Created by samet on 3.02.2020.
//

import Foundation

/// This view using for bottom desk360 bottom bar
final class Desk360View: UIView, Layoutable {

	private lazy var desk360LogoImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.image =  Desk360.Config.Images.desk360Logo
		imageView.contentMode = .scaleAspectFit
		return imageView
	}()

	func setupViews() {
		backgroundColor = .clear
        desk360LogoImageView.isHidden = Config.shared.model?.generalSettings?.isLogoHidden ?? false
		addSubview(desk360LogoImageView)
	}

	func setupLayout() {
		desk360LogoImageView.snp.makeConstraints { make in
			make.centerX.equalToSuperview()
			make.top.equalToSuperview()
		}
	}
}
