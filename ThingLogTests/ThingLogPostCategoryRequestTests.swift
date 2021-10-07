//
//  ThingLogPostCategoryRequestTests.swift
//  ThingLogTests
//
//  Created by hyunsu on 2021/10/07.
//

import XCTest
@testable import ThingLog
import CoreData

/// 모아보기에서 전체, 년도, 카테고리, 좋아요, 만족도, 가격 + dropBox에 해당하는 필터링등을 조건으로 데이터를 가져오는 테스트코드다.
class ThingLogPostCategoryRequestTests: XCTestCase, DummyProtocol {
    
    let context: NSManagedObjectContext = CoreDataStack.shared.mainContext
    var postRepository: PostRepository = PostRepository(fetchedResultsControllerDelegate: nil)
    var categoryRepository: CategoryRepository = CategoryRepository(fetchedResultsControllerDelegate: nil)
    
    override func tearDown() {
        deleteAllEntity()
    }

    func test_년도와_9월로_Date타입으로_yyyMM_포멧으로는_만들_수_없다() {
        let year: String = "2021"
        let month: String = "9"
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMM"
        let date = dateFormatter.date(from: year+month)
        XCTAssert(date == nil )
    }
    
    func test_년도와_월로_Date타입으로_만들수_있다() {
        let year: String = "2021"
        let month: String = "12"
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMM"
        let date = dateFormatter.date(from: year+month)
        XCTAssert(date != nil )
    }
    
