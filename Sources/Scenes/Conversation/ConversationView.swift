//
//  ConversationView.swift
//  Desk360
//
//  Created by samet on 18.05.2019.
//

import UIKit

/// This view is used to chat screen
final class ConversationView: UIView, Layoutable, Loadingable {

	/// This parameter is used to detect third party keyboard actions.
	var isCustomKeyboardActive = false
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.tintColor = Colors.typography
        button.setImage(Desk360.Config.Images.backIcon, for: .normal)
        return button
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.typography
        label.textAlignment = .center
//        label.font = FontFamily.Montserrat.semiBold.font(size: 18)
        return label
    }()

    private lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.paleLilac
        return view
    }()

    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.image = Desk360.Config.Images.conversationBackgroundFile
        return imageView
    }()
    
	lazy var tableView: UITableView = {
		let view = UITableView()
        view.backgroundColor = .clear
		view.separatorStyle = .none
		view.keyboardDismissMode = .onDrag
		view.showsVerticalScrollIndicator = false
		view.rowHeight = UITableView.automaticDimension
		view.estimatedRowHeight = 200.0
		return view
	}()

	func setupViews() {
        addSubview(backgroundImageView)
        addSubview(backButton)
        addSubview(titleLabel)
        addSubview(bottomView)
        addSubview(tableView)
	}

	func setupLayout() {
        backgroundImageView.snp.makeConstraints { make in
            make.top.equalTo(bottomView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        backButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(preferredSpacing * 3.2)
            make.leading.equalToSuperview().inset(preferredSpacing)
            make.height.width.equalTo(preferredSpacing * 1.6)
        }

        bottomView.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom).offset(9)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }

        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(backButton.snp.centerY)
            make.leading.equalToSuperview().inset(24)
            make.trailing.equalToSuperview().inset(40)
        }
        
		tableView.snp.makeConstraints { make in
            make.top.equalTo(bottomView.snp.bottom).offset(preferredSpacing * 0.2)
			make.leading.trailing.equalToSuperview()
			make.bottom.equalToSuperview()
		}
	}
}

// MARK: - Configure
extension ConversationView {
	func configure() {
        self.backgroundColor = .white// Colors.ticketDetailChatBackgroundColor
	}
}
