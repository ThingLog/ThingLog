//
//  WriteTextViewCell.swift
//  ThingLog
//
//  Created by 이지원 on 2021/10/11.
//

import UIKit

import RxCocoa
import RxSwift

/// 글쓰기 화면에서 WriteTextViewCell의 높이를 동적으로 변경하기 위한 프로토콜
protocol WriteTextViewCellDelegate: AnyObject {
    func updateTextViewHeight()
}

/// 글쓰기 화면에서 자유 글쓰기를 입력할 때 사용하는 셀
final class WriteTextViewCell: UITableViewCell {
    let textView: UITextView = {
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

    var isEditingSubject: PublishSubject<Bool> = PublishSubject<Bool>()
    weak var delegate: WriteTextViewCellDelegate?
    private(set) var disposeBag: DisposeBag = DisposeBag()
    private let paddingLeadingTrailing: CGFloat = 23.0
    private let paddingTopBottom: CGFloat = 24.0
    private let minHeight: CGFloat = 380.0

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupView()
        setupToolbar()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WriteTextViewCell {
    private func setupView() {
        selectionStyle = .none
        separatorInset = .zero

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

    private func setupToolbar() {
        let keyboardToolBar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        keyboardToolBar.barStyle = .default
        let successButton: UIButton = {
            let button: UIButton = UIButton()
            button.titleLabel?.font = UIFont.Pretendard.title2
            button.setTitle("완료", for: .normal)
            button.setTitleColor(SwiftGenColors.systemBlue.color, for: .normal)
            button.addTarget(self, action: #selector(dismissKeyboard), for: .touchUpInside)
            return button
        }()
        let successBarButton: UIBarButtonItem = UIBarButtonItem(customView: successButton)
        successBarButton.tintColor = SwiftGenColors.black.color
        keyboardToolBar.barTintColor = SwiftGenColors.gray6.color
        keyboardToolBar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), successBarButton]
        keyboardToolBar.sizeToFit()
        textView.inputAccessoryView = keyboardToolBar
    }

    @objc
    private func dismissKeyboard() {
        textView.resignFirstResponder()
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
            delegate.updateTextViewHeight()
        }
    }
}
