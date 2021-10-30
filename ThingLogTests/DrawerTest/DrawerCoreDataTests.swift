//
//  DrawerInformationTests.swift
//  ThingLogTests
//
//  Created by hyunsu on 2021/10/29.
//

import XCTest

@testable import ThingLog

class DrawerCoreDataTests: XCTestCase {
    
    override func tearDown() {
        NSUbiquitousKeyValueStore.default.removeObject(forKey: KeyStoreName.representativeDrawer.name)
        NSUbiquitousKeyValueStore.default.removeObject(forKey: KeyStoreName.userLoginCount.name)
        NSUbiquitousKeyValueStore.default.removeObject(forKey: KeyStoreName.userRecentLoginDate.name)
        NSUbiquitousKeyValueStore.default.removeObject(forKey: KeyStoreName.dragonBallArray.name)
        DrawerCoreDataRepository(coreDataStack: CoreDataStack.shared).deleteAllDrawers()
        
    }
    
    func test_수학의정석_에는_날짜가_필요하므로_날짜정보를_NSUbiquitousKeyValueStore에_저장하여_그값을_불러올수있다() {
        print(KeyStoreName.userRecentLoginDate.name)
        let date: Date = Date()
        let dateString: String = date.toString(.year) + date.toString(.month) + date.toString(.day)
        NSUbiquitousKeyValueStore.default.set(dateString, forKey: KeyStoreName.userRecentLoginDate.name)
        NSUbiquitousKeyValueStore.default.synchronize()
        if let date = NSUbiquitousKeyValueStore.default.string(forKey: KeyStoreName.userRecentLoginDate.name)  {
            print(date)
            
            XCTAssertTrue(true)
        } else {
            XCTFail()
        }
    }
    
    func test_Drawers들을_만들어서_가져올수있다() {
        let mockDrawers = createMockDrawer()
        let repo: DrawerCoreDataRepository = DrawerCoreDataRepository(coreDataStack: CoreDataStack.shared,
                                                            defaultDrawers: mockDrawers)
        repo.fetchDrawers { drawers in
            if let drawers = drawers {
                XCTAssertTrue(drawers.count == mockDrawers.count )
            } else {
                XCTFail()
            }
        }
    }
    
    func test_이미_coreData에_특정_Drawer가_있는경우_또_만들지_않는다() {
        let mockDrawers = createMockDrawer()
        let repo: DrawerCoreDataRepository = DrawerCoreDataRepository(coreDataStack: CoreDataStack.shared,
                                                            defaultDrawers: mockDrawers)
        repo.fetchDrawers { drawers in
            if let _ = drawers {
                repo.fetchDrawers { drawers in
                    if let drawers = drawers {
                        XCTAssertTrue(drawers.count == mockDrawers.count )
                    } else {
                        XCTFail()
                    }
                }
            } else {
                XCTFail()
            }
        }
    }
    
    func test_대표진열장이_없는경우_fetchRepresentative는_nil이다() {
        let repo: DrawerCoreDataRepository = DrawerCoreDataRepository(coreDataStack: CoreDataStack.shared)
        if let _ = repo.fetchRepresentative() {
            XCTFail()
        } else {
            XCTAssertTrue(true)
        }
    }
    
    func test_대표진열장을_설정한경우_fetchRepresentative는_nil이_아니다() {
        let mockDrawers = createMockDrawer()
        let repo: DrawerCoreDataRepository = DrawerCoreDataRepository(coreDataStack: CoreDataStack.shared,
                                                            defaultDrawers: mockDrawers)
        repo.fetchDrawers { drawers in
            repo.updateRepresentative(drawer: mockDrawers.first!)
            
            if let _ = repo.fetchRepresentative() {
                XCTAssert(true)
            } else {
                XCTFail()
            }
        }
    }
    
    func test_포토카드로_선물감사_인사_전하기_달성할경우_반영이_된다() {
        let mockDrawers = createMockDrawer()
        let repo: DrawerCoreDataRepository = DrawerCoreDataRepository(coreDataStack: CoreDataStack.shared,
                                                            defaultDrawers: mockDrawers)
        repo.fetchDrawers { drawers in
            repo.updateRightAward()
            repo.fetchDrawers{ drawers  in
                if let drawers = drawers {
                    if let index = drawers.firstIndex(where: {$0.imageName == "rightAward"}) {
                        XCTAssert(drawers[index].isAcquired)
                    } else {
                        XCTFail()
                    }
                }
            }
        }
    }
    
