//
//  ThingLogPostRepositoryTests.swift
//  ThingLogTests
//
//  Created by 이지원 on 2021/09/22.
//

/*
 테스트 코드 작성 가이드라인
 // given: 필요한 모든 값 설정
 // when: 테스트중인 코드 실행
 // then: 예상한 결과 확인
 */

import XCTest
@testable import ThingLog
import CoreData

class ThingLogPostRepositoryTests: XCTestCase {
    let postRepository: PostRepository = PostRepository(fetchedResultsControllerDelegate: nil)
    let categoryRepository: CategoryRepository = CategoryRepository(fetchedResultsControllerDelegate: nil)

    override func tearDown() {
        deleteAllEntity()
    }

    func test_Post를_하나_만들_수_있다() {
        // given: 필요한 모든 값 설정
        deleteAllEntity()
        guard let originalImage: UIImage = UIImage(systemName: "heart.fill") else {
            fatalError("Not Found system Image")
        }
        let newPost: Post = Post(title: "Test Post",
                                 price: 30_500,
                                 purchasePlace: "Market",
                                 contents: "Test Contents...",
                                 isLike: false,
                                 postType: .init(isDelete: false, type: .bought),
                                 rating: .init(score: .excellent),
                                 categories: [Category(title: "Software"), Category(title: "Computer")],
                                 attachments: [Attachment(thumbnail: originalImage,
                                                          imageData: .init(originalImage: originalImage))],
                                 comments: nil)

        // when: 테스트중인 코드 실행
        timeout(3) { exp in
            postRepository.create(newPost) { result in
                switch result {
                case .success(_):
                    // then: 예상한 결과 확인
                    self.postRepository.get(withIdentifier: newPost.identifier) { result in
                        exp.fulfill()
                        switch result {
                        case .success(let postEntity):
                            print(postEntity)
                            XCTAssertEqual(postEntity.title ?? "", newPost.title)
                        case .failure(let error):
                            XCTFail(error.localizedDescription)
                        }
                    }
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                }
            }
        }
    }

    func test_Post를_3개_만들_수_있다() {
        // given: 필요한 모든 값 설정
        deleteAllEntity()
        let newPosts: [Post] = dummyPost(3)

        // when: 테스트중인 코드 실행
        newPosts.forEach { post in
            create(post)
        }

        // then: 예상한 결과 확인
        timeout(3) { exp in
            postRepository.fetchAll { result in
                exp.fulfill()
                switch result {
                case .success(let postEntities):
                    XCTAssertEqual(3, postEntities.count)
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                }
            }
        }
    }

    func test_Post를_3개_만들고_3개의_Post를_가져올_수_있다() {
        // given: 필요한 모든 값 설정
        deleteAllEntity()
        let newPosts: [Post] = dummyPost(3)

        newPosts.forEach { post in
            create(post)
        }

        // when: 테스트중인 코드 실행
        timeout(3) { exp in
            postRepository.fetchAll { result in
                exp.fulfill()
                // then: 예상한 결과 확인
                switch result {
                case .success(let postEntities):
                    XCTAssertEqual(postEntities.count, newPosts.count)
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                }
            }
        }
    }

    func test_모든_Post를_삭제할_수_있다() {
        timeout(5) { exp in
            // when: 테스트중인 코드 실행
            postRepository.deleteAll { result in
                switch result {
                case .success(_):
                    // then: 예상한 결과 확인
                    self.postRepository.fetchAll { fetchResult in
                        exp.fulfill()
                        switch fetchResult {
                        case .success(let posts):
                            XCTAssertEqual(posts.count, 0)
                        case .failure(let error):
                            XCTFail(error.localizedDescription)
                        }
                    }
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                }
            }
        }
    }

    func test_특정_Post를_하나_가져올_수_있다() {
        // given: 필요한 모든 값 설정
        deleteAllEntity()
        guard let originalImage: UIImage = UIImage(systemName: "heart.fill") else {
            fatalError("Not Found system Image")
        }
        let newPost: Post = Post(title: "Find Post",
                                 price: 10_500,
                                 purchasePlace: "Market",
                                 contents: "Test Contents...",
                                 isLike: false,
                                 postType: .init(isDelete: false, type: .bought),
                                 rating: .init(score: .excellent),
                                 categories: [Category(title: "Software")],
                                 attachments: [Attachment(thumbnail: originalImage,
                                                          imageData: .init(originalImage: originalImage))],
                                 comments: nil)

        timeout(5) { exp in
            postRepository.create(newPost) { result in
                switch result {
                case .success(_):
                    // when: 테스트중인 코드 실행
                    self.postRepository.get(withIdentifier: newPost.identifier) { result in
                        exp.fulfill()
                        // then: 예상한 결과 확인
                        switch result {
                        case .success(let postEntity):
                            XCTAssertEqual(postEntity.title ?? "", newPost.title)
                        case .failure(let error):
                            XCTFail(error.localizedDescription)
                        }
                    }
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                }
            }
        }
    }

