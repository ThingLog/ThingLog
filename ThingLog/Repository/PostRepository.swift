//
//  PostRepository.swift
//  ThingLog
//
//  Created by 이지원 on 2021/09/22.
//

import CoreData
import Foundation
import UIKit

protocol PostRepositoryProtocol {
    func create(_ newPost: Post, completion: @escaping (Result<Bool, Error>) -> Void)
    func update(_ updatePost: Post, completion: @escaping (Result<Bool, Error>) -> Void)
    func get(withIdentifier identifier: UUID, completion: @escaping (Result<PostEntity, Error>) -> Void)
    func fetchAll(completion: @escaping (Result<[PostEntity], Error>) -> Void)
    func deleteAll(completion: @escaping (Result<Bool, Error>) -> Void)
}

enum PostRepositoryError: Error {
    case notFound
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

    func update(_ updatePost: Post, completion: @escaping (Result<Bool, Error>) -> Void) {
        coreDataStack.performBackgroundTask { context in
            do {
                let request: NSFetchRequest = PostEntity.fetchRequest()
                request.fetchLimit = 1
                request.predicate = NSPredicate(format: "identifier == %@", updatePost.identifier as CVarArg)
                guard let result: PostEntity = try context.fetch(request).first else {
                    completion(.failure(PostRepositoryError.notFound))
                    return
                }
                result.update(with: updatePost, in: context)
                try context.save()
                completion(.success(true))
            } catch {
                completion(.failure(PostRepositoryError.notFound))
            }
        }
    }

    func get(withIdentifier identifier: UUID, completion: @escaping (Result<PostEntity, Error>) -> Void) {
        coreDataStack.performBackgroundTask { context in
            do {
                let request: NSFetchRequest = PostEntity.fetchRequest()
                request.fetchLimit = 1
                request.predicate = NSPredicate(format: "identifier == %@", identifier as CVarArg)
                guard let result: PostEntity = try context.fetch(request).first else {
                    completion(.failure(PostRepositoryError.notFound))
                    return
                }
                completion(.success(result))
            } catch {
                completion(.failure(PostRepositoryError.notFound))
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
