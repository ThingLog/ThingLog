//
//  PostRepository.swift
//  ThingLog
//
//  Created by 이지원 on 2021/09/22.
//

import CoreData
import Foundation

protocol PostRepositoryProtocol {
    func create(_ newPost: Post)
}

final class PostRepository: PostRepositoryProtocol {
    private let coreDataStack: CoreDataStack

    init(coreDataStack: CoreDataStack = CoreDataStack.shared) {
        self.coreDataStack = coreDataStack
    }

    func create(_ newPost: Post) {
        coreDataStack.performBackgroundTask { context in
            do {
                let post: PostEntity = newPost.toEntity(in: context)
                try context.save()
            } catch {
                fatalError("PostRepository Unresolved error \(error)")
            }
        }
    }
}
