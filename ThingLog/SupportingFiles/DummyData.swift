//
//  DummyData.swift
//  ThingLog
//
//  Created by 이지원 on 2021/10/16.
//

import CoreData
import UIKit.UIImage

func makeDummy() {
    guard let originalImage: UIImage = UIImage(systemName: "heart.fill") else {
        fatalError("Not Found system Image")
    }
    let categoryList: [String] = ["문구", "가전", "화장품", "운동", "옷", "전자제품", "신발", "띵로그", "여행"]
    let titleNameList: [String] = ["아이폰", "맥북", "아이폰11", "아이패드프로", "애플워치"]
    let purchasePlaceList: [String] = ["강남", "서울", "경기", "제주"]
    let postType: [PageType] = [.bought, .gift, .wish]

    let newPosts: [Post] = (1...400).map { idx in
        var categories: [Category] = [Category.init(title: "")]
        categories.removeLast()
        categories.append(Category.init(title: categoryList[Int.random(in: 0..<categoryList.count)]))
        let newPost: Post = Post(title: titleNameList.randomElement()!,
                                 price: 500 * idx,
                                 purchasePlace: purchasePlaceList.randomElement()!,
                                 contents: "Test Contents \(titleNameList.randomElement()!)...",
                                 giftGiver: "현수",
                                 postType: .init(isDelete: false, type: postType.randomElement()!),
                                 rating: Rating(score: ScoreType(rawValue: Int16.random(in: 0..<5))!),
                                 categories: categories,
                                 attachments: [Attachment(thumbnail: originalImage,
                                                          imageData: .init(originalImage: originalImage))],
                                 comments: nil,
                                 isLike: [true, false].randomElement()!,
                                 createDate: Date().offset(idx, byAdding: .day)!)
        return newPost
    }.shuffled()

    let postRepository: PostRepository = PostRepository(fetchedResultsControllerDelegate: nil)
    var count: Int = 0
    newPosts.forEach {
        postRepository.create($0) { result in
            switch result {
            case .success:
                count += 1
                print("성공: \(count)")
            case .failure(let error):
                print("fail: \(error.localizedDescription)")
            }
        }
    }
}

func deleteAllEntity() {
    let postRepository: PostRepository = PostRepository(fetchedResultsControllerDelegate: nil)
    let categoryRepository: CategoryRepository = CategoryRepository(fetchedResultsControllerDelegate: nil)
    postRepository.deleteAll { result in
        switch result {
        case .success:
            categoryRepository.deleteAll { categoryResult in
                switch categoryResult {
                case .success:
                    print("삭제성공")
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
}
