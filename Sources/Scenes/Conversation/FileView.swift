//
//  FileView.swift
//  Desk360
//
//  Created by Ali Ammar Hilal on 8.11.2021.
//

import UIKit

/// A UIView based calss to render different files representations on the secren.
final class FileView: UIView {
    
    /// The file icon.
    lazy var icon: UIImageView = {
        let view = UIImageView()
        view.pinSize(.init(width: 38, height: 36))
        return view
    }()
    
    /// The file name.
    lazy var fileName: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = Colors.ticketDetailChatReceiverTextColor
        return label
    }()
    
    /// The file object of type `AttachObject` to be rendered.
    var file: AttachObject? {
        didSet {
            guard let file = file else { return }
            fileName.text = file.name
            icon.image = file.image?.withRenderingMode(.alwaysOriginal)
        }
    }
    
    /// A call back closure to be triggered when atappping on the file name or icon.
    var onFileSelected: ((AttachObject) -> Void)?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapFile)))
        let stack: UIView = .hStack(alignment: .center, distribution: .fill, spacing: 8, [icon, fileName])
        addSubview(stack)
        stack.pinToSuperviewEdges(padding: .init(top: 10, left: 0, bottom: 10, right: 12))
    }
    
    @objc private func didTapFile() {
        guard let file = file else {
            return
        }
        onFileSelected?(file)
    }
}
