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
    func create(_ newPost: Post, completion: @escaping (Result<Bool, PostRepositoryError>) -> Void)
    func update(_ updatePost: Post, completion: @escaping (Result<Bool, PostRepositoryError>) -> Void)
    func get(withIdentifier identifier: UUID, completion: @escaping (Result<PostEntity, PostRepositoryError>) -> Void)
    func fetchAll(completion: @escaping (Result<[PostEntity], PostRepositoryError>) -> Void)
    func fetchAllCategory(completion: @escaping (Result<[Category], PostRepositoryError>) -> Void)
    func deleteAll(completion: @escaping (Result<Bool, PostRepositoryError>) -> Void)
}

final class PostRepository: PostRepositoryProtocol {
    private let coreDataStack: CoreDataStack

    init(coreDataStack: CoreDataStack = CoreDataStack.shared) {
        self.coreDataStack = coreDataStack
    }

    /// PostEntity를 새로 추가한다.
    /// - Parameters:
    ///   - newPost: PostEntity의 속성을 담은 모델 객체
    ///   - completion: 결과를 클로저 형태로 반환한다. 성공했을 경우 무조건 true를 반환하며, 실패했을 경우 PostRepositoryError 타입을 반환한다.
    func create(_ newPost: Post, completion: @escaping (Result<Bool, PostRepositoryError>) -> Void) {
        coreDataStack.performBackgroundTask { context in
            do {
                let post: PostEntity = newPost.toEntity(in: context)
                try context.save()
                completion(.success(true))
            } catch {
                completion(.failure(.failedCreate))
            }
        }
    }

    /// PostEntity의 속성을 변경한다.
    /// - Parameters:
    ///   - updatePost: PostEntity의 속성을 담은 모델 객체, identifier 속성을 통해 PostEntity를 가져오고 변경 사항을 반영한다.
    ///   - completion: 결과를 클로저 형태로 반환한다. 성공했을 경우 무조건 true를 반환하며, 실패했을 경우 PostRepositoryError 타입을 반환한다.
    func update(_ updatePost: Post, completion: @escaping (Result<Bool, PostRepositoryError>) -> Void) {
        get(withIdentifier: updatePost.identifier) { result in
            switch result {
            case .success(let postEntity):
                guard let context: NSManagedObjectContext = postEntity.managedObjectContext else {
                    completion(.failure(.notFoundContext))
                    return
                }

                do {
                    postEntity.update(with: updatePost, in: context)
                    try context.save()
                    completion(.success(true))
                } catch {
                    completion(.failure(.failedUpdate))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    /// identifier 속성을 이용해 PostEntity 객체를 한 개 가져온다.
    /// - Parameters:
    ///   - identifier: PostEntity를 찾기 위한 UUID 속성
    ///   - completion: 결과를 클로저 형태로 반환한다. 성공했을 경우 PostEntity를 반환하며, 실패했을 경우 PostRepositoryError 타입을 반환한다.
    func get(withIdentifier identifier: UUID, completion: @escaping (Result<PostEntity, PostRepositoryError>) -> Void) {
        let request: NSFetchRequest = PostEntity.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "identifier == %@", identifier as CVarArg)

        coreDataStack.mainContext.perform {
            do {
                guard let result: PostEntity = try request.execute().first else {
                    completion(.failure(.notFoundEntity))
                    return
                }
                completion(.success(result))
            } catch {
                completion(.failure(.notFoundEntity))
            }
        }
    }

    /// 모든 PostEntity를 가져와서 반환한다.
    /// - Parameter completion: 결과를 클로저 형태로 반환한다. 성공했을 경우 [PostEntity]를 반환하며, 실패했을 경우 PostRepositoryError 타입을 반환한다.
    func fetchAll(completion: @escaping (Result<[PostEntity], PostRepositoryError>) -> Void) {
        let request: NSFetchRequest = PostEntity.fetchRequest()
        coreDataStack.mainContext.perform {
            do {
                let result: [PostEntity] = try request.execute()
                completion(.success(result))
            } catch {
                completion(.failure(.failedFetch))
            }
        }
    }

    func fetchAllCategory(completion: @escaping (Result<[Category], PostRepositoryError>) -> Void) {
        let request: NSFetchRequest = CategoryEntity.fetchRequest()
        coreDataStack.mainContext.perform {
            do {
                let result: [CategoryEntity] = try request.execute()
                let categories: [Category] = result.map { $0.toModel() }
                completion(.success(categories))
            } catch {
                completion(.failure(.failedFetch))
            }
        }
    }

    /// Core Data에 저장된 모든 PostEntity를 삭제한다.
    /// - Parameter completion: 결과를 클로저 형태로 반환한다. 성공했을 경우 true를 반환하며, 실패했을 경우 PostRepositoryError 타입을 반환한다.
    func deleteAll(completion: @escaping (Result<Bool, PostRepositoryError>) -> Void) {
        coreDataStack.performBackgroundTask { context in
            do {
                let request: NSFetchRequest = PostEntity.fetchRequest()
                let result: [PostEntity] = try context.fetch(request)
                result.forEach { context.delete($0) }
                try context.save()
                completion(.success(true))
            } catch {
                completion(.failure(.failedDelete))
            }
        }
    }
}
