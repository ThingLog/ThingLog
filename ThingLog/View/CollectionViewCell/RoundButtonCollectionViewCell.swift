//
//  RoundButtonCollectionViewCell.swift
//  ThingLog
//
//  Created by hyunsu on 2021/09/28.
//

import UIKit

final class RoundButtonCollectionViewCell: UICollectionViewCell {
    private var button: UIButton = {
        let button: UIButton = UIButton()
        button.layer.borderWidth = 1.0
        button.layer.borderColor = SwiftGenColors.gray5.color.cgColor
        button.titleLabel?.font = UIFont.Pretendard.body2
        button.clipsToBounds = true
        button.backgroundColor = SwiftGenColors.white.color
        button.setTitleColor(SwiftGenColors.gray5.color, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false 
        return button
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        changeButtonColor(isSelected: false)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupView() {
        contentView.addSubview(button)
        contentView.backgroundColor = SwiftGenColors.white.color
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            button.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
    }
}

extension RoundButtonCollectionViewCell {
    func updateView(title: String, cornerRadius: CGFloat) {
        button.setTitle(title, for: .normal)
        button.layer.cornerRadius = cornerRadius
    }
    
    func changeButtonColor(isSelected: Bool) {
        button.backgroundColor = isSelected ? SwiftGenColors.gray5.color : SwiftGenColors.white.color
        button.setTitleColor(isSelected ? SwiftGenColors.white.color : SwiftGenColors.gray5.color, for: .normal)
    }
}
