//
//  CameraButtonCollectionCell.swift
//  ThingLog
//
//  Created by 이지원 on 2021/10/05.
//

import UIKit

/// 글쓰기 화면에 들어가는 사진 등록 버튼
/// [이미지](https://www.notion.so/CameraButtonCollectionCell-72aa2d9a582c4bea9d60f66d4eb8dc34)
final class CameraButtonCollectionCell: UICollectionViewCell {
    private let iconImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = SwiftGenIcons.camera.image.withTintColor(SwiftGenColors.primaryBlack.color)
        imageView.contentMode = .scaleAspectFit
        imageView.sizeToFit()
        imageView.setContentHuggingPriority(.required, for: .vertical)
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        return imageView
    }()

    private let countLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0/10"
        label.font = UIFont.Pretendard.caption
        label.textColor = SwiftGenColors.primaryBlack.color
        label.sizeToFit()
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()

    private lazy var iconStackView: UIStackView = {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [iconImageView, countLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 4
        return stackView
    }()

    private let emptyTopView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let emptyBottomView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let maxCount: Int = 10
    private let paddingTopTrailing: CGFloat = 8
    private let emptyViewWidth: CGFloat = 62
    private let emptyViewHeight: CGFloat = 12

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("not implemnted")
    }

    func update(count: Int) {
        countLabel.text = "\(count)/\(maxCount)"
    }
}

extension CameraButtonCollectionCell {
    private func setupView() {
        let backgroundView: UIView = {
            let view: UIView = UIView()
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            view.backgroundColor = SwiftGenColors.primaryBackground.color
            view.clipsToBounds = true
            view.layer.cornerRadius = 4
            view.layer.borderColor = SwiftGenColors.primaryBlack.color.cgColor
            view.layer.borderWidth = 0.5
            return view
        }()

        let stackView: UIStackView = {
            let stackView: UIStackView = UIStackView()
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .vertical
            stackView.alignment = .center
            return stackView
        }()

        stackView.addSubview(backgroundView)
        stackView.addArrangedSubview(emptyTopView)
        stackView.addArrangedSubview(iconStackView)
        stackView.addArrangedSubview(emptyBottomView)
        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                           constant: paddingTopTrailing),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                constant: -paddingTopTrailing),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            emptyTopView.heightAnchor.constraint(equalToConstant: emptyViewHeight),
            emptyBottomView.heightAnchor.constraint(greaterThanOrEqualToConstant: 0),
            emptyTopView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            emptyBottomView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            iconImageView.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
}
