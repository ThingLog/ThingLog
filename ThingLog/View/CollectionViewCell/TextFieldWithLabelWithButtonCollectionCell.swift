//
//  TextFieldWithLabelWithButtonCollectionCell.swift
//  ThingLog
//
//  Created by hyunsu on 2021/10/19.
//

import RxSwift
import UIKit

/// 왼쪽에 텍스트필드를 가지며, 오른쪽에는 텍스트의 개수를 카운팅 하는 Label과, clear버튼이 있는 CollectionViewCell이다.
/// [이미지](https://www.notion.so/TextFieldWithLabelWithButtonCollectionCell-a6fdcf9396044ee3a58daf5a669192a5)
final class TextFieldWithLabelWithButtonCollectionCell: UICollectionViewCell {
    let textField: DisableSelectionTextField = {
        let textField: DisableSelectionTextField = DisableSelectionTextField()
        textField.font = UIFont.Pretendard.body1
        textField.rightView = nil
        textField.textColor = SwiftGenColors.black.color
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return textField
    }()
    
    let countingLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.Pretendard.body2
        label.textColor = SwiftGenColors.gray3.color
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()
    
    let clearButton: UIButton = {
        let button: UIButton = UIButton()
        button.setImage(SwiftGenAssets.textdelete.image, for: .normal)
        button.setContentHuggingPriority(.required, for: .vertical)
        button.setContentCompressionResistancePriority(.required, for: .vertical)
        return button
    }()
    
    var leadingEmptyView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentHuggingPriority(.required, for: .horizontal)
        return view
    }()
    
    var trailingEmptyView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentHuggingPriority(.required, for: .horizontal)
        return view
    }()
    
    var widthEmptyView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentHuggingPriority(.required, for: .horizontal)
        return view
    }()
    
    lazy var countingLabelWithClearButtonStackView: UIStackView = {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [
                                                    countingLabel,
                                                    widthEmptyView,
                                                    clearButton])
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.setContentHuggingPriority(.required, for: .horizontal)
        stackView.setContentCompressionResistancePriority(.required, for: .horizontal)
        return stackView
    }()
    
    lazy var stackView: UIStackView = {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [
                                                    leadingEmptyView,
                                                    textField,
                                                    countingLabelWithClearButtonStackView,
                                                    trailingEmptyView])
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.setContentHuggingPriority(.defaultLow, for: .vertical)
        return stackView
    }()
    
    var bottomBorderLineView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = SwiftGenColors.gray3.color
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentHuggingPriority(.required, for: .vertical)
        return view
    }()
    
    /// 키보드 상단 툴바에 위치하는 확인 버튼이다.
    let toolBarCheckButton: UIButton = {
        let button: UIButton = UIButton()
        button.titleLabel?.font = UIFont.Pretendard.title2
        button.setTitle("확인", for: .normal)
        button.setTitleColor(SwiftGenColors.systemBlue.color, for: .normal)
        return button
    }()
    
    private let paddingConstraint: CGFloat = 20.0
    var disposeBag: DisposeBag = DisposeBag()
    var maxTextCount: Int = 20
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not beem implemented")
    }

    private func setupView() {
        backgroundColor = SwiftGenColors.white.color
        contentView.addSubview(stackView)
        contentView.addSubview(bottomBorderLineView)
        NSLayoutConstraint.activate([
            bottomBorderLineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: paddingConstraint),
            bottomBorderLineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -paddingConstraint),
            bottomBorderLineView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            bottomBorderLineView.heightAnchor.constraint(equalToConstant: 0.5),
            
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomBorderLineView.topAnchor),
            
            leadingEmptyView.widthAnchor.constraint(equalToConstant: paddingConstraint),
            trailingEmptyView.widthAnchor.constraint(equalToConstant: paddingConstraint),
            
            countingLabelWithClearButtonStackView.widthAnchor.constraint(equalToConstant: 65),
            
            widthEmptyView.widthAnchor.constraint(greaterThanOrEqualToConstant: 0)
        ])
        textField.delegate = self
        setupToolBar()
        hideCountingLabelAndClearButton(true)
        setupKeyboardClosure()
    }
 
    private func setupToolBar() {
        let keyboardToolBar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        keyboardToolBar.barStyle = .default
        toolBarCheckButton.addTarget(self, action: #selector(cancleKeyboard), for: .touchUpInside)
        let cancleBarButton: UIBarButtonItem = UIBarButtonItem(customView: toolBarCheckButton)
        cancleBarButton.tintColor = SwiftGenColors.black.color
        keyboardToolBar.barTintColor = SwiftGenColors.gray6.color
        keyboardToolBar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), cancleBarButton]
        keyboardToolBar.sizeToFit()
        textField.inputAccessoryView = keyboardToolBar
    }
    
    /// 키보드에 반응이 있거나 없을 때 필요한 로직을 추가한다.
    private func setupKeyboardClosure() {
        textField.becomeFirstResponderCompletion = { [weak self] in
            self?.hideCountingLabelAndClearButton(self?.textField.text?.isEmpty ?? true)
        }
        
        textField.resignFirstResponderCompletion = { [weak self] in
            self?.hideCountingLabelAndClearButton(true)
        }
    }
    
    @objc
    private func cancleKeyboard() {
        textField.endEditing(true)
    }
}

extension TextFieldWithLabelWithButtonCollectionCell {
    /// placeholder를 설정하는 메서드다
    /// - Parameter text: placeholder에 들어갈 문구를 지정한다.
    func setupPlaceholder(text: String) {
        textField.attributedPlaceholder = NSAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor: SwiftGenColors.gray4.color])
    }
    
    /// 최대 textField 맥시멈을 설정한다.
    /// - Parameter count: 맥시멈 숫자를 지정한다.
    func setupMaxTextCount(_ count: Int) {
        maxTextCount = count
    }
    
    /// 우측 숫자세는 레이블과 삭제버튼을 숨기거나 나타낸다.
    /// - Parameter bool: 숨기고자 할때는 true, 그렇지 않다면 false를 지정한다.
    func hideCountingLabelAndClearButton(_ bool: Bool) {
        countingLabel.isHidden = bool
        clearButton.isHidden = bool
    }
}

extension TextFieldWithLabelWithButtonCollectionCell: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        // textField의 text를 최대 maxTextCount 개수까지만 보여주도록 한다.
        var counting: Int = textField.text?.count ?? 0
        if counting > maxTextCount {
            textField.text = Array((textField.text ?? "").map { String($0) }[0..<maxTextCount]).joined()
            counting = maxTextCount
        }
        hideCountingLabelAndClearButton(counting == 0 )
        
        countingLabel.text = "\(counting)/\(maxTextCount)"
    }
}
