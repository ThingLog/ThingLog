//
//  WriteTextFieldCell.swift
//  ThingLog
//
//  Created by 이지원 on 2021/10/11.
//

import UIKit

import RxCocoa
import RxSwift

/// 글쓰기 화면에서 `물건 이름`, `가격` 등을 입력할 때 사용하는 셀
final class WriteTextFieldCell: UITableViewCell {
    private let textField: DisableSelectionTextField = {
        let textField: DisableSelectionTextField = DisableSelectionTextField(isSelection: true)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.Pretendard.body1
        textField.textColor = SwiftGenColors.primaryBlack.color
        let clearButton: UIButton = UIButton(type: .custom)
        clearButton.setImage(SwiftGenAssets.clear.image.withTintColor(SwiftGenColors.primaryBlack.color), for: .normal)
        clearButton.contentMode = .scaleAspectFit
        textField.rightView = clearButton
        textField.rightViewMode = .never
        return textField
    }()

    var isEditingSubject: PublishSubject<Bool> = PublishSubject<Bool>()
    var textValueSubject: PublishSubject<String?> = PublishSubject<String?>()

    private(set) var disposeBag: DisposeBag = DisposeBag()
    private let paddingLeadingTrailing: CGFloat = 26.0
    private let paddingTopBottom: CGFloat = 20.0

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        setupBind()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupView()
        setupToolbar()
        setupBind()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// 텍스트 필드의 키보드 타입과 플레이스 홀더를 구성한다.
    func configure(keyboardType: UIKeyboardType, placeholder: String) {
        textField.keyboardType = keyboardType
        textField.isSelection = keyboardType == .numberPad ? false : true
        textField.attributedPlaceholder = NSAttributedString(string: placeholder ?? "",
                                                             attributes: [
                                                                NSAttributedString.Key.foregroundColor: SwiftGenColors.gray3.color,
                                                                NSAttributedString.Key.font: UIFont.Pretendard.body1
                                                             ])
    }
}

extension WriteTextFieldCell {
    private func setupView() {
        selectionStyle = .none
        contentView.backgroundColor = SwiftGenColors.primaryBackground.color
        contentView.addSubview(textField)

        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: paddingLeadingTrailing),
            textField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: paddingTopBottom),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -paddingLeadingTrailing),
            textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -paddingTopBottom)
        ])

        textField.delegate = self
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
        textField.inputAccessoryView = keyboardToolBar
    }

    private func setupBind() {
        textField.rx.text.orEmpty
            .map { $0.isEmpty }
            .bind { [weak self] isEmpty in
                self?.textField.rightViewMode = isEmpty ? .never : .always
            }.disposed(by: disposeBag)

        (textField.rightView as? UIButton)?.rx.tap
            .bind { [weak self] _ in
                self?.clearTextField()
            }.disposed(by: disposeBag)

        textField.rx.controlEvent([.editingDidBegin, .touchUpInside])
            .bind { [weak self] _ in
                self?.isEditingSubject.onNext(true)
            }.disposed(by: disposeBag)

        textField.rx.controlEvent(.editingDidEnd)
            .bind { [weak self] _ in
                self?.textField.rightViewMode = .never
            }.disposed(by: disposeBag)

        textField.rx.controlEvent([.editingDidBegin, .editingChanged, .valueChanged])
            .withLatestFrom(textField.rx.text.orEmpty)
            .map { $0.isEmpty }
            .bind { [weak self] isEmpty in
                self?.textField.rightViewMode = isEmpty ? .never : .always
                self?.textValueSubject.onNext(self?.textField.text)
            }
            .disposed(by: disposeBag)
    }

    @objc
    private func dismissKeyboard() {
        _ = textField.resignFirstResponder()
    }

    @objc
    private func clearTextField() {
        textField.text = ""
        textField.sendActions(for: .valueChanged)
    }
}

extension WriteTextFieldCell: UITextFieldDelegate {
    /// textField.keyboardType == .numberPad 일 때 세 자리 단위마다 , 를 붙여 반환한다.
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.keyboardType != .numberPad { return true }

        let formatter: NumberFormatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0

        // 문자열 전처리
        let text: String = textField.text ?? ""
        let newString: String = (text as NSString).replacingCharacters(in: range, with: string)
        let numberWithoutCommas: String = newString.replacingOccurrences(of: ",", with: "")
        var removeCharacter: String = numberWithoutCommas.replacingOccurrences(of: " 원", with: "")
        removeCharacter = removeCharacter.trimmingCharacters(in: .whitespacesAndNewlines)

        // 백스페이스가 입력되는 경우 처리
        if string.isEmpty {
            if removeCharacter.count == 1 {
                textField.text = ""
                textField.sendActions(for: .valueChanged)
                return false
            }
            let startIndex: String.Index = removeCharacter.index(removeCharacter.startIndex, offsetBy: 0)
            let endIndex: String.Index = removeCharacter.index(removeCharacter.startIndex, offsetBy: removeCharacter.count - 2)
            let removeLast: String = String(removeCharacter[startIndex...endIndex])
            removeCharacter = removeLast
        }

        // 숫자가 아닌 문자열이 들어온 경우 textField를 비운다.
        guard var number: NSNumber = formatter.number(from: removeCharacter) else {
            textField.text = nil
            textField.sendActions(for: .valueChanged)
            return false
        }

        // 입력 값이 999_999_999 보다 큰 경우 999_999_999로 변경
        if Int(truncating: number) > 999_999_999 {
            number = NSNumber(value: 999_999_999)
        }

        // 3자리마다 , 삽입
        var formattedString: String? = formatter.string(from: number)
        if string == "." && range.location == textField.text?.count {
            formattedString = formattedString?.appending(".")
        }
        textField.text = "\(formattedString ?? "0") 원"

        textField.sendActions(for: .valueChanged)
        return false
    } // Source: https://stackoverflow.com/questions/27308595/how-do-you-dynamically-format-a-number-to-have-commas-in-a-uitextfield-entry/50798618
}