    // MARK: - Test
    func test_전체에서_최신순으로_post들을_가져올_수_있다() throws {
        let posts = dummyPost(10) + dummyPost(10)
        
        posts.forEach {
            create($0)
        }
        // 제일 높은
        
        let request: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "createDate", ascending: false)]
        
        timeout(0.3) { exp in
            context.perform {
                let list = try! request.execute()
                exp.fulfill()
                XCTAssertTrue(list.sorted(by: {$0.createDate! > $1.createDate!}) == list)
            }
        }
    }
    
    func test_년도에서_날짜별로_post들을_가져올_수_있다() throws {
        let posts = dummyPost(10) + dummyPost(10)
        
        posts.forEach {
            create($0)
        }
        // 제일 높은
        let targetDate: Date = Date().day(by: 3)!
        let targetCount: Int = posts.filter { $0.createDate == targetDate }.count
        
        let request: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
        request.predicate = NSPredicate(format: "createDate == %@", targetDate as NSDate)
        request.sortDescriptors = [NSSortDescriptor(key: "rating.score", ascending: false)]
        
        timeout(0.3) { exp in
            context.perform {
                let list = try! request.execute()
                exp.fulfill()
                print(list.count, targetCount)
                XCTAssertTrue(list.count == targetCount)
            }
        }
    }
    
    func test_특정_카테고리로_post들을_최신순으로_가져올_수_있다() throws {
        let posts = dummyPost(10)
        
        posts.forEach {
            create($0)
        }
        // 제일 높은
        let targetCategoryTitle: String = "가전"
        let targetCount: Int = posts.filter { $0.categories.contains(where: {$0.title == targetCategoryTitle} )}.count
        
        let request: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
        request.predicate = NSPredicate(format: "ANY categories.title == %@", targetCategoryTitle)
        request.sortDescriptors = [NSSortDescriptor(key: "createDate", ascending: false)]
        
        timeout(0.3) { exp in
            context.perform {
                let list = try! request.execute()
                exp.fulfill()
                print(list.count, targetCount)
                XCTAssertTrue(list.count == targetCount &&
                                list.sorted(by: {$0.createDate! > $1.createDate!}) == list)
            }
        }
    }
    
    func test_특정_카테고리가_특정_문자열이_포함된_카테고리로_post들을_최신순으로_가져올_수_있다() throws {
        let posts = dummyPost(10)
        
        posts.forEach {
            create($0)
        }
        // 제일 높은
        let targetCategoryTitle: String = "가"
        let targetCount: Int = posts.filter { $0.categories.contains(where: {$0.title.contains( targetCategoryTitle)} )}.count
        
        let request: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
        request.predicate = NSPredicate(format: "ANY categories.title CONTAINS %@", targetCategoryTitle)
        request.sortDescriptors = [NSSortDescriptor(key: "createDate", ascending: false)]
        
        timeout(0.3) { exp in
            context.perform {
                let list = try! request.execute()
                exp.fulfill()
                print(list.count, targetCount)
                XCTAssertTrue((list.count == targetCount &&
                                list.sorted(by: {$0.createDate! > $1.createDate!}) == list))
            }
        }
    }
    
    func test_좋아요가_높은순으로_post들을_가져올_수_있다() throws {
        let posts = dummyPost(10)
    
        posts.forEach {
            create($0)
        }
        
        let likeCount: Int = posts.filter { $0.isLike }.count
        
        let request: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "isLike", ascending: false)]
        
        timeout(0.3) { exp in
            context.perform {
                let list = try! request.execute()
                exp.fulfill()
                print(list.count)
               XCTAssertTrue(list[0..<likeCount].filter { $0.isLike }.count == likeCount)
            }
        }
    }
    
    func test_좋아요가_낮은순으로_post들을_가져올_수_있다() throws {
        let posts = dummyPost(10)
        
        posts.forEach {
            create($0)
        }
        
        let dislikeCount: Int = posts.filter { !$0.isLike }.count
        
        let request: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "isLike", ascending: true)]
        
        timeout(0.3) { exp in
            context.perform {
                let list = try! request.execute()
                exp.fulfill()
                print(list.count)
               XCTAssertTrue(list[0..<dislikeCount].filter { !$0.isLike }.count == dislikeCount)
            }
        }
    }
    
    func test_만족도가_높은순_으로_post들을_가져올_수_있다() throws {
        let posts = dummyPost(10)
        
        posts.forEach {
            create($0)
        }
        // 제일 높은
        let ratingCount: Int = posts.filter { $0.rating.score ==  .excellent }.count
        
        let request: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "rating.score", ascending: false)]
        
        timeout(0.3) { exp in
            context.perform {
                let list = try! request.execute()
                exp.fulfill()
                print(list.count, ratingCount)
                XCTAssertTrue(list[0..<ratingCount].filter { ($0.rating!.scoreType == ScoreType.excellent) }.count == ratingCount)
            }
        }
    }
    
    func test_만족도가_낮은순_으로_post들을_가져올_수_있다() throws {
        let posts = dummyPost(10)
        
        posts.forEach {
            create($0)
        }
        // 제일 낮은
        let ratingCount: Int = posts.filter { $0.rating.score ==  .veryPoor }.count
        
        let request: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "rating.score", ascending: true)]
        
        timeout(0.3) { exp in
            context.perform {
                let list = try! request.execute()
                exp.fulfill()
                print(list.count, ratingCount)
                list.forEach{ print($0.rating!.scoreType)}
                XCTAssertTrue(list[0..<ratingCount].filter { ($0.rating!.scoreType == ScoreType.veryPoor) }.count == ratingCount)
            }
        }
    }
    
    func test_가격이_높은순_으로_post들을_가져올_수_있다() throws {
        let posts = dummyPost(10)
        
        posts.forEach {
            create($0)
        }
        // 제일 낮은
        
        let request: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "price", ascending: false)]
        
        timeout(0.3) { exp in
            context.perform {
                let list = try! request.execute()
                exp.fulfill()
                XCTAssertTrue(list == list.sorted(by: { $0.price > $1.price }))
            }
        }
    }
    
    func test_가격이_낮은순_으로_post들을_가져올_수_있다() throws {
        let posts = dummyPost(10)
        
        posts.forEach {
            create($0)
        }
        // 제일 낮은
        
        let request: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "price", ascending: true)]
        
        timeout(0.3) { exp in
            context.perform {
                let list = try! request.execute()
                exp.fulfill()
                XCTAssertTrue(list == list.sorted(by: { $0.price < $1.price }))
            }
        }
    }
}
