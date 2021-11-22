//
//  LabelWithButtonRoundCollectionCell.swift
//  ThingLog
//
//  Created by 이지원 on 2021/10/13.
//

import UIKit

/// 글쓰기 화면에서 선택된 카테고리를 보여주기 위한 셀
///
/// [이미지](https://www.notion.so/TextWithButtonRoundCollectionCell-977a80b4d4274f04bbea32dce171e35f)
final class LabelWithButtonRoundCollectionCell: UICollectionViewCell {
    private let label: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.Pretendard.body1
        label.textColor = SwiftGenColors.primaryBlack.color
        return label
    }()

    private let removeButton: UIButton = {
        let button: UIButton = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(SwiftGenAssets.clear.image.withTintColor(SwiftGenColors.primaryBlack.color), for: .normal)
        button.sizeThatFits(CGSize(width: 10, height: 10))
        return button
    }()

    var removeButtonDidTappedCallback: (() -> Void)?
    private let leadingTrailingSpacing: CGFloat = 8.0

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not beem implemented")
    }

    func configure(text: String, buttonIsHidden: Bool = false) {
        label.text = text
        removeButton.isHidden = buttonIsHidden
    }

    func configureColor(_ color: UIColor) {
        contentView.layer.borderColor = color.cgColor
        label.textColor = color
    }
}

extension LabelWithButtonRoundCollectionCell {
    private func setupView() {
        contentView.layer.cornerRadius = 10
        contentView.backgroundColor = .clear
        contentView.layer.borderColor = SwiftGenColors.primaryBlack.color.cgColor
        contentView.layer.borderWidth = 1.0

        let stackView: UIStackView = {
            let stackView: UIStackView = UIStackView(arrangedSubviews: [label, removeButton])
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.spacing = 8
            return stackView
        }()

        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: leadingTrailingSpacing),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -leadingTrailingSpacing),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])

        removeButton.addTarget(self, action: #selector(tappedRemoveButton), for: .touchUpInside)
    }

    @objc
    private func tappedRemoveButton() {
        removeButtonDidTappedCallback?()
    }
}
