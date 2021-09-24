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

class ThingLogRepositoryTests: XCTestCase {
    let postRepository: PostRepository = PostRepository()

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
        guard let originalImage: UIImage = UIImage(systemName: "heart.fill") else {
            fatalError("Not Found system Image")
        }
        let newPost: Post = Post(title: "Test Post",
                                 price: 30_500,
                                 purchasePlace: "Market",
                                 contents: "Test Contents...",
                                 isLike: false,
                                 type: .init(isDelete: false, type: .bought),
                                 rating: .init(score: .excellent),
                                 categories: [Category(title: "Software")],
                                 attachments: [Attachment(thumbnail: originalImage,
                                                          imageData: .init(blob: originalImage))],
                                 comments: nil)

        // when: 테스트중인 코드 실행
        timeout(3) { exp in
            postRepository.create(newPost) { result in
                switch result {
                case .success(_):
                    break
                case .failure(let error):
                    fatalError(error.localizedDescription)
                }
            }

            // then: 예상한 결과 확인
            postRepository.fetchAll { result in
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

    func test_Post를_3개_만들_수_있다() {
        // given: 필요한 모든 값 설정
        guard let originalImage: UIImage = UIImage(systemName: "heart.fill") else {
            fatalError("Not Found system Image")
        }
        let newPosts: [Post] = (1...3).map { i in
            let newPost: Post = Post(title: "Test Post \(i)",
                                     price: 500 * i,
                                     purchasePlace: "Market",
                                     contents: "Test Contents \(i)...",
                                     isLike: false,
                                     type: .init(isDelete: false, type: .bought),
                                     rating: .init(score: .excellent),
                                     categories: [Category(title: "Software")],
                                     attachments: [Attachment(thumbnail: originalImage,
                                                              imageData: .init(blob: originalImage))],
                                     comments: nil)
            return newPost
        }

        // when: 테스트중인 코드 실행
        newPosts.forEach { post in
            postRepository.create(post) { result in
                // then: 예상한 결과 확인
                switch result {
                case .success(_):
                    XCTAssertTrue(true)
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
                    exp.fulfill()
                case .failure(let error):
                    fatalError(error.localizedDescription)
                }
            }

            // then: 예상한 결과 확인
            postRepository.fetchAll { fetchResult in
                switch fetchResult {
                case .success(let posts):
                    XCTAssertEqual(posts.count, 0)
                case .failure(let error):
                    fatalError(error.localizedDescription)
                }
            }
        }
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
