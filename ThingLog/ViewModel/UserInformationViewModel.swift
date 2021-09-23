//
//  UserInformation.swift
//  ThingLog
//
//  Created by hyunsu on 2021/09/21.
//

import Foundation
import RxSwift

/// User 정보를 감싸는 싱글톤 객체다.
/// ```
/// // Subscribe
/// UserInformationViewModel.shared.userAliasNameSubject
///     .observe(on: MainScheduler.instance)
///     .bind(to: label.rx.text)
///     .disposed(by: disposeBag)
///
///
/// // User 정보 수정하는 방법
/// UserInformationViewModel.shared.userAliasName = 유저가 설정한 닉네임
/// UserInformationViewModel.shared.userOneLineIntroduction = 유저가 설정한 한 줄 소개
/// UserInformationViewModel.shared.isAutomatedDarkMode = 유저가 설정한 다크모드 자동 옵션
/// ```
final class UserInformationViewModel {
    static let shared: UserInformationViewModel = UserInformationViewModel()
    
    lazy var userAliasNameSubject: BehaviorSubject = BehaviorSubject<String?>(value: userAliasName)
    lazy var userOneLineIntroductionSubject: BehaviorSubject = BehaviorSubject<String?>(value: userOneLineIntroduction)
    lazy var isAutomatedDarkModeSubject: BehaviorSubject = BehaviorSubject<Bool>(value: isAutomatedDarkMode)
    
    var userAliasName: String? {
        get {
            UserDefaults.standard.value(forKey: UserDefaults.userAliasName) as? String
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: UserDefaults.userAliasName)
            userAliasNameSubject.onNext(newValue)
        }
    }
    
    var userOneLineIntroduction: String? {
        get {
            UserDefaults.standard.value(forKey: UserDefaults.userOneLineIntroduction) as? String
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: UserDefaults.userOneLineIntroduction)
            userOneLineIntroductionSubject.onNext(newValue)
        }
    }
    
    var isAutomatedDarkMode: Bool {
        get {
            if let darkMode: Bool = UserDefaults.standard.value(forKey: UserDefaults.isAutomatedDarkMode) as? Bool {
                return darkMode
            } else {
                UserDefaults.standard.setValue(true, forKey: UserDefaults.isAutomatedDarkMode)
                return true
            }
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: UserDefaults.isAutomatedDarkMode)
            isAutomatedDarkModeSubject.onNext(newValue)
        }
    }

    private init() { }
}

