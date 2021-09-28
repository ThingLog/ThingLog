//
//  RoundButtonCollectionViewCell.swift
//  ThingLog
//
//  Created by hyunsu on 2021/09/28.
//

import UIKit

class RoundButtonCollectionViewCell: UICollectionViewCell {
    private var button: UIButton = {
        let button: UIButton = UIButton()
        button.layer.cornerRadius = 13
        button.layer.borderWidth = 1.0
        button.layer.borderColor = SwiftGenColors.gray5.color.cgColor
        button.titleLabel?.font = UIFont.Pretendard.body2
        button.clipsToBounds = true
        button.backgroundColor = SwiftGenColors.gray5.color
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupView() {
        contentView.addSubview(button)
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            button.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
    }
}

extension RoundButtonCollectionViewCell {
    func updateView(title: String) {
        button.setTitle(title, for: .normal)
    }
    
    func changeButtonColor(isSelected: Bool) {
        button.backgroundColor = isSelected ? SwiftGenColors.gray5.color : SwiftGenColors.white.color
        button.setTitleColor(isSelected ? SwiftGenColors.white.color : SwiftGenColors.gray5.color, for: .normal)
    }
}
