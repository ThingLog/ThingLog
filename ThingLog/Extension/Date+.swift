//
//  Date+.swift
//  ThingLog
//
//  Created by hyunsu on 2021/09/29.
//

import Foundation

extension Date {
    /// 해당Date의 *일만 string으로 가져온다.
    func stringDay() -> String {
        String(Calendar.current.component(.day, from: self))
    }
    
    /// 해당Date의 *월만 string으로 가져온다.
    func stringMonth() -> String {
        String(Calendar.current.component(.month, from: self))
    }
    
    /// 해당Date의 *년만 string으로 가져온다.
    func stringYear() -> String {
        String(Calendar.current.component(.year, from: self))
    }
}
