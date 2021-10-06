//
//  SearchTextField.swift
//  ThingLog
//
//  Created by hyunsu on 2021/10/02.
//

import UIKit

/* 구조
 textFieldView: UIView  {
    iconTextFiedStackView: UIStackView  {
        [ searchIcon, textField ]
    }
 }
 
 CustomTextField: UIView  {
    stackView: UIStackView  {
        [ backButton, textFieldView ]
    }
 }
 
 */

/// CustomTextField의 TextField Delagete이다.
protocol SearchTextFieldDelegate: AnyObject {
    func searchTextFieldDidChangeSelection(_ textField: UITextField)
    func searchTextFieldShouldReturn(_ textField: UITextField) -> Bool
}

/// TextField 와 backbutton을 담고있는 View다.
final class SearchTextField: UIView {
    // MARK: - View
    var backButton: TemplateImageButton = {
        let button: TemplateImageButton = TemplateImageButton(swiftGenImage: SwiftGenAssets.back.image)
        button.setTitleColor(SwiftGenColors.black.color, for: .normal)
        button.titleLabel?.font = UIFont.Pretendard.body1
        button.setTitle(nil, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.setContentCompressionResistancePriority(.required, for: .horizontal)
        return button
    }()
    
    private var textFieldView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = SwiftGenColors.gray6.color
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return view
    }()
    
    private let searchIcon: UIImageView = {
        let imageView: UIImageView = UIImageView()
        let image: UIImage? = SwiftGenAssets.search.image.withRenderingMode(.alwaysTemplate)
        imageView.image = image
        imageView.tintColor = SwiftGenColors.gray3.color
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        return imageView
    }()
    
    private var textField: UITextField = {
        let textField: UITextField = UITextField()
        textField.backgroundColor = .clear
        textField.font = UIFont.Pretendard.body2
        textField.attributedPlaceholder = NSAttributedString(string: "검색어를 입력하세요", attributes: [NSAttributedString.Key.foregroundColor: SwiftGenColors.gray3.color])
        textField.textColor = SwiftGenColors.gray3.color
        textField.clearButtonMode = .whileEditing
        if let button: UIButton = textField.value(forKey: "clearButton") as? UIButton {
            button.tintColor = SwiftGenColors.gray3.color
        }
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var iconTextFiedStackView: UIStackView = {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [searchIcon, textField])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [backButton, textFieldView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.spacing = 8
        return stackView
    }()
    
    // MARK: - Properties
    private let backImage: UIImage? = SwiftGenAssets.back.image.withRenderingMode(.alwaysTemplate)
    private let iconHeight: CGFloat = 20
    private let textFieldViewLeading: CGFloat = 10
    private let textFieldViewTrialing: CGFloat = -19
    private let navigationBarLeading: CGFloat = 22
    private let navigationBarTrailing: CGFloat = -16
    private let textFieldHeightOnNavigationBar: CGFloat = 40
    private var isOnNavigationbar: Bool = false
    
    weak var delegate: SearchTextFieldDelegate?
    
    // MARK: - Init
    /// 해당 뷰를 초기화하는 메서드다.
    /// - Parameter isOnNavigationbar: 만약 해당 뷰가 네비게이션바에 속한다면 true를, 그렇지 않다면 false를 주입한다.
    init(isOnNavigationbar: Bool) {
        self.isOnNavigationbar = isOnNavigationbar
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 네비게이션바 일 경우에만 Constriant를 추가로 수정한다.
        if isOnNavigationbar == false { return }
        guard let superView: UIView = superview else { return }
        
        NSLayoutConstraint.activate([
            centerYAnchor.constraint(equalTo: superView.centerYAnchor),
            heightAnchor.constraint(equalToConstant: textFieldHeightOnNavigationBar),
            leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: navigationBarLeading),
            trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: navigationBarTrailing)
        ])
        textFieldView.layer.cornerRadius = bounds.height / 2
    }
    
    func changeTextField(by text: String) {
        textField.text = text
    }
}

extension SearchTextField {
    private func setupView() {
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            backButton.widthAnchor.constraint(equalToConstant: 28)
        ])
        
        setupTextFieldView()
        setupTextField()
        setupToolBar()
    }
    
    // textField와 searchIcon을 담은 iConTextFieldStackView를 TextFieldView에 추가한다.
    private func setupTextFieldView() {
        textFieldView.addSubview(iconTextFiedStackView)
        
        NSLayoutConstraint.activate([
            iconTextFiedStackView.leadingAnchor.constraint(equalTo: textFieldView.leadingAnchor, constant: textFieldViewLeading),
            iconTextFiedStackView.trailingAnchor.constraint(equalTo: textFieldView.trailingAnchor, constant: textFieldViewTrialing),
            iconTextFiedStackView.topAnchor.constraint(equalTo: textFieldView.topAnchor),
            iconTextFiedStackView.bottomAnchor.constraint(equalTo: textFieldView.bottomAnchor),
            
            searchIcon.heightAnchor.constraint(equalToConstant: iconHeight),
            searchIcon.widthAnchor.constraint(equalTo: searchIcon.heightAnchor)
        ])
    }
    
    func setupToolBar() {
        let numberToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        numberToolbar.barStyle = .default
        let action: UIBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancleKeyboard))
        action.tintColor = SwiftGenColors.black.color
        numberToolbar.barTintColor = SwiftGenColors.gray6.color
        numberToolbar.items = [action]
        numberToolbar.sizeToFit()
        textField.inputAccessoryView = numberToolbar
    }
    
    @objc
    private func cancleKeyboard() {
        textField.endEditing(true)
    }
    
    private func setupTextField() {
        textField.delegate = self
    }
}

extension SearchTextField: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        delegate?.searchTextFieldDidChangeSelection(textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return delegate?.searchTextFieldShouldReturn(textField) ?? true
    }
}
