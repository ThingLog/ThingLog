//
//  TextViewWithSideButtonsView.swift
//  ThingLog
//
//  Created by 이지원 on 2021/11/13.
//

import UIKit

import RxCocoa
import RxSwift

/// [버튼, 텍스트 뷰, 버튼] 형태의 뷰
/// [이미지](https://www.notion.so/TextFieldWithSideButtonsView-b49640be11914396970a35f1f3561d68)
final class TextViewWithSideButtonsView: UIView {
    // MARK: View Properties
    private let topLineView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = SwiftGenColors.gray4.color
        return view
    }()

    private let leftButton: UIButton = {
        let button: UIButton = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("취소", for: .normal)
        button.titleLabel?.font = UIFont.Pretendard.body2
        button.setTitleColor(SwiftGenColors.primaryBlack.color, for: .normal)
        button.setContentHuggingPriority(.required, for: .horizontal)
        return button
    }()

    private let textView: UITextView = {
        let textView: UITextView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.font = UIFont.Pretendard.body1
        textView.textColor = SwiftGenColors.gray2.color
        textView.text = "댓글로 경험을 추가하세요!"
        textView.textContainer.lineFragmentPadding = .zero
        textView.textContainerInset = .zero
        textView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return textView
    }()

    private let rightButton: UIButton = {
        let button: UIButton = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("확인", for: .normal)
        button.titleLabel?.font = UIFont.Pretendard.body2
        button.setTitleColor(SwiftGenColors.gray2.color, for: .disabled)
        button.setTitleColor(SwiftGenColors.systemBlue.color, for: .normal)
        button.isEnabled = false
        button.setContentHuggingPriority(.required, for: .horizontal)
        return button
    }()

    // MARK: - Properties
    private let placeholder: String = "댓글로 경험을 추가하세요!"
    private let textViewMaximumNumberOfLines: Int = 3
    private let leadingTrailingSpacing: CGFloat = 20.0
    private let topBottomSpacing: CGFloat = 12.0
    private let disposeBag: DisposeBag = DisposeBag()
    private var textViewHeightConstraint: NSLayoutConstraint?

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
        setupBinding()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        setupView()
        setupBinding()
    }

    private func setupView() {
        backgroundColor = SwiftGenColors.white.color
        let stackView: UIStackView = {
            let stackView: UIStackView = UIStackView(arrangedSubviews: [leftButton, textView, rightButton])
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.spacing = 12.0
            stackView.alignment = .lastBaseline
            return stackView
        }()

        addSubviews(topLineView, stackView)

        textViewHeightConstraint = textView.heightAnchor.constraint(equalToConstant: UIFont.Pretendard.body1.lineHeight)
        textViewHeightConstraint?.isActive = true

        NSLayoutConstraint.activate([
            topLineView.leadingAnchor.constraint(equalTo: leadingAnchor),
            topLineView.topAnchor.constraint(equalTo: topAnchor),
            topLineView.trailingAnchor.constraint(equalTo: trailingAnchor),
            topLineView.heightAnchor.constraint(equalToConstant: 0.5),

            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leadingTrailingSpacing),
            stackView.topAnchor.constraint(equalTo: topLineView.bottomAnchor, constant: topBottomSpacing),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -leadingTrailingSpacing),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -topBottomSpacing)
        ])

        textView.delegate = self
    }

    private func setupBinding() {
        bindLeftButton()
        bindRightButton()
    }

    /// leftButton을 탭하면 텍스트 뷰의 모든 텍스트를 지우고, 키보드를 내린다.
    private func bindLeftButton() {
        leftButton.rx.tap
            .bind { [weak self] in
                self?.textViewHeightConstraint?.constant = UIFont.Pretendard.body1.lineHeight
                self?.setupPlaceholder()
                self?.textView.resignFirstResponder()
            }.disposed(by: disposeBag)
    }

    /// 텍스트 뷰가 placeholder를 표시하고 있지 않고 && 텍스트 뷰가 비어있지 않는 경우에 `rightButton`을 활성화 시킨다.
    private func bindRightButton() {
        textView.rx.text.orEmpty
            .map { $0 != self.placeholder }
            .bind { [weak self] isPlaceholder in
                guard let self = self else { return }
                self.rightButton.isEnabled = isPlaceholder && !self.textView.text.isEmpty
            }.disposed(by: disposeBag)
    }

    /// 텍스트 뷰의 placholder를 세팅한다.
    private func setupPlaceholder() {
        textView.text = placeholder
        textView.textColor = SwiftGenColors.gray2.color
    }
}

// MARK: - UITextView Delegate
/// TextView Placeholder 구현
extension TextViewWithSideButtonsView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == SwiftGenColors.gray2.color {
            textView.text = nil
            textView.textColor = SwiftGenColors.black.color
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            setupPlaceholder()
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        let lineHeight: CGFloat = textView.font?.lineHeight ?? 1
        let linesCount: Int = Int(textView.contentSize.height / lineHeight)
        let size: CGSize = CGSize(width: textView.frame.size.width, height: .infinity)
        let estimatedSize: CGSize = textView.sizeThatFits(size)

        guard linesCount < textViewMaximumNumberOfLines else {
            textView.isScrollEnabled = true
            return
        }

        textView.isScrollEnabled = false
        textViewHeightConstraint?.constant = estimatedSize.height
    }
}
