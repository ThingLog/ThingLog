//
//  Date+.swift
//  ThingLog
//
//  Created by hyunsu on 2021/09/29.
//

import Foundation

extension Date {
    /// component에 맞는 문자열을 반환한다.
    /// - Parameter component: 예시: 일 - .day , 월 - .month, 년 - .year
    /// - Returns: 문자열을 반환한다.
    func toString(_ component: Calendar.Component) -> String {
        String(Calendar.current.component(component, from: self))
    }
}
