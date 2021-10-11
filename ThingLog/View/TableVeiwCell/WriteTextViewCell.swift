//
//  WriteTextViewCell.swift
//  ThingLog
//
//  Created by 이지원 on 2021/10/11.
//

import UIKit

/// 글쓰기 화면에서 WriteTextViewCell의 높이를 동적으로 변경하기 위한 프로토콜
protocol WriteTextViewCellDelegate: AnyObject {
    func updateTextViewHeight(_ cell: WriteTextViewCell, _ textView: UITextView)
}

/// 글쓰기 화면에서 자유 글쓰기를 입력할 때 사용하는 셀
final class WriteTextViewCell: UITableViewCell {
    private let textView: UITextView = {
        let textView: UITextView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = true
        textView.isScrollEnabled = false
        textView.font = UIFont.Pretendard.body1
        textView.textColor = SwiftGenColors.gray4.color
        textView.text = "물건에 대한 생각이나 감정을 자유롭게 기록해보세요."
        textView.sizeToFit()
        return textView
    }()

    weak var delegate: WriteTextViewCellDelegate?
    private let paddingLeadingTrailing: CGFloat = 23.0
    private let paddingTopBottom: CGFloat = 24.0
    private let minHeight: CGFloat = 975.0

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WriteTextViewCell {
    private func setupView() {
        selectionStyle = .none

        contentView.addSubview(textView)

        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: paddingLeadingTrailing),
            textView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: paddingTopBottom),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -paddingLeadingTrailing),
            textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -paddingTopBottom),
            textView.heightAnchor.constraint(greaterThanOrEqualToConstant: minHeight)
        ])

        textView.delegate = self
    }
}

extension WriteTextViewCell: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == SwiftGenColors.gray4.color {
            textView.text = nil
            textView.textColor = SwiftGenColors.black.color
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "물건에 대한 생각이나 감정을 자유롭게 기록해보세요."
            textView.textColor = SwiftGenColors.gray4.color
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        if let delegate: WriteTextViewCellDelegate = delegate {
            delegate.updateTextViewHeight(self, textView)
        }
    }
}
