//
//  RoundTextWithButtonTableCell.swift
//  ThingLog
//
//  Created by 이지원 on 2021/10/13.
//
import RxSwift
import UIKit

/// 카테고리 화면에서 카테고리를 선택할 때 사용하는 셀
///
/// [이미지](https://www.notion.so/RoundLabelWithButtonTableCell-6f22273ede304c1caf3e6170dbcd3a50)
final class RoundLabelWithButtonTableCell: UITableViewCell {
    // MARK: - View Properties
    // 기존에는 PaddingLabel이였지만 수정기능을 위해 textField로 변경
    var nameLabel: UITextField = {
        let textField: UITextField = UITextField()
        textField.font = UIFont.Pretendard.body1
        textField.textColor = SwiftGenColors.primaryBlack.color
        textField.backgroundColor = SwiftGenColors.primaryBackground.color
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = SwiftGenColors.primaryBlack.color.cgColor
        
        let paddingLeadignView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 10))
            textField.leftView = paddingLeadignView
        textField.leftViewMode = .always
        let paddingTrailingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 10))
        textField.rightView = paddingTrailingView
        textField.rightViewMode = .always
        
        textField.returnKeyType = .done
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        textField.isUserInteractionEnabled = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let emptyView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return view
    }()

    private let selectedButton: UIButton = {
        let button: UIButton = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.layer.borderWidth = 1
        button.layer.borderColor = SwiftGenColors.primaryBlack.color.cgColor
        button.backgroundColor = SwiftGenColors.primaryBackground.color
        button.titleLabel?.font = UIFont.Pretendard.body3
        button.setTitleColor(SwiftGenColors.white.color, for: .normal)
        button.isUserInteractionEnabled = false
        return button
    }()
    
    // MARK: - 수정, 삭제 뷰
    let modifyButton: UIButton = {
        let button: UIButton = UIButton()
        button.titleLabel?.font = UIFont.Pretendard.body2
        button.setTitle("수정", for: .normal)
        button.setTitleColor(SwiftGenColors.primaryBlack.color, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let deleteButton: UIButton = {
        let button: UIButton = UIButton()
        button.setTitle("삭제", for: .normal)
        button.titleLabel?.font = UIFont.Pretendard.body2
        button.setTitleColor(SwiftGenColors.systemRed.color, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var modifyStackView: UIStackView = {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [modifyButton, deleteButton])
        stackView.spacing = 16
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isHidden = true
        return stackView
    }()

    // MARK: - Properties
    /// 카테고리 수정 및 삭제 기능뷰에서 텍스트필드 툴바의 취소버튼을 누를 때 발생하는 이벤트를 담는 클로저다.
    var textFieldCancleToolbarCompletion: (() -> Void)?
    var isSelectedCategory: Bool = false {
        didSet {
            selectedButton.backgroundColor = isSelectedCategory ? SwiftGenColors.primaryBlack.color : SwiftGenColors.primaryBackground.color
        }
    }
    var textFieldMaxLength: Int = 0 
    private let buttonSize: CGFloat = 24.0
    private let paddingLeadingTrailing: CGFloat = 18.0
    private let paddingTopBottom: CGFloat = 12.0
    
    var disposeBag: DisposeBag = DisposeBag()
    
    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupToolbar()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.isUserInteractionEnabled = false
        disposeBag = DisposeBag()
    }

    func configure(name: String) {
        nameLabel.text = name
    }

    func configure(selectedOrder: Int) {
        selectedButton.setTitle("\(selectedOrder)", for: .normal)
    }
    /// type에 따라, 선택 기능뷰 인지, 수정 삭제 기능 뷰인지 뷰를 세팅한다.
    func configure(type: CategoryViewController.CategoryViewType) {
        modifyStackView.isHidden = type == .select ? true : false
        selectedButton.isHidden = type == .select ? false : true
    }
}

extension RoundLabelWithButtonTableCell {
    private func setupView() {
        selectionStyle = .none

        selectedButton.layer.cornerRadius = buttonSize / 2

        let stackView: UIStackView = {
            let stackView: UIStackView = UIStackView(arrangedSubviews: [nameLabel,
                                                                        emptyView,
                                                                        selectedButton,
                                                                        modifyStackView])
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .horizontal
            return stackView
        }()

        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: paddingLeadingTrailing),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: paddingTopBottom),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -paddingLeadingTrailing),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -paddingTopBottom),
            selectedButton.widthAnchor.constraint(equalToConstant: buttonSize),
            selectedButton.heightAnchor.constraint(equalTo: selectedButton.widthAnchor),
            
            emptyView.widthAnchor.constraint(greaterThanOrEqualToConstant: 10)
        ])
    }
    
    private func setupToolbar() {
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
        nameLabel.inputAccessoryView = keyboardToolBar
        nameLabel.delegate = self
    }
    
    @objc
    private func dismissKeyboard() {
        textFieldCancleToolbarCompletion?()
    }
}

extension RoundLabelWithButtonTableCell: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        // 공백만 이루어진건 아닌지 판별하여 저장한다.
        var text: String = ""
        if let textFieldText: String = textField.text {
            if textFieldText.filter({ $0 == " " }).count == textFieldText.count {
                textField.text = ""
            } else {
                text = textFieldText
            }
        }
        
        // 최대 글자개수를 넘지않도록 저장한다.
        let counting: Int = text.count
        if counting > textFieldMaxLength {
            textField.text = Array((textField.text ?? "").map { String($0) }[0..<textFieldMaxLength]).joined()
        } else {
            textField.text = text
        }
    }
}
