//
//  thumbnailCell.swift
//  ThingLog
//
//  Created by 이지원 on 2021/10/04.
//

import UIKit

/// 글쓰기 화면에 들어가는 선택한 사진을 미리 보여주는 셀
final class ThumbnailCell: UICollectionViewCell {
    private let imageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError("not implemnted")
    }
}

extension ThumbnailCell {
    private func configure() {
        contentView.clipsToBounds = true
        contentView.layer.borderColor = SwiftGenColors.gray5.color.cgColor
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 4
        contentView.layer.zPosition = -100

        addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
