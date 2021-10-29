//
//  ImageWithVerticalTwoLabelTableCell.swift
//  ThingLog
//
//  Created by 이지원 on 2021/10/28.
//

import UIKit

/// 글쓰기>사진첩 선택 화면에서 앨범 목록을 보여주기 위한 TableCell
/// ![이미지](https://www.notion.so/ImageWithVerticalTwoLabelTableCell-d2892451212148fab7e175666054cd2f)
final class ImageWithVerticalTwoLabelTableCell: UITableViewCell {
    private let roundImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.backgroundColor = SwiftGenColors.gray6.color
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = SwiftGenColors.black.color
        label.font = UIFont.Pretendard.title1
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = SwiftGenColors.gray3.color
        label.font = UIFont.Pretendard.body2
        return label
    }()

    private let imageWidth: CGFloat = 80.0
    private let imageHeight: CGFloat = 100.0

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0.0, left: 16.0, bottom: 20.0, right: 16.0))
    }

    func configure(image: UIImage?, title: String, description: String) {
        roundImageView.image = image
        titleLabel.text = title
        descriptionLabel.text = description
    }
}

extension ImageWithVerticalTwoLabelTableCell {
    private func setupView() {
        selectionStyle = .none
        backgroundColor = .clear

        let labelStackView: UIStackView = {
            let stackView: UIStackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .vertical
            stackView.alignment = .fill
            stackView.spacing = 0
            return stackView
        }()

        let stackView: UIStackView = {
            let stackView: UIStackView = UIStackView(arrangedSubviews: [roundImageView, labelStackView])
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.alignment = .center
            stackView.spacing = 16
            return stackView
        }()

        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            roundImageView.widthAnchor.constraint(equalToConstant: imageWidth),
            roundImageView.heightAnchor.constraint(equalToConstant: imageHeight)
        ])
    }
}
