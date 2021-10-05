//
//  ThumbnailCell.swift
//  ThingLog
//
//  Created by 이지원 on 2021/10/02.
//

import UIKit

/// 글쓰기 화면에 들어가는 첨부한 사진을 보여주는 셀
final class ThumbnailCell: UICollectionViewCell {
    private let imageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 1
        imageView.layer.cornerRadius = 4
        imageView.layer.borderColor = SwiftGenColors.gray5.color.cgColor
        return imageView
    }()

    private let closeButton: UIButton = {
        let button: UIButton = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(SwiftGenAssets.closeBadge.image, for: .normal)
        return button
    }()

    // MARK: Properties
    var closeButtonDidTappedCallback: (() -> Void)?
    private let thumbnailImageViewWidth: CGFloat = 62.0
    private let closeButtonWidth: CGFloat = 16.0

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
        closeButton.addTarget(self, action: #selector(tappedCloseButton), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not beem implemented")
    }

    func configure(image: UIImage?) {
        imageView.image = image
    }
}

extension ThumbnailCell {
    private func setupView() {
        contentView.clipsToBounds = false
        closeButton.layer.cornerRadius = closeButtonWidth / 2

        contentView.addSubview(imageView)
        contentView.addSubview(closeButton)

        NSLayoutConstraint.activate([
            // imageView
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            // closeButton
            closeButton.widthAnchor.constraint(equalToConstant: closeButtonWidth),
            closeButton.heightAnchor.constraint(equalTo: closeButton.widthAnchor),
            closeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: closeButtonWidth / 2),
            closeButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: -(closeButtonWidth / 2))
        ])
    }

    @objc
    private func tappedCloseButton() {
        closeButtonDidTappedCallback?()
    }
}
