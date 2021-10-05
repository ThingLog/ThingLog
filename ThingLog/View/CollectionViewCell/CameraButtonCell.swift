//
//  CameraButtonCell.swift
//  ThingLog
//
//  Created by 이지원 on 2021/10/05.
//

import UIKit

/// 글쓰기 화면에 들어가는 사진 등록 버튼
final class CameraButtonCell: UICollectionViewCell {
    private let iconImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = SwiftGenAssets.camera.image
        return imageView
    }()

    private let countLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0/10"
        label.font = UIFont.Pretendard.caption
        return label
    }()

    private let maxCount: Int = 10

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

extension CameraButtonCell {
    private func setupView() {
        contentView.clipsToBounds = true
        contentView.layer.borderColor = SwiftGenColors.gray6.color.cgColor
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 4
        contentView.backgroundColor = SwiftGenColors.gray6.color

        let stackView: UIStackView = {
            let stackView: UIStackView = UIStackView(arrangedSubviews: [iconImageView, countLabel])
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .vertical
            stackView.distribution = .equalSpacing
            stackView.spacing = 4
            stackView.alignment = .center
            stackView.backgroundColor = SwiftGenColors.gray6.color
            return stackView
        }()

        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
