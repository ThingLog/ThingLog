//
//  String+.swift
//  ThingLog
//
//  Created by hyunsu on 2021/10/08.
//

import Foundation

extension String {
    /// dateFormat 형식으로 문자열을 Date 타입으로 변환하는 메서드다
    /// - Returns: 변환된 Date타입을 옵셔널로 반환한다.
    func convertToDate(dateFormat: String) -> Date? {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.date(from: self)
    }
}
