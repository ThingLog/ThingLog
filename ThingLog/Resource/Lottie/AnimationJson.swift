//
//  AnimationName.swift
//  ThingLog
//
//  Created by hyunsu on 2021/11/18.
//

import Foundation

/// Lottie 용 애니메이션 json 파일의 이름을 돕는 객체다.
enum AnimationJson: String {
    case drawerNew
    case drawerNewDark
    case onboarding1
    case onboarding1Dark
    case onboarding2
    case onboarding2Dark
    case splash
    
    var name: String {
        self.rawValue
    }
}
