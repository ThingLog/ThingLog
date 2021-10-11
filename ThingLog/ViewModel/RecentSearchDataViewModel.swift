//
//  RecentSearchDataViewModel.swift
//  ThingLog
//
//  Created by hyunsu on 2021/10/03.
//

import Foundation
import RxSwift

/// 최근검색어 데이터를 관리하는 ViewModel이다.
/// recentSearchData를 susbscribe하여 손쉽게 tableView를 reload, update하도록 한다.
class RecentSearchDataViewModel: RecentSearchDataViewModelProtocol {
    lazy var recentSearchDataSubject: BehaviorSubject<[String]> = BehaviorSubject(value: _recentSearchData)
    lazy var isAutoSaveModeSubject: BehaviorSubject<Bool> = BehaviorSubject(value: _isAutoSaveMode)
    
    var isRecentSearchDataEmpty: Bool {
        _recentSearchData.isEmpty
    }
    
    var isAutoSaveMode: Bool {
        _isAutoSaveMode
    }
    
    private var _isAutoSaveMode: Bool = true {
        didSet {
            // 변경되면 UserDefaults를 갱신하고, Subject에 주입한다.
            UserDefaults.standard.setValue(_isAutoSaveMode,
                                           forKey: UserDefaults.isAutoSaveMode)
            isAutoSaveModeSubject.onNext(_isAutoSaveMode)
        }
    }
    private var _recentSearchData: [String] = [] {
        didSet {
            // 변경되면 UserDefaults를 갱신하고, Subject에 주입한다.
            UserDefaults.standard.setValue(_recentSearchData,
                                           forKey: UserDefaults.recentSearchData)
            recentSearchDataSubject.onNext(_recentSearchData)
        }
    }
    
    private let maxSaveCount: Int = 20
    init() {
        if let recentDatas: [String] = UserDefaults.standard.value(forKey: UserDefaults.recentSearchData) as? [String] {
            _recentSearchData = recentDatas
        } else {
            _recentSearchData = []
        }
        
        if let isAutoSaveMode: Bool = UserDefaults.standard.value(forKey: UserDefaults.isAutoSaveMode) as? Bool {
            _isAutoSaveMode = isAutoSaveMode
        } else {
            _isAutoSaveMode = true
        }
    }
    
    /// 새로운 최근검색어를 추가한다.
    /// - Parameter searchData: 추가하고자 하는 검색어를 주입한다.
    func add(_ searchData: String) {
        if _recentSearchData.contains(searchData) {
            return
        }
        
        if _recentSearchData.count == maxSaveCount {
            var newRecent: [String] = _recentSearchData
            newRecent.insert(searchData, at: 0)
            newRecent.removeLast()
            _recentSearchData = newRecent
        } else {
            _recentSearchData.insert(searchData, at: 0)
        }
    }
    
    /// index에 해당하는 최근검색어를 삭제한다.
    /// - Parameter index: 삭제하고자 하는 index를 주입한다.
    func remove(at index: Int) {
        if index < _recentSearchData.count {
            _recentSearchData.remove(at: index)
        }
    }
    
    func removeAll() {
        _recentSearchData = []
    }
    
    func changeAutoSaveMode(isAuto: Bool) {
        _isAutoSaveMode = isAuto
    }
}
