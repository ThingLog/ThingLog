//
//  WriteRatingCell.swift
//  ThingLog
//
//  Created by 이지원 on 2021/10/11.
//

import UIKit

/// 글쓰기 화면에서 만족도를 입력할 때 사용하는 셀
final class WriteRatingCell: UITableViewCell {
    private let label: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = SwiftGenColors.black.color
        label.font = UIFont.Pretendard.body1
        label.text = "만족도"
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()

    private let ratingView: RatingView = {
        let ratingView: RatingView = RatingView()
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        return ratingView
    }()

    var currentRating: Int { ratingView.currentRating }
    private let paddingLabelLeading: CGFloat = 31.0
    private let paddingLabelTrailing: CGFloat = 60.0
    private let paddingLabelTopBottom: CGFloat = 20.0
    private let paddingRatingTopBottom: CGFloat = 18.0
    private let paddingRatingTrailing: CGFloat = 46.0

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WriteRatingCell {
    private func setupView() {
        selectionStyle = .none

        contentView.addSubview(label)
        contentView.addSubview(ratingView)

        NSLayoutConstraint.activate([
            // Rating Label
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: paddingLabelLeading),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: paddingLabelTopBottom),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -paddingLabelTopBottom),
            // Rating View
            ratingView.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: paddingLabelTrailing),
            ratingView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: paddingRatingTopBottom),
            ratingView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -paddingRatingTrailing),
            ratingView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -paddingLabelTopBottom)
        ])
    }
}
