//
//  AnalyticsEvents.swift
//  ThingLog
//
//  Created by 이지원 on 2022/01/21.
//

import Foundation

import Firebase

enum AnalyticsEvents: String {
    case savePhotocard = "save_photocard" // 포토카드 저장
    case acquireMath = "acquire_math" // 수학의 정석 획득
    case acquireStationery = "acquire_stationery" // 문구류 획득
    case acquireRightAward = "acquire_rightAward" // 인의예지상 획득
    case acquireDragonball = "acquire_dragonball" // 드래곤볼 획득
    case acquireBasket = "acquire_basket" // 장바구니 획득
    case acquireBlackCard = "acquire_blackCard"// 블랙카드 획득
    case acquireThingLogCode = "acquire_thingLogCode" // 띵로그 코드 획득
    
    func logging() {
        switch self {
        case .savePhotocard:
            Analytics.logEvent(self.rawValue, parameters: [
                "event_name": self.rawValue
            ])
        case .acquireMath, .acquireStationery, .acquireRightAward, .acquireDragonball, .acquireBasket, .acquireBlackCard, .acquireThingLogCode:
            Analytics.logEvent(self.rawValue, parameters: [
                "event_name": "acquire",
                "badge": self.rawValue
            ])
        }
    }
}
