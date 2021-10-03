    //
//  ThingLogRecentSearchDataTests.swift
//  ThingLogTests
//
//  Created by hyunsu on 2021/10/03.
//

import XCTest
@testable import ThingLog
import RxSwift
    
class ThingLogRecentSearchDataTests: XCTestCase {

    var recentViewModel: RecentSearchDataViewModel = RecentSearchDataViewModel()
    var disposeBag: DisposeBag = DisposeBag()

    func test_최근검색어_데이터를_하나추가하면_subject가_변경된다() throws {
        recentViewModel.removeAll()
        var count: Int = 0
        timeout(3) { exp in
            recentViewModel.recentSearchDataSubject
                .bind { val in
                    count += 1
                    if count == 2 {
                        exp.fulfill()
                        XCTAssertTrue(val.count == 1 )
                    }
                }
                .disposed(by: disposeBag)
            
            self.recentViewModel.add("hiii")
        }
    }
    
    func test_최근검색어_데이터를_하나추가하고_하나를_삭제해도_subject가_변경된다() throws {
        recentViewModel.removeAll()
        var count: Int = 0
        timeout(3) { exp in
            recentViewModel.recentSearchDataSubject
                .bind { val in
                    count += 1
                    if count == 3 {
                        exp.fulfill()
                        XCTAssertTrue(val.count == 0 )
                    }
                }
                .disposed(by: disposeBag)
            
            self.recentViewModel.add("hiii")
            self.recentViewModel.remove(at: 0)
        }
    }
    
    func test_같은_최근검색어는_추가되지_않는다() throws {
        recentViewModel.removeAll()
        recentViewModel.add("hi")
        recentViewModel.add("hi")
        
        XCTAssertTrue((UserDefaults.standard.value(forKey: UserDefaults.recentSearchData) as? [String])?.count == 1)
    }
    
    func test_최근검색어_삭제할수있다() {
        recentViewModel.removeAll()
        recentViewModel.add("hi")
        recentViewModel.remove(at: 0)
        XCTAssertTrue((UserDefaults.standard.value(forKey: UserDefaults.recentSearchData) as? [String])?.count == 0)
    }
}