    func test_3일접속하면_userLoginCount는_3이_된다() {
        let date = (0..<3).map { Date().offset($0, byAdding: .day)! }
        
        let repo: DrawerCoreDataRepository = DrawerCoreDataRepository(coreDataStack: CoreDataStack.shared,
                                                            defaultDrawers: nil)
        date.forEach {
            repo.updateLoginCount(currentDate: $0)
        }
        
        XCTAssert(NSUbiquitousKeyValueStore.default.longLong(forKey: KeyStoreName.userLoginCount.name) == 3, "\(NSUbiquitousKeyValueStore.default.longLong(forKey: KeyStoreName.userLoginCount.name))")
    }
    
    func test_30일이상_접속했을시_문구세트를_획득한걸로_반영된다() {
        let date = (0..<30).map { Date().offset($0, byAdding: .day)! }
        
        let mockDrawers = createMockDrawer()
        let repo: DrawerCoreDataRepository = DrawerCoreDataRepository(coreDataStack: CoreDataStack.shared,
                                                            defaultDrawers: mockDrawers)
        date.forEach {
            repo.updateLoginCount(currentDate: $0)
        }
        repo.fetchDrawers { drawers in
            repo.updateStationery()
            repo.fetchDrawers{ drawers  in
                if let drawers = drawers {
                    if let index = drawers.firstIndex(where: {$0.imageName == "stationery"}) {
                        XCTAssert(drawers[index].isAcquired)
                    } else {
                        XCTFail()
                    }
                }
            }
        }
    }
    
    func test_3일이상_접속했을시_수학의정석을_획득한걸로_반영된다() {
        let date = (0..<3).map { Date().offset($0, byAdding: .day)! }
        
        let mockDrawers = createMockDrawer()
        let repo: DrawerCoreDataRepository = DrawerCoreDataRepository(coreDataStack: CoreDataStack.shared,
                                                            defaultDrawers: mockDrawers)
        date.forEach {
            repo.updateLoginCount(currentDate: $0)
        }
        
        repo.fetchDrawers { drawers in
            repo.updateMath()
            repo.fetchDrawers{ drawers  in
                if let drawers = drawers {
                    if let index = drawers.firstIndex(where: {$0.imageName == "math"}) {
                        XCTAssert(drawers[index].isAcquired)
                    } else {
                        XCTFail()
                    }
                }
            }
        }
    }
    
    func test_3일만_접속했을시_문구세트를_획득하지_않은걸로_반영된다() {
        let date = (0..<3).map { Date().offset($0, byAdding: .day)! }
        
        let mockDrawers = createMockDrawer()
        let repo: DrawerCoreDataRepository = DrawerCoreDataRepository(coreDataStack: CoreDataStack.shared,
                                                            defaultDrawers: mockDrawers)
        date.forEach {
            repo.updateLoginCount(currentDate: $0)
        }
        
        repo.fetchDrawers { drawers in
            repo.updateMath()
            repo.fetchDrawers{ drawers  in
                if let drawers = drawers {
                    if let index = drawers.firstIndex(where: {$0.imageName == "stationery"}) {
                        XCTAssert(drawers[index].isAcquired == false)
                    } else {
                        XCTFail()
                    }
                }
            }
        }
    }
    
    func test_장바구니를_획득했다면_반영된다() {
        let mockDrawers = createMockDrawer()
        let repo: DrawerCoreDataRepository = DrawerCoreDataRepository(coreDataStack: CoreDataStack.shared,
                                                            defaultDrawers: mockDrawers)
        
        repo.fetchDrawers { drawers in
            repo.updateBasket()
            repo.fetchDrawers{ drawers  in
                if let drawers = drawers {
                    if let index = drawers.firstIndex(where: {$0.imageName == "basket"}) {
                        XCTAssert(drawers[index].isAcquired)
                    } else {
                        XCTFail()
                    }
                }
            }
        }
    }
    
    func test_장바구니를_획득하지_않았다면_isAcquired는_false다() {
        let mockDrawers = createMockDrawer()
        let repo: DrawerCoreDataRepository = DrawerCoreDataRepository(coreDataStack: CoreDataStack.shared,
                                                            defaultDrawers: mockDrawers)
        
        repo.fetchDrawers { drawers in
            if let drawers = drawers {
                if let index = drawers.firstIndex(where: {$0.imageName == "basket"}) {
                    XCTAssert(drawers[index].isAcquired == false)
                } else {
                    XCTFail()
                }
            }
        }
    }
    
    func test_100만원이상_쓴경우_vip를_획득하면_반영된다() {
        let mockDrawers = createMockDrawer()
        let repo: DrawerCoreDataRepository = DrawerCoreDataRepository(coreDataStack: CoreDataStack.shared,
                                                            defaultDrawers: mockDrawers)
        
        repo.fetchDrawers { drawers in
            repo.updateVIP(by: 1_000_000)
            repo.fetchDrawers{ drawers  in
                if let drawers = drawers {
                    if let index = drawers.firstIndex(where: {$0.imageName == "vip"}) {
                        XCTAssert(drawers[index].isAcquired == true)
                    } else {
                        XCTFail()
                    }
                }
            }
        }
    }
    
