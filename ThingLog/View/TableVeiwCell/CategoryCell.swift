//
//  CategoryCell.swift
//  ThingLog
//
//  Created by 이지원 on 2021/10/13.
//

import UIKit

final class CategoryCell: UITableViewCell {
    private let nameLabel: PaddingLabel = {
        let label: PaddingLabel = PaddingLabel(padding: .init(top: 1, left: 8, bottom: 1, right: 8))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.Pretendard.body1
        label.textColor = SwiftGenColors.black.color
        label.text = "사무용품"
        label.clipsToBounds = true
        label.layer.cornerRadius = 10
        label.backgroundColor = SwiftGenColors.gray6.color
        return label
    }()

    private let emptyView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return view
    }()

    private let selectedButton: UIButton = {
        let button: UIButton = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.layer.borderWidth = 1
        button.layer.borderColor = SwiftGenColors.black.color.cgColor
        button.titleLabel?.font = UIFont.Pretendard.body3
        button.setTitleColor(SwiftGenColors.white.color, for: .normal)
        button.isUserInteractionEnabled = false
        return button
    }()

    var isSelectedCategory: Bool = false {
        didSet {
            selectedButton.backgroundColor = isSelectedCategory ? SwiftGenColors.black.color : SwiftGenColors.white.color
        }
    }
    private let buttonSize: CGFloat = 24.0
    private let paddingLeadingTrailing: CGFloat = 18.0
    private let paddingTopBottom: CGFloat = 12.0

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(selectedOrder: Int) {
        selectedButton.setTitle("\(selectedOrder)", for: .normal)
    }
}

extension CategoryCell {
    private func setupView() {
        selectionStyle = .none

        selectedButton.layer.cornerRadius = buttonSize / 2

        let stackView: UIStackView = {
            let stackView: UIStackView = UIStackView(arrangedSubviews: [nameLabel, emptyView, selectedButton])
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .horizontal
            return stackView
        }()

        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: paddingLeadingTrailing),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: paddingTopBottom),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -paddingLeadingTrailing),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -paddingTopBottom),
            selectedButton.widthAnchor.constraint(equalToConstant: buttonSize),
            selectedButton.heightAnchor.constraint(equalTo: selectedButton.widthAnchor)
        ])
    }
}
