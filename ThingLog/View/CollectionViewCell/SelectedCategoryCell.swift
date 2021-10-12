//
//  SelectedCategoryCell.swift
//  ThingLog
//
//  Created by 이지원 on 2021/10/13.
//

import UIKit

final class SelectedCategoryCell: UICollectionViewCell {
    private let label: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.Pretendard.body1
        label.textColor = SwiftGenColors.black.color
        label.text = "전자제품"
        return label
    }()

    private let removeButton: UIButton = {
        let button: UIButton = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(SwiftGenAssets.clear.image, for: .normal)
        button.sizeThatFits(CGSize(width: 10, height: 10))
        return button
    }()

    var removeButtonDidTappedCallback: (() -> Void)?
    private let paddingLeading: CGFloat = 12.0
    private let paddingTrailing: CGFloat = 6.0

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not beem implemented")
    }

    func configure(text: String) {
        label.text = text
    }
}

extension SelectedCategoryCell {
    private func setupView() {
        contentView.layer.cornerRadius = 10
        contentView.backgroundColor = SwiftGenColors.gray6.color

        let stackView: UIStackView = {
            let stackView: UIStackView = UIStackView(arrangedSubviews: [label, removeButton])
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.spacing = 8
            return stackView
        }()

        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: paddingLeading),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -paddingTrailing),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])

        removeButton.addTarget(self, action: #selector(tappedRemoveButton), for: .touchUpInside)
    }

    @objc
    private func tappedRemoveButton() {
        removeButtonDidTappedCallback?()
    }
}
