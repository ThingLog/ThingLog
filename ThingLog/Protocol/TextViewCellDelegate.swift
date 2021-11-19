//
//  TextViewCellDelegate.swift
//  ThingLog
//
//  Created by 이지원 on 2021/11/19.
//

import Foundation

/// 텍스트뷰를 포함한 셀의 높이를 동적으로 변경하기 위한 프로토콜
protocol TextViewCellDelegate: AnyObject {
    func updateTextViewHeight()
}
