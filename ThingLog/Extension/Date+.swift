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
    
    /// 특정날짜만큼 지난 날짜를 반환한다.
    /// - Parameter offset: 이전, 이후 날짜만큼의 offset을 지정한다.
    /// - Returns: 지나거나 이전의 날짜의 옵셔널을 반환한다.
    ///
    /// offset이 1일경우 1일이후 날짜를 반환하고, offset이 -1인경우에 1일이전 날짜를 반환한다.
    func day(by offset: Int) -> Date? {
        let calendar: Calendar = Calendar.current
        let end: Date? = calendar.date(byAdding: .day, value: offset, to: calendar.startOfDay(for: self))
        return end
    }
}
