//
//  ViewController.swift
//  ThingLog
//
//  Created by 이지원 on 2021/08/23.
//
import CoreData
import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

func makeDummy() {
    guard let originalImage: UIImage = UIImage(systemName: "heart.fill") else {
        fatalError("Not Found system Image")
    }
    let categoryList: [String] = ["문구", "가전", "화장품", "운동", "옷", "전자제품", "신발", "신발주머니", "띵로그", "여행"]
    let titleNameList: [String] = ["분더카머와 분더카머와 아이패드 아이들", "아이폰","맥북","아이폰11","아이패드프로","애플워치", "나이키신발", "아디다스신발"]
    let purchasePlaceList: [String] = ["강남","서울","경기","제주"]
    let postType: [PageType] = [.bought, .gift, .wish]
    
    let newPosts: [Post] = (1...400).map { idx in
        var categories = [Category.init(title: "")]
        categories.removeLast()
        for _ in 0...Int.random(in: 0..<categoryList.count) {
            categories.append(Category.init(title: categoryList[Int.random(in: 0..<categoryList.count)]))
        }
        let newPost: Post = Post(title: titleNameList.randomElement()!,
                                 price: 500 * idx,
                                 purchasePlace: purchasePlaceList.randomElement()!,
                                 contents: "Test Contents \(titleNameList.randomElement()!) 좋을 것 같기도 하고 아닐 것 같기도 하고 분더카머 분더카머 오늘도 하늘이 굉장히 푸르다. 내일도 날씨가 과연 좋을까? 11월안에 끝낼 수 있을까? 띵로그는 할 수 있다~!~! 더카머 분더카머 오늘도 하늘이 굉장히 푸르다. 내일도 날씨가 과연 좋을까? 11월안에 끝낼 수 있을까? 띵로그는 할 수 있다~!~! ",
                                 giftGiver: "현수",
                                 postType: .init(isDelete: false, type: postType.randomElement()!),
                                 rating: Rating(score: ScoreType(rawValue: Int16.random(in: 0..<5))!),
                                 categories: categories,
                                 attachments: [Attachment(thumbnail: originalImage,
                                                          imageData: .init(originalImage: originalImage))],
                                 comments: nil,
                                 isLike: [true,false].randomElement()!,
                                 createDate: Date().offset(idx, byAdding: .day)!)
        return newPost
    }.shuffled()
    
    let postRepository: PostRepository = PostRepository(fetchedResultsControllerDelegate: nil)
    var count = 0
    newPosts.forEach {
        postRepository.create($0) { result in
            switch result {
            case .success(_):
                count += 1
                print("성공: \(count)")
            case .failure(let error):
                print("fail")
            }
        }
    }
}

func deleteAllEntity() {
    let postRepository: PostRepository = PostRepository(fetchedResultsControllerDelegate: nil)
    let categoryRepository: CategoryRepository = CategoryRepository(fetchedResultsControllerDelegate: nil)
    postRepository.deleteAll { result in
        switch result {
        case .success(_):
            categoryRepository.deleteAll { categoryResult in
                switch categoryResult {
                case .success(_):
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

