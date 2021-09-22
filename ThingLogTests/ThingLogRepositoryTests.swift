//
//  ThingLogRepositoryTests.swift
//  ThingLogTests
//
//  Created by 이지원 on 2021/09/22.
//

import XCTest
@testable import ThingLog

class ThingLogRepositoryTests: XCTestCase {
    func test_Post를_하나_만들_수_있다() {
        let postRepository: PostRepository = PostRepository()
        let newPost: Post = Post(title: "Test Post",
                                 price: 30_500,
                                 purchasePlace: "Market",
                                 purchaseDate: Date(),
                                 contents: "Test Contents...")
        postRepository.create(newPost)
        XCTAssertEqual(postRepository.count, 1)
    }
}
