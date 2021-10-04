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
    
    /// 새로운 최근검색어를 추가한다.
    /// - Parameter searchData: 추가하고자 하는 검색어를 주입한다.
    func add(_ searchData: String)
    
    /// index에 해당하는 최근검색어를 삭제한다.
    /// - Parameter index: 삭제하고자 하는 index를 주입한다.
    func remove(at index: Int)
    
    func removeAll()
}
