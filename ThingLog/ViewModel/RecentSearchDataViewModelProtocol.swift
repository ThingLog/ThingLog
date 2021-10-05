//
//  RecentSearchDataViewModelProtocol.swift
//  ThingLog
//
//  Created by hyunsu on 2021/10/04.
//
import Foundation
import RxSwift

protocol RecentSearchDataViewModelProtocol: AnyObject {
    var recentSearchDataSubject: BehaviorSubject<[String]> { get set }
    
    var isAutoSaveModeSubject: BehaviorSubject<Bool> { get set }
    
    var isRecentSearchDataEmpty: Bool { get }
    var isAutoSaveMode: Bool { get }
    
    /// 최근검색어에 새로운 최근검색어를 추가한다.
    /// - Parameter searchData: 추가하고자 하는 검색어를 주입한다.
    func add(_ searchData: String)
    
    /// 최근검색어 데이터의 index에 해당하는 최근검색어를 삭제한다.
    /// - Parameter index: 삭제하고자 하는 index를 주입한다.
    func remove(at index: Int)
    
    /// 최근검색어 데이터 모두를 삭제한다.
    func removeAll()
    
    /// 자동저장 기능을 변경한다.
    /// - Parameter isAuto: 자동저장 활성화로 변경한 경우는 true, 그렇지 않다면 false를 주입한다.
    func changeAutoSaveMode(isAuto: Bool)
}
