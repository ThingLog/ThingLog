//
//  UserInformation.swift
//  ThingLog
//
//  Created by hyunsu on 2021/10/31.
//

import Foundation

/// 사용자정보가 되기 위한 프로퍼티들을 명시한 프로토콜이다.
protocol UserInformationable {
    /// 사용자의 닉네임
    var userAliasName: String { get set }
    
    /// 사용자의 한 줄 소개
    var userOneLineIntroduction: String { get set }
    
    /// 사용자의 다크모드 여부
    var isAumatedDarkMode: Bool { get set }
}

struct UserInformation: UserInformationable {
    var userAliasName: String
    
    var userOneLineIntroduction: String
    
    var isAumatedDarkMode: Bool
}
