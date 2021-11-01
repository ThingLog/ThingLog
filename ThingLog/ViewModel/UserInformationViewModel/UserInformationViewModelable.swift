//
//  UserInformationViewModelable.swift
//  ThingLog
//
//  Created by hyunsu on 2021/11/01.
//

import Foundation

/// 유저정보의 데이터와 업데이트를 하기 위한 메소드들을 정의한 프로토콜이다.
protocol UserInformationViewModelable {
    /// 유저정보를 가져오도록 한다.
    func fetchUserInformation(completion: @escaping (UserInformationable?) -> Void)
    
    /// 유저정보를 업데이트 하도록 한다.
    func updateUserInformation(_ user: UserInformationable)
    
    /// 테스트용으로 유저정보를 초기화하도록 한다.
    func resetUserInformation()
    
    /// 유저정보가 변경된 경우 감지하여 추가적인 로직을  completion에서 구현하도록 한다.
    func subscribeUserInformationChange(completion: @escaping (UserInformationable?) -> Void)
}
