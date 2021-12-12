//
//  UserInformationiCloudViewModel.swift
//  ThingLog
//
//  Created by hyunsu on 2021/10/31.
//
import Foundation

/// `KeyValueStorage`를 이용하여 유저정보를 가져오고 업데이트하는 ViewModel
final class UserInformationiCloudViewModel: UserInformationViewModelable {
    var keyValueStorage: KeyValueStoragable = CloudKeyValueStorage.shared
    func fetchUserInformation(completion: @escaping (UserInformationable?) -> Void) {
        if keyValueStorage.string(forKey: KeyStoreName.userAliasName.name) == nil {
            completion(nil)
            return
        }
        let userName: String = keyValueStorage.string(forKey: KeyStoreName.userAliasName.name) ?? ""
        let userOneLine: String = keyValueStorage.string(forKey: KeyStoreName.userOneLineIntroduction.name) ?? ""
        let darkMode: Bool = keyValueStorage.bool(forKey: KeyStoreName.isAutomatedDarkMode.name)
        
        let userInformation: UserInformation = UserInformation(userAliasName: userName,
                                                               userOneLineIntroduction: userOneLine,
                                                               isAumatedDarkMode: darkMode)
        completion(userInformation)
    }
    
    func updateUserInformation(_ user: UserInformationable) {
        keyValueStorage.set(user.userAliasName,
                                              forKey: KeyStoreName.userAliasName.name)
        keyValueStorage.set(user.userOneLineIntroduction,
                                              forKey: KeyStoreName.userOneLineIntroduction.name)
        keyValueStorage.set(user.isAumatedDarkMode,
                                              forKey: KeyStoreName.isAutomatedDarkMode.name)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userInformation"), object: nil)
    }
    
    func resetUserInformation() {
        keyValueStorage.removeObject(forKey: KeyStoreName.userAliasName.name)
        keyValueStorage.removeObject(forKey: KeyStoreName.userOneLineIntroduction.name)
        keyValueStorage.removeObject(forKey: KeyStoreName.isAutomatedDarkMode.name)
    }
    
    func subscribeUserInformationChange(completion: @escaping (UserInformationable?) -> Void) {
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "userInformation"), object: nil, queue: .main) { [weak self] _ in
            self?.fetchUserInformation(completion: { userInformation in
                completion(userInformation)
            })
        }
    }
}
