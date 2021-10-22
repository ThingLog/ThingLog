//
//  WriteViewModel.swift
//  ThingLog
//
//  Created by 이지원 on 2021/10/03.
//

import UIKit

final class WriteViewModel {
    enum Section: Int, CaseIterable {
        case image
        case type
        case rating
        case free
    }

    // MARK: - Properties
    var writeType: WriteType
    // WriteTextFieldCell을 표시할 때 필요한 keyboardType, placeholder 구성
    var typeInfo: [(keyboardType: UIKeyboardType, placeholder: String)] {
        switch writeType {
        case .bought:
            return [(.default, "물건 이름"), (.numberPad, "가격"), (.default, "구매처")]
        case .wish:
            return [(.default, "물건 이름"), (.numberPad, "가격"), (.default, "판매처")]
        case .gift:
            return [(.default, "물건 이름"), (.default, "선물 준 사람")]
        }
    }
    // Section 마다 표시할 항목의 개수
    lazy var itemCount: [Int] = [1, typeInfo.count, 1, 1]

    init(writeType: WriteType) {
        self.writeType = writeType
    }
}
