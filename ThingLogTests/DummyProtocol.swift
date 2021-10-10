//
//  DummyProtocol.swift
//  ThingLogTests
//
//  Created by hyunsu on 2021/10/07.
//

import Foundation
@testable import ThingLog
import CoreData
import XCTest

/// 더미 Post데이터를 만들기 위한 프로토콜이다.
protocol DummyProtocol where Self: XCTestCase {
    var postRepository: PostRepository { get set }
    var categoryRepository: CategoryRepository { get set }
    
    func dummyPost(_ count: Int) -> [Post]
    func deleteAllEntity()
    func create(_ newPost: Post)
}

extension DummyProtocol {
    func dummyPost(_ count: Int) -> [Post] {
        guard let originalImage: UIImage = UIImage(systemName: "heart.fill") else {
            fatalError("Not Found system Image")
        }
        let categoryList: [String] = ["문구", "가전", "화장품", "운동", "옷"]
        let titleNameList: [String] = ["아이폰","맥북","아이폰11","아이패드프로","애플워치"]
        let purchasePlaceList: [String] = ["강남","서울","경기","제주"]
        
        
        let newPosts: [Post] = (1...count).map { i in
            var categories = [Category.init(title: "")]
            categories.removeLast()
            for _ in 0...Int.random(in: 0..<categoryList.count) {
                categories.append(Category.init(title: categoryList[Int.random(in: 0..<categoryList.count)]))
            }
            let newPost: Post = Post(title: titleNameList.randomElement()!,
                                     price: 500 * i,
                                     purchasePlace: purchasePlaceList.randomElement()!,
                                     contents: "Test Contents \(titleNameList.randomElement()!)...",
                                     giftGiver: "현수",
                                     postType: .init(isDelete: false, type: .bought),
                                     rating: Rating(score: ScoreType(rawValue: Int16.random(in: 0..<5))!),
                                     categories: categories,
                                     attachments: [Attachment(thumbnail: originalImage,
                                                              imageData: .init(originalImage: originalImage))],
                                     comments: nil,
                                     isLike: [true,false].randomElement()!,
                                     createDate: Date().offset(i, byAdding: .day)!)
            return newPost
        }.shuffled()
        return newPosts
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
}
