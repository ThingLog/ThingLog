//
//  AlertViewController.swift
//  ThingLog
//
//  Created by hyunsu on 2021/10/21.
//
import RxSwift
import UIKit

/// 커스텀 Alert 화면을 보여주는 뷰 컨트롤러다. 기본적으로 상단에는 `제목`, `내용`, `텍스트필드` 가 포함되어있고, 하단에는 양 쪽에 `두개의 버튼`이 존재한다. 그러므로 특정 뷰를 포함하고 싶지 않다면 `hide**()` 메서드를 이용하여 숨기도록 한다.[이미지](https://www.notion.so/AlertViewController-29eded0049c5427198b6f96b94295cdb)
///
/// ```swift
/// // 얼럿 화면 띄우는 방법 - ⚠️animation은 false로 한다.
/// let alert = AlertViewController()
/// alert.modalPresentationStyle = .overFullScreen
/// present(alert, animated: false, completion: nil)
///
/// // 얼럿 dismiss 하는 방법 - ⚠️ animation은 false로 한다.
/// alert.leftButton.rx.tap.bind {
///     alert.dismiss(animated: false, completion: nil)
/// }
///
/// // 내용과 하나의 버튼만 보여주고 싶은 경우
/// alert.hideTitleLabel()
/// alert.hideRightButton() // ⚠️ 이 경우에 alert.leftButton만 이용하도록 한다.
/// alert.hideTextField()
///
/// // 내용과 두개의 버튼 모두 보여주고 싶은 경우
/// alert.hideTitleLabel()
/// alert.hideTextField()
///
/// // 제목과 텍스트필드, 두 개의 버튼 보여주고 싶은 경우
/// alert.hideContentsLabel()
///
/// // ⚠️ 내용의 텍스트를 변경하고 싶은 경우
/// alert.changeContentsText("이미지는 최대 10개까지 첨부할 수 있어요")
///
/// // 그외, 버튼의 타이틀, 제목의 타이틀은 직접 프로퍼티에 접근하여 변경한다.
/// alert.titleLabel.text = "카테고리 수정"
/// alert.leftButton.setTitle("취소", for: .normal)
/// alert.leftButton.setTitle("확인", for: .normal)
/// 
/// // 버튼의 액션은 직접 외부에서 바인딩하도록 한다.
/// alert.leftButton.rx.tap.bind {
///     alert.dismiss(animated: false, completion: nil)
/// }
/// ```

final class AlertViewController: UIViewController {
    // MARK: - Public View
    
    /// 상단의 강조된 문구를 포함하는 Label이다.
    let titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.numberOfLines = 0
        label.text = "카테고리 항목"
        label.font = UIFont.Pretendard.title2
        label.textAlignment = .center
        return label
    }()
    
    /// 중간에 내용을 포함하는 label이다.
    let contentsLabel: UILabel = {
        let label: UILabel = UILabel()
        label.numberOfLines = 0
        label.text = "정말 삭제하시겠어요? \n이 동작은 취소할 수 없습니다"
        label.font = UIFont.Pretendard.body1
        label.textAlignment = .center
        return label
    }()
    
    /// 좌측에 있는 강조되어 있는 button이다.
    let leftButton: UIButton = {
        let button: UIButton = UIButton()
        button.titleLabel?.font = UIFont.Pretendard.title1
        button.setTitle("취소", for: .normal)
        return button
    }()
    /// 우측에 강조되어 있지 않은 button이다.
    let rightButton: UIButton = {
        let button: UIButton = UIButton()
        button.titleLabel?.font = UIFont.Pretendard.body1
        button.setTitle("삭제", for: .normal)
        return button
    }()
    
    /// 입력을 받을 수 있는 텍스트필드다.
    let textField: UITextField = {
        let textField: UITextField = UITextField()
        textField.layer.borderWidth = 0.5
        textField.font = UIFont.Pretendard.body1
        textField.translatesAutoresizingMaskIntoConstraints = false
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 5))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        return textField
    }()
    
    // MARK: - Private View
    private let borderLineBetweenButton: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let borderLineOnButton: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let topContentsPaddingView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let bottomContentsPaddingView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let topPaddingViewOnTextField: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let leadingContentsPaddingView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let trailingContentsPaddingView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [
                                                    leftButton,
                                                    borderLineBetweenButton,
                                                    rightButton])
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var contentStackView: UIStackView = {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [
                                                    topContentsPaddingView,
                                                    titleLabel,
                                                    contentsLabel,
                                                    topPaddingViewOnTextField,
                                                    textField,
                                                    bottomContentsPaddingView])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var contentPaddingStackView: UIStackView = {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [
                                                    leadingContentsPaddingView,
                                                    contentStackView,
                                                    trailingContentsPaddingView])
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var stackView: UIStackView = {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [
                                                    contentPaddingStackView,
                                                    borderLineOnButton,
                                                    buttonStackView])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var alertView: UIView = {
        var view: UIView = UIView()
        view.layer.cornerRadius = 15
        view.backgroundColor = SwiftGenColors.white.color
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Properties
    private let contentsHeight: CGFloat = 94
    private let alertViewWidth: CGFloat = 270
    private let buttonStackViewHeight: CGFloat = 52
    private let paddingHeight: CGFloat = 14
    private let paddingWidth: CGFloat = 20
    private let textFieldHeight: CGFloat = 26
    
    var disposeBag: DisposeBag = DisposeBag()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.layoutIfNeeded()
        
        // 키보드 옵저빙
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        subscribeTextFieldReturnKey()
        setupAlertView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 나타날 때 애니메이션을 추가한다.
        UIView.animate(withDuration: 0.3) {
            self.view.backgroundColor = .black.withAlphaComponent(0.5)
        }
        
        UIView.animate(withDuration: 0.05, delay: 0) {
            self.alertView.transform = CGAffineTransform(scaleX: 1.07, y: 1.07)
        } completion: { _  in
            UIView.animate(withDuration: 0.15) {
                self.setBackgroundColorTint()
                self.alertView.transform = .identity
                UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
            }
        }
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        // 사라질 때 애니메이션을 추가한다.
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut) {
            self.setBackgroundColorClear()
            self.view.backgroundColor = .clear
            self.view.layoutIfNeeded()
        } completion: { _ in
            super.dismiss(animated: flag, completion: completion)
        }
    }
    
    private func setupAlertView() {
        view.addSubview(alertView)
        setBackgroundColorClear()
        alertView.addSubview(stackView)
        textField.layer.cornerRadius = textFieldHeight / 2
        NSLayoutConstraint.activate([
            alertView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            alertView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            alertView.widthAnchor.constraint(equalToConstant: alertViewWidth),
            
            stackView.leadingAnchor.constraint(equalTo: alertView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: alertView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: alertView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: alertView.bottomAnchor),
            
            buttonStackView.heightAnchor.constraint(equalToConstant: buttonStackViewHeight),
            borderLineOnButton.heightAnchor.constraint(equalToConstant: 0.5),
            borderLineBetweenButton.widthAnchor.constraint(equalToConstant: 0.5),
            
            leftButton.widthAnchor.constraint(equalTo: rightButton.widthAnchor),
            
            bottomContentsPaddingView.heightAnchor.constraint(greaterThanOrEqualToConstant: paddingHeight),
            topContentsPaddingView.heightAnchor.constraint(greaterThanOrEqualToConstant: paddingHeight),
            bottomContentsPaddingView.heightAnchor.constraint(equalTo: topContentsPaddingView.heightAnchor),
            
            leadingContentsPaddingView.widthAnchor.constraint(equalToConstant: paddingWidth),
            trailingContentsPaddingView.widthAnchor.constraint(equalToConstant: paddingWidth),
            topPaddingViewOnTextField.heightAnchor.constraint(equalToConstant: paddingHeight),
            
            contentStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: contentsHeight),
            textField.heightAnchor.constraint(equalToConstant: textFieldHeight)
        ])
    }
}

