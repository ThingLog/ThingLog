//
//  ThingLogRepositoryTests.swift
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

class ThingLogRepositoryTests: XCTestCase {
    let postRepository: PostRepository = PostRepository()
    let categoryRepository: CategoryRepository = CategoryRepository(fetchedResultsControllerDelegate: nil)

    override func tearDown() {
        postRepository.deleteAll { result in
            switch result {
            case .success(_):
                break
            case .failure(let error):
                fatalError(error.localizedDescription)
            }
        }
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
                    self.postRepository.fetchAll { result in
                        switch result {
                        case .success(let postEntities):
                            XCTAssertEqual(postEntities.count, 1)
                            exp.fulfill()
                        case .failure(let error):
                            XCTAssertTrue(false)
                            fatalError(error.localizedDescription)
                        }
                    }
                case .failure(let error):
                    fatalError(error.localizedDescription)
                }
            }
        }
    }

    func test_Post를_3개_만들_수_있다() {
        // given: 필요한 모든 값 설정
        deleteAllEntity()
        guard let originalImage: UIImage = UIImage(systemName: "heart.fill") else {
            fatalError("Not Found system Image")
        }
        let newPosts: [Post] = (1...3).map { i in
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
        var postCount: Int = 0

        // when: 테스트중인 코드 실행
        timeout(10) { exp in
            newPosts.forEach { post in
                postRepository.create(post) { result in
                    switch result {
                    case .success(_):
                        postCount += 1
                    case .failure(let error):
                        XCTAssertTrue(false)
                        fatalError(error.localizedDescription)
                    }
                }
            }
            exp.fulfill()
        }

        // then: 예상한 결과 확인
        timeout(3) { exp in
            postRepository.fetchAll { result in
                switch result {
                case .success(let postEntities):
                    XCTAssertEqual(postCount, postEntities.count)
                    exp.fulfill()
                case .failure(let error):
                    XCTAssertTrue(false)
                    fatalError(error.localizedDescription)
                }
            }
        }
    }

    func test_모든_Post를_가져올_수_있다() {
        timeout(3) { exp in
            // when: 테스트중인 코드 실행
            postRepository.fetchAll { result in
                // then: 예상한 결과 확인
                switch result {
                case .success(_):
                    XCTAssertTrue(true)
                    exp.fulfill()
                case .failure(let error):
                    XCTAssertTrue(false)
                    fatalError(error.localizedDescription)
                }
            }
        }
    }

    func test_모든_Post를_삭제할_수_있다() {
        timeout(3) { exp in
            // when: 테스트중인 코드 실행
            postRepository.deleteAll { result in
                switch result {
                case .success(_):
                    // then: 예상한 결과 확인
                    self.postRepository.fetchAll { fetchResult in
                        switch fetchResult {
                        case .success(let posts):
                            XCTAssertEqual(posts.count, 0)
                            exp.fulfill()
                        case .failure(let error):
                            fatalError(error.localizedDescription)
                        }
                    }
                case .failure(let error):
                    fatalError(error.localizedDescription)
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
                        // then: 예상한 결과 확인
                        switch result {
                        case .success(let postEntity):
                            XCTAssertEqual(postEntity.title ?? "", newPost.title)
                        case .failure(let error):
                            fatalError(error.localizedDescription)
                        }
                    }
                case .failure(let error):
                    fatalError(error.localizedDescription)
                }
            }
            exp.fulfill()
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

        timeout(15) { exp in
            postRepository.create(newPost) { result in
                switch result {
                case .success(_):
                    newPost.title = updateTitle
                    // when: 테스트중인 코드 실행
                    self.postRepository.update(newPost) { result in
                        switch result {
                        case .success(_):
                            // then: 예상한 결과 확인
                            self.postRepository.get(withIdentifier: newPost.identifier) { result in
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
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                }
            }
            exp.fulfill()
        }
    }

    func test_Category를_하나_추가할_수_있다() {
        // given: 필요한 모든 값 설정
        deleteAllEntity()
        let newCategory: ThingLog.Category = Category.init(title: "학용품")

        // when: 테스트중인 코드 실행
        categoryRepository.create(newCategory) { result in
            switch result {
            case .success(_):
                // then: 예상한 결과 확인
                XCTAssertEqual(self.categoryRepository.fetchedResultsController.fetchedObjects?.count ?? 1, 1)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    func test_중복된_Category가_있는지_알_수_있다() {
        // given: 필요한 모든 값 설정
        deleteAllEntity()
        let duplicate: String = "컴퓨터"
        let newCategory: ThingLog.Category = Category.init(title: duplicate)

        timeout(3) { exp in
            categoryRepository.create(newCategory) { result in
                switch result {
                case .success(_):
                    // when: 테스트중인 코드 실행
                    self.categoryRepository.find(with: duplicate) { isFind, _ in
                        // then: 예상한 결과 확인
                        XCTAssertTrue(isFind)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            exp.fulfill()
        }
    }

    func test_모든_Category를_가져올_수_있다() {
        // given: 필요한 모든 값 설정
        deleteAllEntity()
        let newCategories: [ThingLog.Category] = (1...3).map { i in
            let newCategory: ThingLog.Category = .init(title: "학용품 \(i)")
            return newCategory
        }

        // when: 테스트중인 코드 실행
        timeout(5) { exp in
            newCategories.forEach { newCategory in
                categoryRepository.create(newCategory) { result in
                    switch result {
                    case .success(_):
                        print("success")
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
            exp.fulfill()
        }

        // then: 예상한 결과 확인
        XCTAssertEqual(categoryRepository.fetchedResultsController.fetchedObjects?.count, newCategories.count)
    }

    func test_모든_Category를_삭제할_수_있다() {
        timeout(5) { exp in
            categoryRepository.deleteAll { result in
                switch result {
                case .success(_):
                    XCTAssertEqual(self.categoryRepository.fetchedResultsController.fetchedObjects?.count ?? 0, 0)
                    exp.fulfill()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}

extension ThingLogRepositoryTests {
    func deleteAllEntity() {
        categoryRepository.deleteAll { _ in }
        postRepository.deleteAll { _ in }
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
}
