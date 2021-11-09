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
    /// - Parameters:
    ///   - offset: 이전, 이후 날짜 만큼의 offset을 지정한다.
    ///   - type: 일별, 월별로 타입을 지정하여, 타입만큼의 offset을 지정하도록 한다.
    /// - Returns: 지나거나 이전의 날짜의 옵셔널을 반환한다.
    /// offset이 1일경우 1type 이후 날짜를 반환하고, offset이 -1인경우에 1type 이전 날짜를 반환한다.
    func offset(_ offset: Int, byAdding type: Calendar.Component) -> Date? {
        var calendar: Calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        let end: Date? = Calendar.current.date(byAdding: type, value: offset, to: calendar.startOfDay(for: self))
        return end
    }
    
    /// self 날짜를 파라미터의 날짜값의 날짜차이를 구한다.
    /// - Parameter pivotDate: 날짜차이를 원하는 날짜를 주입한다.
    /// - Returns: self날짜보다 주입한 날짜가 큰 경우 양수값으로 나온다.
    func distanceFrom(_ pivotDate: Date) -> Int {
        Calendar.current.dateComponents([.day], from: self, to: pivotDate).day ?? 0
    }
}
