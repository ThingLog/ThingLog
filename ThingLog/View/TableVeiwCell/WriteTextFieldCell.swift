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
    private let textField: UITextField = {
        let textField: UITextField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.Pretendard.body1
        textField.textColor = SwiftGenColors.black.color
        let clearButton: UIButton = UIButton(type: .custom)
        clearButton.setImage(SwiftGenAssets.clear.image, for: .normal)
        clearButton.contentMode = .scaleAspectFit
        textField.rightView = clearButton
        textField.rightViewMode = .never
        return textField
    }()

    var placeholder: String? {
        didSet {
            textField.attributedPlaceholder = NSAttributedString(string: placeholder ?? "",
                                                                 attributes: [
                                                                    NSAttributedString.Key.foregroundColor: SwiftGenColors.gray3.color,
                                                                    NSAttributedString.Key.font: UIFont.Pretendard.body1
                                                                 ])
        }
    }

    var keyboardType: UIKeyboardType = .default {
        didSet {
            textField.keyboardType = keyboardType
        }
    }

    var text: String? { textField.text }

    private let disposeBag: DisposeBag = DisposeBag()
    private let paddingLeadingTrailing: CGFloat = 26.0
    private let paddingTopBottom: CGFloat = 20.0

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupView()
        setupBind()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WriteTextFieldCell {
    private func setupView() {
        selectionStyle = .none

        contentView.addSubview(textField)

        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: paddingLeadingTrailing),
            textField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: paddingTopBottom),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -paddingLeadingTrailing),
            textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -paddingTopBottom)
        ])

        textField.delegate = self
    }

    private func setupBind() {
        textField.rx.text.orEmpty
            .map { $0.isEmpty }
            .bind { [weak self] isEmpty in
                self?.textField.rightViewMode = isEmpty ? .never : .always
            }
            .disposed(by: disposeBag)

        (textField.rightView as? UIButton)?.rx.tap
            .bind { [weak self] _ in
                self?.clearTextField()
            }.disposed(by: disposeBag)
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

        let text: String = textField.text ?? ""
        let newString: String = (text as NSString).replacingCharacters(in: range, with: string)
        let numberWithoutCommas: String = newString.replacingOccurrences(of: ",", with: "")
        var removeCharacter: String = numberWithoutCommas.replacingOccurrences(of: " 원", with: "")
        removeCharacter = removeCharacter.trimmingCharacters(in: .whitespacesAndNewlines)

        if string.isEmpty {
            if removeCharacter.count == 1 {
                textField.text = ""
                return false
            }
            let startIndex: String.Index = removeCharacter.index(removeCharacter.startIndex, offsetBy: 0)
            let endIndex: String.Index = removeCharacter.index(removeCharacter.startIndex, offsetBy: removeCharacter.count - 2)
            let removeLast: String = String(removeCharacter[startIndex...endIndex])
            removeCharacter = removeLast
        }

        guard var number = formatter.number(from: removeCharacter) else {
            textField.text = nil
            textField.sendActions(for: .valueChanged)
            return false
        }

        // TODO: 가격의 최대 입력 값 변경
        if Int(truncating: number) > Int.max {
            number = NSNumber(value: Int.max)
        }

        var formattedString: String? = formatter.string(from: number)
        if string == "." && range.location == textField.text?.count {
            formattedString = formattedString?.appending(".")
        }
        textField.text = "\(formattedString ?? "0") 원"

        textField.sendActions(for: .valueChanged)
        return false
    } // Source: https://stackoverflow.com/questions/27308595/how-do-you-dynamically-format-a-number-to-have-commas-in-a-uitextfield-entry/50798618
}
