//
//  PostRepository.swift
//  ThingLog
//
//  Created by 이지원 on 2021/09/22.
//

import CoreData
import Foundation

protocol PostRepositoryProtocol {
    func create(_ newPost: Post, completion: @escaping (Result<Bool, Error>) -> Void)
    func fetchAll(completion: @escaping (Result<[PostEntity], Error>) -> Void)
    func deleteAll(completion: @escaping (Result<Bool, Error>) -> Void)
}

final class PostRepository: PostRepositoryProtocol {
    private let coreDataStack: CoreDataStack

    init(coreDataStack: CoreDataStack = CoreDataStack.shared) {
        self.coreDataStack = coreDataStack
    }

    func create(_ newPost: Post, completion: @escaping (Result<Bool, Error>) -> Void) {
        coreDataStack.performBackgroundTask { context in
            do {
                let post: PostEntity = newPost.toEntity(in: context)
                try context.save()
                completion(.success(true))
            } catch {
                fatalError("PostRepository Unresolved error \(error)")
            }
        }
    }

    func fetchAll(completion: @escaping (Result<[PostEntity], Error>) -> Void) {
        coreDataStack.performBackgroundTask { context in
            do {
                let request: NSFetchRequest = PostEntity.fetchRequest()
                let result: [PostEntity] = try context.fetch(request)
                completion(.success(result))
            } catch {
                fatalError("PostRepository Unresolved error \(error)")
            }
        }
    }

    func deleteAll(completion: @escaping (Result<Bool, Error>) -> Void) {
        coreDataStack.performBackgroundTask { context in
            do {
                let request: NSFetchRequest = PostEntity.fetchRequest()
                let result: [PostEntity] = try context.fetch(request)
                result.forEach { context.delete($0) }
                try context.save()
                completion(.success(true))
            } catch {
                fatalError("PostRepository Unresolved error \(error)")
            }
        }
    }
}
