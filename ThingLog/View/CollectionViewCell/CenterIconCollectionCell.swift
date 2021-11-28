//
//  CenterIconCollectionCell.swift
//  ThingLog
//
//  Created by 이지원 on 2021/11/26.
//

import UIKit

/// PhotosViewController 에서 사진 촬영 셀을 표시하기 위한 뷰
final class CenterIconCollectionCell: UICollectionViewCell {
    // MARK: - View Properties
    private let iconView: UIImageView = {
        let icon: UIImage = SwiftGenIcons.camera.image.withTintColor(SwiftGenColors.primaryBlack.color)
        let imageView: UIImageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = icon
        return imageView
    }()

    // MARK: - Properties
    private let iconSize: CGFloat = 28.0

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        backgroundColor = SwiftGenColors.primaryBackground.color
        contentView.addSubview(iconView)

        NSLayoutConstraint.activate([
            iconView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: iconSize),
            iconView.heightAnchor.constraint(equalTo: iconView.widthAnchor)
        ])
    }
}
