//
//  SearchTextField.swift
//  ThingLog
//
//  Created by hyunsu on 2021/10/02.
//
import RxSwift
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
        let button: TemplateImageButton = TemplateImageButton(swiftGenImage: SwiftGenIcons.longArrowR.image)
        button.setTitleColor(SwiftGenColors.primaryBlack.color, for: .normal)
        button.titleLabel?.font = UIFont.Pretendard.body1
        button.setTitle(nil, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.setContentCompressionResistancePriority(.required, for: .horizontal)
        return button
    }()
    
    private var textFieldView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 1
        view.layer.borderColor = SwiftGenColors.primaryBlack.color.cgColor
        view.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return view
    }()
    
    private let searchIcon: UIImageView = {
        let imageView: UIImageView = UIImageView()
        let image: UIImage? = SwiftGenIcons.search.image.withRenderingMode(.alwaysTemplate)
        imageView.image = image
        imageView.tintColor = SwiftGenColors.primaryBlack.color
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        return imageView
    }()
    
    private var textField: UITextField = {
        let textField: UITextField = UITextField()
        textField.backgroundColor = .clear
        textField.font = UIFont.Pretendard.body2
        textField.attributedPlaceholder = NSAttributedString(string: "검색어를 입력하세요", attributes: [NSAttributedString.Key.foregroundColor: SwiftGenColors.gray2.color])
        textField.textColor = SwiftGenColors.primaryBlack.color
        
        let clearButton: UIButton = UIButton(type: .custom)
        clearButton.setImage(SwiftGenIcons.close.image.withRenderingMode(.alwaysTemplate), for: .normal)
        clearButton.tintColor = SwiftGenColors.primaryBlack.color
        clearButton.contentMode = .scaleAspectFit
        textField.rightView = clearButton
        textField.rightViewMode = .never
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
    private let iconHeight: CGFloat = 20
    private let textFieldViewLeading: CGFloat = 10
    private let textFieldViewTrialing: CGFloat = -19
    private let navigationBarLeading: CGFloat = 22
    private let navigationBarTrailing: CGFloat = -16
    private let textFieldHeightOnNavigationBar: CGFloat = 40
    private var isOnNavigationbar: Bool = false
    
    weak var delegate: SearchTextFieldDelegate?
    
    var disposeBag: DisposeBag = DisposeBag()
    
    // MARK: - Init
    /// 해당 뷰를 초기화하는 메서드다.
    /// - Parameter isOnNavigationbar: 만약 해당 뷰가 네비게이션바에 속한다면 true를, 그렇지 않다면 false를 주입한다.
    init(isOnNavigationbar: Bool) {
        self.isOnNavigationbar = isOnNavigationbar
        super.init(frame: .zero)
        setupView()
        setupTextFieldCloseButton()
        setDarkMode()
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
    
    private func setupTextFieldCloseButton() {
        (textField.rightView as? UIButton)?.rx.tap
            .bind { [weak self] _ in
                self?.textField.text = nil
                self?.textField.rightViewMode = .never
            }.disposed(by: disposeBag)
    
        textField.rx.controlEvent(.editingDidEnd)
            .bind { [weak self] _ in
                self?.textField.rightViewMode = .never
            }.disposed(by: disposeBag)

        textField.rx.controlEvent([.editingChanged, .editingDidBegin])
            .withLatestFrom(textField.rx.text.orEmpty)
            .map { $0.isEmpty }
            .bind { [weak self] isEmpty in
                self?.textField.rightViewMode = isEmpty ? .never : .always
            }
            .disposed(by: disposeBag)
    }
    
    func setupToolBar() {
        let keyboardToolBar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        keyboardToolBar.barStyle = .default
        let correctButton: UIButton = {
            let button: UIButton = UIButton()
            button.titleLabel?.font = UIFont.Pretendard.title2
            button.setTitle("확인", for: .normal)
            button.setTitleColor(SwiftGenColors.systemBlue.color, for: .normal)
            button.addTarget(self, action: #selector(correctKeyboard), for: .touchUpInside)
            return button
        }()
        let cancleBarButton: UIBarButtonItem = UIBarButtonItem(customView: correctButton)
        keyboardToolBar.barTintColor = UIColor(red: 249, green: 249, blue: 249, alpha: 0)
        keyboardToolBar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
                                 cancleBarButton]
        keyboardToolBar.sizeToFit()
        textField.inputAccessoryView = keyboardToolBar
        
        // add top BorderLine
        let topBorder: CALayer = CALayer()
        topBorder.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0.5)
        topBorder.backgroundColor = SwiftGenColors.gray3.color.cgColor
        keyboardToolBar.layer.addSublayer(topBorder)
    }
    
    @objc
    private func correctKeyboard() {
        // return키를 호출하기 위해, SearchTextFieldShouldReturn Delegate를 호출한다.
        delegate?.searchTextFieldShouldReturn(textField)
        textField.resignFirstResponder()
    }
    
    private func setupTextField() {
        textField.delegate = self
    }
    
    /// 강제적으로 다크모드를 안하고자 할 때, textFieldView의 layer의 색이 반영되지 않는 점을 해결하기 위한 메소드. 아무래도 cgColor여서 그런것 같기도 하고...
    private func setDarkMode() {
        let userInformationViewModel: UserInformationViewModelable = UserInformationUserDefaultsViewModel()
        userInformationViewModel.fetchUserInformation { userInfor in
            guard let userInfor = userInfor else {
                return
            }
            let darkMode: Bool = userInfor.isAumatedDarkMode
            if darkMode {
                self.textFieldView.layer.borderColor = UIColor(red: 255, green: 247, blue: 237, alpha: 1).cgColor
            } else {
                self.textFieldView.layer.borderColor = UIColor.black.cgColor
            }
        }
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