    func test_Post를_수정할_수_있다() {
        // given: 필요한 모든 값 설정
        deleteAllEntity()
        guard let originalImage: UIImage = UIImage(systemName: "heart.fill") else {
            fatalError("Not Found system Image")
        }
        let updateTitle: String = "Update Post"
        var newPost: Post = Post(title: "Test Post",
                                 price: 30_500,
                                 purchasePlace: "Market",
                                 contents: "Test Contents...",
                                 isLike: false,
                                 postType: .init(isDelete: false, type: .bought),
                                 rating: .init(score: .excellent),
                                 categories: [Category(title: "Software")],
                                 attachments: [Attachment(thumbnail: originalImage,
                                                          imageData: .init(originalImage: originalImage))],
                                 comments: nil)

        create(newPost)

        // when: 테스트중인 코드 실행
        timeout(15) { exp in
            newPost.title = updateTitle
            postRepository.update(newPost) { result in
                switch result {
                case .success(_):
                    // then: 예상한 결과 확인
                    self.postRepository.get(withIdentifier: newPost.identifier) { result in
                        exp.fulfill()
                        switch result {
                        case .success(let postEntity):
                            XCTAssertEqual(postEntity.title, updateTitle)
                        case .failure(let error):
                            XCTFail(error.localizedDescription)
                        }
                    }
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                }
            }
        }
    }

    func test_Post의_카테고리를_변경할_수_있다() {
        // given: 필요한 모든 값 설정
        deleteAllEntity()
        guard let originalImage: UIImage = UIImage(systemName: "heart.fill") else {
            fatalError("Not Found system Image")
        }
        var newPost: Post = Post(title: "Test Post",
                                 price: 30_500,
                                 purchasePlace: "Market",
                                 contents: "Test Contents...",
                                 isLike: false,
                                 postType: .init(isDelete: false, type: .bought),
                                 rating: .init(score: .excellent),
                                 categories: [Category(title: "Software")],
                                 attachments: [Attachment(thumbnail: originalImage,
                                                          imageData: .init(originalImage: originalImage))],
                                 comments: nil)
        let newCategory: ThingLog.Category = .init(title: "Hardware")
        create(newPost)
        newPost.categories = [newCategory]

        // when: 테스트중인 코드 실행
        timeout(10) { exp in
            postRepository.update(newPost) { result in
                switch result {
                case .success(_):
                    // then: 예상한 결과 확인
                    self.postRepository.get(withIdentifier: newPost.identifier) { result in
                        exp.fulfill()
                        switch result {
                        case .success(let postEntity):
                            if let categories: [CategoryEntity] = postEntity.categories?.allObjects as? [CategoryEntity],
                               let firstCategory: CategoryEntity = categories.first {
                                XCTAssertEqual(firstCategory.title ?? "", newCategory.title)
                            } else {
                                XCTFail("Not Found Categories")
                            }
                        case .failure(let error):
                            XCTFail(error.localizedDescription)
                        }
                    }
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                }
            }
        }
    }

    func test_Post의_카테고리를_삭제할_수_있다() {
        // given: 필요한 모든 값 설정
        deleteAllEntity()
        guard let originalImage: UIImage = UIImage(systemName: "heart.fill") else {
            fatalError("Not Found system Image")
        }
        var categories: [ThingLog.Category] = [
            .init(title: "Software"),
            .init(title: "Hardware"),
            .init(title: "Life")
        ]
        var newPost: Post = Post(title: "Test Post",
                                 price: 30_500,
                                 purchasePlace: "Market",
                                 contents: "Test Contents...",
                                 isLike: false,
                                 postType: .init(isDelete: false, type: .bought),
                                 rating: .init(score: .excellent),
                                 categories: categories,
                                 attachments: [Attachment(thumbnail: originalImage,
                                                          imageData: .init(originalImage: originalImage))],
                                 comments: nil)
        create(newPost)

        // when: 테스트중인 코드 실행
        categories.removeLast()
        newPost.categories = categories
        timeout(15) { exp in
            postRepository.update(newPost) { updateResult in
                switch updateResult {
                case .success(_):
                    self.postRepository.get(withIdentifier: newPost.identifier) { getResult in
                        exp.fulfill()
                        switch getResult {
                        case .success(let postEntity):
                            // then: 예상한 결과 확인
                            XCTAssertEqual(
                                (self.categoryRepository.fetchedResultsController.fetchedObjects?.count == 3),
                                (postEntity.categories?.count == newPost.categories.count))
                        case .failure(let error):
                            XCTFail(error.localizedDescription)
                        }
                    }
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                }
            }
        }
    }

