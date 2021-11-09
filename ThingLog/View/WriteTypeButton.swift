//
//  WriteTypeButton.swift
//  ThingLog
//
//  Created by 이지원 on 2021/10/02.
//

import UIKit

/// WriteType에 따라 이미지와 텍스트를 갖고 있는 뷰
/// ChoiceWritingView에서 쓰이는 버튼
final class WriteTypeButton: UIView {
    // MARK: View Properties
    private let iconView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.tintColor = SwiftGenColors.black.color
        return imageView
    }()
    private let textLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.Pretendard.body3
        label.textColor = SwiftGenColors.black.color
        return label
    }()

    // MARK: Properties
    var type: PageType?
    private let iconWidth: CGFloat = 24.0

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    init(type: PageType) {
        super.init(frame: .zero)
        self.type = type
        setupView()
    }

    private func setupView() {
        configureImageWithText()

        let stackView: UIStackView = {
            let stackView: UIStackView = UIStackView(arrangedSubviews: [iconView, textLabel])
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .vertical
            stackView.alignment = .center
            stackView.spacing = 4
            return stackView
        }()

        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: iconWidth),
            iconView.heightAnchor.constraint(equalTo: iconView.widthAnchor)
        ])
    }

    private func configureImageWithText() {
        guard let type = type else {
            return
        }

        iconView.image = type.image
        iconView.layer.cornerRadius = iconWidth / 2

        if type == .bought {
            textLabel.text = "샀다"
        } else if type == .wish {
            textLabel.text = "사고싶다"
        } else {
            textLabel.text = "선물받았다"
        }
    }
}

extension WriteTypeButton {
    func setIcon(_ isHidden: Bool) {
        iconView.image = isHidden ? nil : type?.image
    }

    func setColor(_ color: UIColor) {
        self.textLabel.textColor = color
    }
}
