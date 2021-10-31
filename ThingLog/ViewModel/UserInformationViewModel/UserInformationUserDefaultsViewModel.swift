//
//  UserInformationUserDefaultsViewModel.swift
//  ThingLog
//
//  Created by hyunsu on 2021/09/21.
//

import Foundation
import RxSwift

/// `UserDefaults`를 이용하여 유저정보를 가져오고 업데이트하는 ViewModel
final class UserInformationUserDefaultsViewModel: UserInformationViewModelable {
    func fetchUserInformation(completion: @escaping (UserInformationable?) -> Void) {
        if UserDefaults.standard.value(forKey: UserDefaults.userAliasName) == nil {
            completion(nil)
            return
        }
        
        let userName: String = UserDefaults.standard.value(forKey: UserDefaults.userAliasName) as? String ?? ""
        let userOneLine: String = UserDefaults.standard.value(forKey: UserDefaults.userOneLineIntroduction) as? String ?? ""
        let darkMode: Bool = UserDefaults.standard.value(forKey: UserDefaults.isAutomatedDarkMode) as? Bool ?? true
        
        let userInformation: UserInformation = UserInformation(userAliasName: userName,
                                                               userOneLineIntroduction: userOneLine,
                                                               isAumatedDarkMode: darkMode)
        completion(userInformation)
    }
    
    func updateUserInformation(_ user: UserInformationable) {
        UserDefaults.standard.setValue(user.userAliasName, forKey: UserDefaults.userAliasName)
        UserDefaults.standard.setValue(user.userOneLineIntroduction, forKey: UserDefaults.userOneLineIntroduction)
        UserDefaults.standard.setValue(user.isAumatedDarkMode, forKey: UserDefaults.isAutomatedDarkMode)
        
        // TODO: - ⚠️ name 이름 변경 예정 - Notification extension하여
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userInformation"), object: nil)
    }
    
    func resetUserInformation() {
        UserDefaults.standard.removeObject(forKey: UserDefaults.userAliasName)
        UserDefaults.standard.removeObject(forKey: UserDefaults.userOneLineIntroduction)
        UserDefaults.standard.removeObject(forKey: UserDefaults.isAutomatedDarkMode)
    }
    
    func subscribeUserInformationChange(completion: @escaping (UserInformationable?) -> Void) {
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "userInformation"), object: nil, queue: .main) { [weak self] _ in
            self?.fetchUserInformation(completion: { userInformation in
                completion(userInformation)
            })
        }
    }
}