    func test_PostType을_변경할_수_있다() {
        // given: 필요한 모든 값 설정
        clearAllCoreData()
        guard let originalImage: UIImage = UIImage(systemName: "heart.fill") else {
            fatalError("Not Found system Image")
        }
        var categories: [ThingLog.Category] = [
            .init(title: "Software"),
            .init(title: "Hardware"),
            .init(title: "Life")
        ]
        var newPost1: Post = Post(title: "Test Post",
                                 price: 30_500,
                                 purchasePlace: "Market",
                                 contents: "Test Contents...",
                                 isLike: false,
                                 postType: .init(isDelete: false, type: .bought),
                                 rating: .init(score: .excellent),
                                 categories: categories,
                                 attachments: [Attachment(thumbnail: originalImage,
                                                          imageData: .init(originalImage: originalImage))],
                                 comments: nil)
        var newPost2: Post = Post(title: "Test Post",
                                 price: 30_500,
                                 purchasePlace: "Market",
                                 contents: "Test Contents...",
                                 isLike: false,
                                 postType: .init(isDelete: false, type: .bought),
                                 rating: .init(score: .excellent),
                                 categories: categories,
                                 attachments: [Attachment(thumbnail: originalImage,
                                                          imageData: .init(originalImage: originalImage))],
                                 comments: nil)
        create(newPost1)
        create(newPost2)
        let context: NSManagedObjectContext = CoreDataStack.shared.mainContext
        lazy var fetchedResultsController: NSFetchedResultsController<PostTypeEntity> = {
            let fetchRequest: NSFetchRequest<PostTypeEntity> = PostTypeEntity.fetchRequest()
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "type", ascending: false)]

            let controller: NSFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                                    managedObjectContext: context,
                                                                                    sectionNameKeyPath: nil, cacheName: nil)
            do {
                try controller.performFetch()
            } catch {
                let nserror: NSError = error as NSError
                fatalError("###\(#function): Failed to performFetch: \(nserror), \(nserror.userInfo)")
            }
            return controller
        }()
        print("😎 before update : ", fetchedResultsController.fetchedObjects)

        // when: 테스트중인 코드 실행
        newPost1.postType = .init(isDelete: false, type: .gift)
        timeout(15) { exp in
            postRepository.update(newPost1) { updateResult in
                switch updateResult {
                case .success(_):
                    self.postRepository.get(withIdentifier: newPost1.identifier) { getResult in
                        exp.fulfill()
                        switch getResult {
                        case .success(let postEntity):
                            // then: 예상한 결과 확인
                            print("⚡️ \(fetchedResultsController.fetchedObjects)")
                            XCTAssertEqual(fetchedResultsController.fetchedObjects?.count == 2,
                                           postEntity.postType?.pageType == PageType.gift)
                            print("🥰", fetchedResultsController.fetchedObjects?.count)
                        case .failure(let error):
                            XCTFail(error.localizedDescription)
                        }
                    }
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                }
            }
        }
    }
}

extension ThingLogPostRepositoryTests {
    func create(_ newPost: Post) {
        timeout(3) { exp in
            postRepository.create(newPost) { result in
                exp.fulfill()
                switch result {
                case .success(_):
                    XCTAssert(true)
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                }
            }
        }
    }

    func deleteAllEntity() {
        timeout(10) { exp in
            postRepository.deleteAll { result in
                switch result {
                case .success(_):
                    self.categoryRepository.deleteAll { categoryResult in
                        exp.fulfill()
                        switch categoryResult {
                        case .success(_):
                            XCTAssert(true)
                        case .failure(let error):
                            XCTFail(error.localizedDescription)
                        }
                    }
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                }
            }
        }
    }

    func dummyPost(_ count: Int) -> [Post] {
        guard let originalImage: UIImage = UIImage(systemName: "heart.fill") else {
            fatalError("Not Found system Image")
        }

        let newPosts: [Post] = (1...count).map { i in
            let newPost: Post = Post(title: "Test Post \(i)",
                                     price: 500 * i,
                                     purchasePlace: "Market",
                                     contents: "Test Contents \(i)...",
                                     isLike: false,
                                     postType: .init(isDelete: false, type: .bought),
                                     rating: .init(score: .excellent),
                                     categories: [Category(title: "Software")],
                                     attachments: [Attachment(thumbnail: originalImage,
                                                              imageData: .init(originalImage: originalImage))],
                                     comments: nil)
            return newPost
        }
        return newPosts
    }
}

extension XCTestCase {
    func timeout(_ timeout: TimeInterval, completion: (XCTestExpectation) -> Void) {
        let exp = expectation(description: "Timeout: \(timeout) seconds")
        completion(exp)

        waitForExpectations(timeout: timeout) { error in
            guard let error = error else { return }
            XCTFail("Timeout error: \(error)")
        }
    }

    func clearAllCoreData() {
        let persistentContainer: NSPersistentContainer = {
            let container: NSPersistentContainer = NSPersistentContainer(name: "ThingLog")

            container.loadPersistentStores { _, error in
                if let error: NSError = error as NSError? {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            }
            return container
        }()
        let entities = persistentContainer.managedObjectModel.entities
        entities.compactMap({ $0.name }).forEach(clearDeepObjectEntity)
    }

    func clearDeepObjectEntity(_ entity: String) {
        let context = CoreDataStack.shared.mainContext

        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)

        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }
}
