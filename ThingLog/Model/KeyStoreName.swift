//
//  KeyStoreName.swift
//  ThingLog
//
//  Created by hyunsu on 2021/10/29.
//

import Foundation

/// iCloud와 연동하여 정보를 저장하기 위한 이름 객체입니다.
enum KeyStoreName: String {
    /// 최근 접속 날짜
    case userRecentLoginDate
    
    /// 접속 횟수
    case userLoginCount
    
    /// 유저 닉네임
    case userAliasName
    
    /// 유저 한 줄 정보
    case userOneLineIntroduction
    
    /// 유저가 최대로 소비한 값
    case userMaxExpense
    
    /// 진열장에서 대표 물건
    case representativeDrawer
    
    /// 다크모드
    case isAutomatedDarkMode
    
    /// 드래곤볼을 판단하기 위한 배열이름
    case dragonBallArray
    
    /// 새로운 진열장 아이템 획득 이벤트 여부
    case isNewEvent
    
    var name: String {
        self.rawValue
    }
}
