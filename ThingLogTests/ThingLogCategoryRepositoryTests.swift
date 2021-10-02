//
//  ThingLogCategoryRepositoryTests.swift
//  ThingLogTests
//
//  Created by 이지원 on 2021/09/30.
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

class ThingLogCategoryRepositoryTests: XCTestCase {
    let categoryRepository: CategoryRepository = CategoryRepository(fetchedResultsControllerDelegate: nil)

    override func tearDownWithError() throws {
        deleteAllEntity()
    }

    func test_Category를_하나_추가할_수_있다() {
        // given: 필요한 모든 값 설정
        deleteAllEntity()
        let newCategory: ThingLog.Category = Category.init(title: "학용품")

        // when: 테스트중인 코드 실행
        timeout(3) { exp in
            categoryRepository.create(newCategory) { result in
                exp.fulfill()
                switch result {
                case .success(_):
                    // then: 예상한 결과 확인
                    XCTAssertEqual(self.categoryRepository.fetchedResultsController.fetchedObjects?.count ?? 1, 1)
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                }
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
                        exp.fulfill()
                        // then: 예상한 결과 확인
                        XCTAssertTrue(isFind)
                    }
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                }
            }
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
        newCategories.forEach { newCategory in
            create(newCategory)
        }

        // then: 예상한 결과 확인
        XCTAssertEqual(categoryRepository.fetchedResultsController.fetchedObjects?.count, newCategories.count)
    }

    func test_모든_Category를_삭제할_수_있다() {
        timeout(5) { exp in
            categoryRepository.deleteAll { result in
                exp.fulfill()
                switch result {
                case .success(_):
                    XCTAssertEqual(self.categoryRepository.fetchedResultsController.fetchedObjects?.count ?? 0, 0)
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                }
            }
        }
    }
}

extension ThingLogCategoryRepositoryTests {
    func create(_ newCategory: ThingLog.Category) {
        timeout(3) { exp in
            categoryRepository.create(newCategory) { result in
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
            categoryRepository.deleteAll { result in
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
}
