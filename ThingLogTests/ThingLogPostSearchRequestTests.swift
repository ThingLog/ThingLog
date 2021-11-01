//
//  ThingLogPostSearchRequestTests.swift
//  ThingLogTests
//
//  Created by hyunsu on 2021/10/07.
//

import XCTest
@testable import ThingLog
import CoreData

/// 검색홈에서 검색에 따른 데이터를 보여주기 위한 NSFetchRequest 테스트 코드다.
class ThingLogPostSearchTests: XCTestCase, DummyProtocol {
    let context: NSManagedObjectContext = CoreDataStack.shared.mainContext
    
    var postRepository: PostRepository = PostRepository(fetchedResultsControllerDelegate: nil)
    var categoryRepository: CategoryRepository = CategoryRepository(fetchedResultsControllerDelegate: nil)
    
    override func tearDown() {
        deleteAllEntity()
    }
    
    // 카테고리가 포함 된 모든 글을 노출해요. 카테고리 개수가 적은 순서로요.
    // 카테고리가 복수인 경우( ‘문구’ ‘노트’ )는 단수로 존재하는 ‘문구’ 보다 밑에 위치하여 노출됩니다.
    func test_특정_카테고리로_post들을_카테고리가개수가_적은순서대로_가져올_수_있다() {
        let posts = dummyPost(20)
        
        posts.forEach {
            create($0)
        }
        
        let targetCategoryTitle: String = "문구"
        
        let request: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
        request.predicate = NSPredicate(format: "ANY categories.title == %@", targetCategoryTitle)
        request.sortDescriptors = [NSSortDescriptor(key: "categoryCount", ascending: true)]
        
        timeout(0.3) { exp in
            context.perform {
                let list = try! request.execute()
                exp.fulfill()
                list.forEach {
                    ($0.categories?.allObjects as?  [CategoryEntity])?.forEach {
                        print($0.title)
                    }
                    print()
                }
                XCTAssertTrue(list == list.sorted(by: { $0.categories!.count < $1.categories!.count}))
            }
        }
    }
    
    func test_특정_물건이름으로_post들을_가져올_수_있다() {
        let posts = dummyPost(20)
        
        posts.forEach {
            create($0)
        }
        
        let targetTitle: String = "아이패드"
        let targetCount: Int = posts.filter { $0.title.contains(targetTitle)}.filter { $0.postType.isDelete == false}.count
        
        let request: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
        var predicates: [NSPredicate] = [ ]
        predicates.append(NSPredicate(format: "title CONTAINS %@", targetTitle))
        predicates.append(NSPredicate(format: "postType.isDelete == false"))
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        request.sortDescriptors = [NSSortDescriptor(key: "createDate", ascending: false)]
        
        timeout(0.3) { exp in
            context.perform {
                let list = try! request.execute()
                exp.fulfill()
                print(list.count, targetCount)
                XCTAssertTrue(list.count == targetCount)
            }
        }
    }
    
    func test_글내용에_특정_문자가_포함된_post들을_가져올_수_있다() {
        let posts = dummyPost(20)
        
        posts.forEach {
            create($0)
        }
        
        let targetTitle: String = "아이패드"
        let targetCount: Int = posts.filter { $0.contents!.contains(targetTitle)}.filter { $0.postType.isDelete == false}.count
        
        let request: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
        var predicates: [NSPredicate] = [ ]
        predicates.append(NSPredicate(format: "contents CONTAINS %@", targetTitle))
        predicates.append(NSPredicate(format: "postType.isDelete == false"))
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        request.sortDescriptors = [NSSortDescriptor(key: "createDate", ascending: false)]
        
        timeout(0.3) { exp in
            context.perform {
                let list = try! request.execute()
                exp.fulfill()
                print(list.count, targetCount)
                list.forEach { print($0.contents)}
                XCTAssertTrue(list.count == targetCount)
            }
        }
    }
    
    func test_특정_선물준_사람으로_post들을_가져올_수_있다() {
        let posts = dummyPost(20)
        
        posts.forEach {
            create($0)
        }
        
        let targetGiver: String = "현수"
        let targetCount: Int = posts.filter { $0.giftGiver == targetGiver }.count
        
        let request: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
        request.predicate = NSPredicate(format: "giftGiver CONTAINS %@", targetGiver)
        request.sortDescriptors = [NSSortDescriptor(key: "createDate", ascending: false)]
        
        timeout(0.3) { exp in
            context.perform {
                let list = try! request.execute()
                exp.fulfill()
                print(list.count, targetCount)
                list.forEach { print($0.purchasePlace)}
                XCTAssertTrue(list.count == targetCount)
            }
        }
    }
    
    func test_특정_구매처판매처로_post들을_가져올_수_있다() {
        let posts = dummyPost(20)
        
        posts.forEach {
            create($0)
        }
        
        let targetTitle: String = "강남"
        let targetCount: Int = posts.filter { $0.purchasePlace!.contains(targetTitle)}.count
        
        let request: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
        request.predicate = NSPredicate(format: "purchasePlace CONTAINS %@", targetTitle)
        request.sortDescriptors = [NSSortDescriptor(key: "createDate", ascending: false)]
        
        timeout(0.3) { exp in
            context.perform {
                let list = try! request.execute()
                exp.fulfill()
                print(list.count, targetCount)
                list.forEach { print($0.purchasePlace)}
                XCTAssertTrue(list.count == targetCount)
            }
        }
    }
}
