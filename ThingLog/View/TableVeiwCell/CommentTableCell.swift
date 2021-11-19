//
//  CommentTableCell.swift
//  ThingLog
//
//  Created by 이지원 on 2021/11/05.
//

import UIKit

import RxCocoa
import RxSwift

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

    // MARK: - Properties
    weak var delegate: TextViewCellDelegate?
    var isEditable: Bool = false {
        didSet { setEditMode() }
    }

    // MARK: - Rx
    var disposeBag: DisposeBag = DisposeBag()

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupKeyboardToolbar()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupKeyboardToolbar()
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

        textView.delegate = self
    }

    private func setupKeyboardToolbar() {
        let keyboardToolBar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        keyboardToolBar.barStyle = .default
        let cancleButton: UIButton = {
            let button: UIButton = UIButton()
            button.titleLabel?.font = UIFont.Pretendard.title2
            button.setTitle("취소", for: .normal)
            button.setTitleColor(SwiftGenColors.systemBlue.color, for: .normal)
            button.addTarget(self, action: #selector(dismissKeyboard), for: .touchUpInside)
            return button
        }()
        let cancleBarButton: UIBarButtonItem = UIBarButtonItem(customView: cancleButton)
        cancleBarButton.tintColor = SwiftGenColors.black.color
        keyboardToolBar.barTintColor = SwiftGenColors.gray6.color
        keyboardToolBar.items = [cancleBarButton, UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)]
        keyboardToolBar.sizeToFit()
        textView.inputAccessoryView = keyboardToolBar
    }

    @objc
    private func dismissKeyboard() {
        textView.resignFirstResponder()
    }

    private func setEditMode() {
        textView.isEditable = isEditable
        textView.isUserInteractionEnabled = isEditable
        isEditable ? modifyButton.setTitle("편집 완료", for: .normal) : modifyButton.setTitle("수정", for: .normal)
        isEditable ? modifyButton.setTitleColor(SwiftGenColors.systemGreen.color, for: .normal) : modifyButton.setTitleColor(SwiftGenColors.primaryBlack.color, for: .normal)
        isEditable ? deleteButton.setTitle("취소", for: .normal) : deleteButton.setTitle("삭제", for: .normal)
    }
}

// MARK: - Delegate
extension CommentTableCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if let delegate: TextViewCellDelegate = delegate {
            delegate.updateTextViewHeight()
        }
    }
}
