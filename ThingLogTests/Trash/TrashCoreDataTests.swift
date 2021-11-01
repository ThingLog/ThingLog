//
//  TrashCoreDataTests.swift
//  ThingLogTests
//
//  Created by hyunsu on 2021/10/31.
//
import CoreData
import XCTest
@testable import ThingLog

class TrashCoreDataTests: XCTestCase, DummyProtocol {
    let context: NSManagedObjectContext = CoreDataStack.shared.mainContext
    var postRepository: PostRepository = PostRepository(fetchedResultsControllerDelegate: nil)
    var categoryRepository: CategoryRepository = CategoryRepository(fetchedResultsControllerDelegate: nil)
    
    override func tearDown() {
        deleteAllEntity()
    }
    
    func test_날짜차이를_구할수있다() {
        let targetDate: Date = Date().offset(-30, byAdding: .day)!
        let currentDate: Date = Date()
        let dist: Int = targetDate.distanceFrom(currentDate)
        XCTAssert(30 == dist)
        
    }
    
    func test_더미데이터를_만들어서_삭제된_post들만_가져올_수_있다() {
        let posts = dummyPost(50)
        
        posts.forEach {
            create($0)
        }
        let targetCount: Int = posts.filter { $0.postType.isDelete == true }.count
        
        let request: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
        request.predicate = NSPredicate(format: "postType.isDelete == true")
        
        timeout(0.3) { exp in
            context.perform {
                let list = try! request.execute()
                exp.fulfill()
                XCTAssertTrue(list.count == targetCount)
            }
        }
    }
    
    func test_더미데이터를_만들어서_삭제된_post들을_삭제된날짜순으로_가져올_수_있다() {
        let posts = dummyPost(50)
        
        posts.forEach {
            create($0)
        }
        let targetCount: Int = posts.filter { $0.postType.isDelete == true }.count
        
        let request: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
        request.predicate = NSPredicate(format: "postType.isDelete == true")
        request.sortDescriptors = [NSSortDescriptor(key: "deleteDate", ascending: true)]
        
        timeout(0.3) { exp in
            context.perform {
                let list = try! request.execute()
                exp.fulfill()
                XCTAssertTrue(list.count == targetCount && list == list.sorted(by: {$0.deleteDate! < $1.deleteDate!}))
            }
        }
    }
    
    func test_더미데이터를_만들어서_삭제된_post들을_deleteDate기준으로_최대30일까지만_보여줄_수_있다() {
        let posts = dummyPost(50)
        
        posts.forEach {
            create($0)
        }
        let minDate: Date = Date().offset(-30, byAdding: .day)!
        let targetCount: Int = posts.filter { $0.postType.isDelete == true && $0.deleteDate! > minDate && $0.deleteDate! <= Date() }.count
        let request: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
        request.predicate = NSPredicate(format: "postType.isDelete == true AND deleteDate > %@ AND deleteDate <= %@", minDate as NSDate, Date() as NSDate )
        request.sortDescriptors = [NSSortDescriptor(key: "deleteDate", ascending: true)]
        
        timeout(0.3) { exp in
            context.perform {
                let list = try! request.execute()
                exp.fulfill()
                XCTAssertTrue(list.count == targetCount)
            }
        }
    }
    
    func test_더미데이터를_만들어서_삭제된_post들을_deleteDate기준으로_30일넘은_Post들을_보여줄_수_있다() {
        let posts = dummyPost(50)
        
        posts.forEach {
            create($0)
        }
        let minDate: Date = Date().offset(-30, byAdding: .day)!
        let targetCount: Int = posts.filter { $0.postType.isDelete == true && $0.deleteDate! <= minDate }.count
        let request: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
        request.predicate = NSPredicate(format: "postType.isDelete == true AND deleteDate <= %@", minDate as NSDate )
        request.sortDescriptors = [NSSortDescriptor(key: "deleteDate", ascending: true)]
        
        timeout(0.3) { exp in
            context.perform {
                let list = try! request.execute()
                exp.fulfill()
                XCTAssertTrue(list.count == targetCount)
            }
        }
    }
    
    func test_삭제된Post들중에서_30일넘은_Post들은_삭제할_수_있다() {
        let posts = dummyPost(60)
        
        posts.forEach {
            create($0)
        }
        
        timeout(4) { exp in
            // 30일 지난 데이터들 삭제하고,
            postRepository.checkTrashData { result in
                switch result {
                case .success(_):
                    
                    // 30일지난 데이터들을 가져와본다.
                    let minDate: Date = Date().offset(-30, byAdding: .day)!
                    let request: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
                    request.predicate = NSPredicate(format: "postType.isDelete == true AND deleteDate <= %@", minDate as NSDate )
                    request.sortDescriptors = [NSSortDescriptor(key: "deleteDate", ascending: true)]
                    self.context.perform {
                        do {
                            let list = try request.execute()
                            exp.fulfill()
                        } catch {
                            exp.fulfill()
                            XCTFail()
                        }
                    }
                case .failure(_):
                    XCTFail()
                }
            }
        }
    }
    
    func test_PostRepository의_fetchRequestByTrash를_이용하여_삭제된_post들을_삭제된날짜순과_30일까지만으로_가져올_수_있다() {
        let posts = dummyPost(50)
        
        posts.forEach {
            create($0)
        }
        let minDate: Date = Date().offset(-30, byAdding: .day)!
        let targetCount: Int = posts.filter { $0.postType.isDelete == true && $0.deleteDate! > minDate && $0.deleteDate! <= Date() }.count
        let request: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
        request.predicate = NSPredicate(format: "postType.isDelete == true")
        request.sortDescriptors = [NSSortDescriptor(key: "deleteDate", ascending: true)]
        
        let postRepo: PostRepository = PostRepository(fetchedResultsControllerDelegate: nil)
        let controller = postRepo.fetchResultsController(by: .fromTrash)
        XCTAssert(targetCount == controller.fetchedObjects?.count, "\(targetCount) \(controller.fetchedObjects!.count)")
    }
    
    
    func test_삭제된Post들중에서_모두복구할_수_있다() {
        let totalCount = 60
        let posts = dummyPost(totalCount)
        
        
        posts.forEach {
            create($0)
        }
        
        timeout(4) { exp in
            let controller = postRepository.fetchResultsController(by: .fromTrash)
            postRepository.recover(controller.fetchedObjects ?? []) { result in
                switch result {
                case .success(_):
                    let controller = self.postRepository.fetchResultsController(by: .fromTrash)
                   self.postRepository.fetchAll { result in
                    exp.fulfill()
                    switch result {
                        case .success(let entitis):
                            print(entitis.count )
                            XCTAssert(controller.fetchedObjects?.count == 0 && entitis.count == totalCount )
                        case .failure(_):
                            XCTFail()
                        }
                    }
                    
                case .failure(_):
                    XCTFail()
                }
            }
        }
    }
}
