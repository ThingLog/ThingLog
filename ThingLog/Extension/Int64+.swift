//
//  Int64+.swift
//  ThingLog
//
//  Created by 이지원 on 2021/11/25.
//

import Foundation

extension Int64 {
    func toStringWithComma() -> String? {
        let formatter: NumberFormatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0

        let number: NSNumber = NSNumber(value: self)
        // 3자리마다 , 삽입
        let formattedString: String? = formatter.string(from: number)
        return formattedString
    }
}