    func test_만족도를_1만설정한경우_드래곤볼의_isAcquired는_false다() {
        let mockDrawers = createMockDrawer()
        let repo: DrawerCoreDataRepository = DrawerCoreDataRepository(coreDataStack: CoreDataStack.shared,
                                                            defaultDrawers: mockDrawers)
        
        repo.fetchDrawers { drawers in
            repo.updateDragonBall(rating: 1)
            repo.fetchDrawers{ drawers  in
                if let drawers = drawers {
                    if let index = drawers.firstIndex(where: {$0.imageName == "dragonBall"}) {
                        XCTAssert(drawers[index].isAcquired == false)
                    } else {
                        XCTFail()
                    }
                }
            }
        }
    }
    
    func test_만족도를_1_2_3_4_5_모두_설정한경우_드래곤볼의_isAcquired는_true다() {
        let mockDrawers = createMockDrawer()
        let repo: DrawerCoreDataRepository = DrawerCoreDataRepository(coreDataStack: CoreDataStack.shared,
                                                            defaultDrawers: mockDrawers)
        
        repo.fetchDrawers { drawers in
            for score in 1...5 {
                repo.updateDragonBall(rating: Int16(score))
            }
            
            repo.fetchDrawers{ drawers  in
                if let drawers = drawers {
                    if let index = drawers.firstIndex(where: {$0.imageName == "dragonBall"}) {
                        XCTAssert(drawers[index].isAcquired == true)
                    } else {
                        XCTFail()
                    }
                }
            }
        }
    }
    
    func test_기존의_coredata에_저장되어있는_drawer의_title이름을_변경한다면_반영된다() {
        var mockDrawers = createMockDrawer()
        let repo: DrawerCoreDataRepository = DrawerCoreDataRepository(coreDataStack: CoreDataStack.shared,
                                                            defaultDrawers: mockDrawers)
        let targetImageName: String = mockDrawers[0].imageName!
        let changeTitleName: String = "change Name!"
        
        repo.fetchDrawers { drawers in
            mockDrawers[0].title = changeTitleName
            repo.defaultDrawers = mockDrawers
            
            repo.fetchDrawers{ drawers  in
                if let drawers = drawers {
                    if let index = drawers.firstIndex(where: {$0.imageName == targetImageName}) {
                        XCTAssert(drawers[index].title == changeTitleName, drawers[index].title!)
                    } else {
                        XCTFail()
                    }
                }
            }
        }
    }
}


extension DrawerCoreDataTests {
    func createMockDrawer() -> [Drawerable] {
        return [
            MockDrawer(title: "수학의 정석",
                       subTitle: "방문 3회 달성",
                       information: "집합 부분만 너덜거리는 수학의 정석. 작심 3일 하지 말고 끝까지 기록해 보자는 응원의 선물!",
                       imageData: nil,
                       imageName: "math",
                       isAcquired: false),
            MockDrawer(title: "인의예지상",
                       subTitle: "방문 3회 달성",
                       information: "집합 부분만 너덜거리는 수학의 정석. 작심 3일 하지 말고 끝까지 기록해 보자는 응원의 선물!",
                       imageData: nil,
                       imageName: "rightAward",
                       isAcquired: false),
            MockDrawer(title: "문구세트",
                       subTitle: "방문 3회 달성",
                       information: "집합 부분만 너덜거리는 수학의 정석. 작심 3일 하지 말고 끝까지 기록해 보자는 응원의 선물!",
                       imageData: nil,
                       imageName: "stationery",
                       isAcquired: false),
            MockDrawer(title: "장바구니",
                       subTitle: "방문 3회 달성",
                       information: "집합 부분만 너덜거리는 수학의 정석. 작심 3일 하지 말고 끝까지 기록해 보자는 응원의 선물!",
                       imageData: nil,
                       imageName: "basket",
                       isAcquired: false),
            MockDrawer(title: "VIP",
                       subTitle: "방문 3회 달성",
                       information: "집합 부분만 너덜거리는 수학의 정석. 작심 3일 하지 말고 끝까지 기록해 보자는 응원의 선물!",
                       imageData: nil,
                       imageName: "vip",
                       isAcquired: false),
            MockDrawer(title: "드래곤볼",
                       subTitle: "방문 3회 달성",
                       information: "집합 부분만 너덜거리는 수학의 정석. 작심 3일 하지 말고 끝까지 기록해 보자는 응원의 선물!",
                       imageData: nil,
                       imageName: "dragonBall",
                       isAcquired: false)
        ]
    }
    
    
}

struct MockDrawer: Drawerable {
    var title: String?
    var subTitle: String?
    var information: String?
    var imageData: Data?
    var imageName: String?
    var isAcquired: Bool
}
