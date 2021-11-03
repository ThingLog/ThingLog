//
//  ThingLogPostTypeRequestTest.swift
//  ThingLogTests
//
//  Created by hyunsu on 2021/10/10.
//

import XCTest
@testable import ThingLog
import CoreData

// 홈화면에서 PostType으로 구별하여 Post들을 가져오기 위한 테스트
class ThingLogPostTypeRequestTest: XCTestCase, DummyProtocol {

    let context: NSManagedObjectContext = CoreDataStack.shared.mainContext
    var postRepository: PostRepository = PostRepository(fetchedResultsControllerDelegate: nil)
    var categoryRepository: CategoryRepository = CategoryRepository(fetchedResultsControllerDelegate: nil)
    
    override func tearDown() {
        deleteAllEntity()
    }
    
    func test_특정PostType으로_Post들을_최신순으로_가져올_수_있다() {
        let posts = dummyPost(10) + dummyPost(10)
        
        posts.forEach {
            create($0)
        }
        // 제일 높은
        let targetPageType: Int16 = PageType.gift.rawValue
        let targetCount: Int = posts.filter { $0.postType.type == PageType.gift && $0.postType.isDelete == false }.count
        
        let request: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
        request.predicate = NSPredicate(format: "postType.isDelete == false AND postType.type == %d", targetPageType)
        request.sortDescriptors = [NSSortDescriptor(key: "createDate", ascending: false)]
        
        timeout(0.3) { exp in
            context.perform {
                let list = try! request.execute()
                exp.fulfill()
                print(list.count, targetCount)
                list.forEach { print($0.postType!.type == targetPageType)}
                XCTAssertTrue(list.count == targetCount)
            }
        }
    }
}
