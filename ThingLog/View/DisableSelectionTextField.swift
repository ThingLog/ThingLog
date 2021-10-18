//
//  DisableSelectionTextField.swift
//  ThingLog
//
//  Created by 이지원 on 2021/10/16.
//

import UIKit

/// TextField의 Selection, Action을 끌 수 있는 서브 클래스
/// 글쓰기 화면에서 WriteTextFieldCell에서 사용한다. 키보드 타입이 numberpad 인 경우, isSelection을 false로 변경해 Selection, Action을 사용하지 않는다.
final class DisableSelectionTextField: UITextField {
    var isSelection: Bool = true

    init(isSelection: Bool) {
        super.init(frame: .zero)
        self.isSelection = isSelection
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if isSelection {
            return action == #selector(select(_:)) || action == #selector(selectAll(_:))
        }
        return isSelection
    }

    override func selectionRects(for range: UITextRange) -> [UITextSelectionRect] {
        if isSelection {
            return super.selectionRects(for: range)
        } else {
            return []
        }
    }

    override func caretRect(for position: UITextPosition) -> CGRect {
        if isSelection {
            return super.caretRect(for: position)
        } else {
            let endPosition: UITextPosition = self.endOfDocument
            return super.caretRect(for: endPosition)
        }
    }
}