// MARK: - Public Method
extension AlertViewController {
    func hideTextField() {
        textField.isHidden = true
        topPaddingViewOnTextField.isHidden = true
    }
    
    func hideContentsLabel() {
        contentsLabel.isHidden = true
    }
    
    /// 상단의 제목 lable을 숨긴다.
    func hideTitleLabel() {
        titleLabel.isHidden = true
    }
    
    /// 하나의 버튼만 사용하고자 할 때 우측 버튼을 숨긴다.
    func hideRightButton() {
        rightButton.isHidden = true
        borderLineBetweenButton.isHidden = true
    }
    
    /// contents의 텍스트를 변경한다. 줄바꿈이 되는 경우에 `간격을 조정`하는 로직이 추가됐다.
    func changeContentsText(_ text: String) {
        contentsLabel.numberOfLines = 0
        let attrString: NSMutableAttributedString = NSMutableAttributedString(string: text)
        let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        paragraphStyle.alignment = .center
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle,
                                value: paragraphStyle,
                                range: NSRange(location: 0, length: attrString.length))
        contentsLabel.attributedText = attrString
    }
}

// MARK: - Private Method
extension AlertViewController {
    private func subscribeTextFieldReturnKey() {
        textField.rx.controlEvent(.editingDidEndOnExit)
            .bind { [weak self] in
                self?.textField.resignFirstResponder()
            }
            .disposed(by: disposeBag)
    }
    
    @objc
    private func keyboardWillAppear(_ notification: NSNotification) {
        if let keyboardSize: CGRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.3) {
                self.alertView.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height / 2)
            }
        }
    }
    
    @objc
    private func keyboardWillHide(_ notification: NSNotification) {
        alertView.transform = .identity
    }
    
    private func setBackgroundColorClear() {
        alertView.backgroundColor = SwiftGenColors.white.color.withAlphaComponent(0)
        titleLabel.textColor = SwiftGenColors.black.color.withAlphaComponent(0)
        contentsLabel.textColor = SwiftGenColors.black.color.withAlphaComponent(0)
        
        textField.layer.borderColor = SwiftGenColors.gray4.color.withAlphaComponent(0).cgColor
        textField.textColor = SwiftGenColors.black.color.withAlphaComponent(0)
        
        leftButton.setTitleColor(SwiftGenColors.black.color.withAlphaComponent(0), for: .normal)
        rightButton.setTitleColor(SwiftGenColors.black.color.withAlphaComponent(0), for: .normal)
        
        borderLineBetweenButton.backgroundColor = SwiftGenColors.gray4.color.withAlphaComponent(0)
        borderLineOnButton.backgroundColor = SwiftGenColors.gray4.color.withAlphaComponent(0)
    }
    
    private func setBackgroundColorTint() {
        alertView.backgroundColor = SwiftGenColors.primaryBackground.color
        titleLabel.textColor = SwiftGenColors.primaryBlack.color
        contentsLabel.textColor = SwiftGenColors.primaryBlack.color
        
        textField.layer.borderColor = SwiftGenColors.primaryBlack.color.cgColor
        textField.textColor = SwiftGenColors.primaryBlack.color
        
        leftButton.setTitleColor(SwiftGenColors.primaryBlack.color, for: .normal)
        rightButton.setTitleColor(SwiftGenColors.primaryBlack.color, for: .normal)
        
        borderLineBetweenButton.backgroundColor = SwiftGenColors.gray4.color
        borderLineOnButton.backgroundColor = SwiftGenColors.gray4.color
    }
}
