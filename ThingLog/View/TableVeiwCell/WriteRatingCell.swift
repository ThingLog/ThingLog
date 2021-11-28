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
        label.textColor = SwiftGenColors.primaryBlack.color
        label.font = UIFont.Pretendard.body1
        label.text = "만족도"
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()

    private let ratingView: RatingView = {
        let ratingView: RatingView = RatingView()
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        ratingView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        ratingView.setContentHuggingPriority(.defaultLow, for: .vertical)
        return ratingView
    }()

    /// 현재 선택한 만족도를 숫자로 반환한다.
    var currentRating: Int { ratingView.currentRating }
    /// 만족도 버튼을 선택했을 때 호출할 클로저
    var selectRatingBlock: (() -> Void)? {
        didSet {
            ratingView.didTapButtonBlock = selectRatingBlock
        }
    }
    private let paddingLabelMinLeading: CGFloat = 10.0
    private let paddingLabelLeading: CGFloat = 26.0
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

    func setCurrentRating(_ rating: Int) {
        ratingView.currentRating = rating
    }
}

extension WriteRatingCell {
    private func setupView() {
        selectionStyle = .none
        contentView.backgroundColor = SwiftGenColors.primaryBackground.color
        contentView.addSubviews(label, ratingView)

        let ratingViewLeadingConstraint: NSLayoutConstraint = ratingView.leadingAnchor.constraint(lessThanOrEqualTo: label.trailingAnchor, constant: paddingLabelTrailing)
        ratingViewLeadingConstraint.priority = .defaultHigh
        ratingViewLeadingConstraint.isActive = true

        let ratingViewTrailingConstraint: NSLayoutConstraint = ratingView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -paddingRatingTrailing)
        ratingViewTrailingConstraint.priority = .defaultLow
        ratingViewTrailingConstraint.isActive = true

        NSLayoutConstraint.activate([
            // Rating Label
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: paddingLabelLeading),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: paddingLabelTopBottom),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -paddingLabelTopBottom),
            // Rating View
            ratingView.leadingAnchor.constraint(greaterThanOrEqualTo: label.trailingAnchor, constant: paddingLabelMinLeading),
            ratingView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: paddingRatingTopBottom),
            ratingView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -paddingLabelTopBottom)
        ])
    }
}
