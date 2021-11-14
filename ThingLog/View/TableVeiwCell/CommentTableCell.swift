//
//  CommentTableCell.swift
//  ThingLog
//
//  Created by 이지원 on 2021/11/05.
//

import UIKit

/// 댓글 화면에서 댓글을 표시할 때 사용하는 컬렉션뷰 셀
/// [이미지](https://www.notion.so/CommentTableCell-79a4165aa5804c5e86875368b8d53705)
final class CommentTableCell: UITableViewCell {
    // MARK: - View Properties
    private let topLineView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = SwiftGenColors.gray4.color
        return view
    }()

    let dateLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "2021년 09월 27일"
        label.textColor = SwiftGenColors.gray2.color
        label.font = UIFont.Pretendard.body2
        return label
    }()

    private lazy var actionButtonStackView: UIStackView = {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [modifyButton, deleteButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 12
        return stackView
    }()

    let modifyButton: UIButton = {
        let button: UIButton = UIButton()
        button.setTitle("수정", for: .normal)
        button.setTitleColor(SwiftGenColors.primaryBlack.color, for: .normal)
        button.titleLabel?.font = UIFont.Pretendard.body2
        button.sizeToFit()
        return button
    }()

    let deleteButton: UIButton = {
        let button: UIButton = UIButton()
        button.setTitle("삭제", for: .normal)
        button.setTitleColor(SwiftGenColors.systemRed.color, for: .normal)
        button.titleLabel?.font = UIFont.Pretendard.body2
        button.sizeToFit()
        return button
    }()

    private let emptyView: UIView = {
        let view: UIView = UIView()
        view.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return view
    }()

    let textView: UITextView = {
        let textView: UITextView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.font = UIFont.Pretendard.body1
        textView.text = """
        Complaint that PorchCam can't pick up voices ssssssssccccc  speech when there's a loud
        """
        textView.textContainer.lineFragmentPadding = .zero
        textView.textContainerInset = .zero
        textView.backgroundColor = .clear
        textView.sizeToFit()
        return textView
    }()

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    // MARK: - Setup
    private func setupView() {
        backgroundColor = .clear
        let leadingTrailingSpacing: CGFloat = 20.0
        let topBottomSpacing: CGFloat = 14.0

        let headerStackView: UIStackView = {
            let stackView: UIStackView = UIStackView(arrangedSubviews: [dateLabel, emptyView, actionButtonStackView])
            stackView.translatesAutoresizingMaskIntoConstraints = false
            return stackView
        }()

        contentView.addSubviews(topLineView, headerStackView, textView)

        NSLayoutConstraint.activate([
            topLineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            topLineView.topAnchor.constraint(equalTo: contentView.topAnchor),
            topLineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            topLineView.heightAnchor.constraint(equalToConstant: 0.5),

            headerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: leadingTrailingSpacing),
            headerStackView.topAnchor.constraint(equalTo: topLineView.bottomAnchor, constant: topBottomSpacing),
            headerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -leadingTrailingSpacing),

            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: leadingTrailingSpacing),
            textView.topAnchor.constraint(equalTo: headerStackView.bottomAnchor, constant: topBottomSpacing),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -leadingTrailingSpacing),
            textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -topBottomSpacing)
        ])
    }
}
