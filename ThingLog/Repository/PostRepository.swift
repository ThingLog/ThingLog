//
//  PostRepository.swift
//  ThingLog
//
//  Created by 이지원 on 2021/09/22.
//

import CoreData
import Foundation

protocol PostRepositoryProtocol {
    func create(_ newPost: Post, completion: @escaping (Result<Bool, RepositoryError>) -> Void)
    func update(_ updatePost: Post, completion: @escaping (Result<Bool, RepositoryError>) -> Void)
    func get(withIdentifier identifier: UUID, completion: @escaping (Result<PostEntity, RepositoryError>) -> Void)
    func fetchAll(completion: @escaping (Result<[PostEntity], RepositoryError>) -> Void)
    func deleteAll(completion: @escaping (Result<Bool, RepositoryError>) -> Void)
}

final class PostRepository: PostRepositoryProtocol {
    private let coreDataStack: CoreDataStack
    private weak var fetchedResultsControllerDelegate: NSFetchedResultsControllerDelegate?
    
    /// 홈에서 PostType별로 갖고 오기 위해 필요한 프로퍼티다
    var pageType: PageType?
    
    /// 홈에서 PostType별로 갖고 오기 위한 fetchRequest다
    var fetchRequestByPageType: NSFetchRequest<PostEntity>? {
        let request: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
        request.predicate = NSPredicate(format: "postType.type == %d", pageType?.rawValue ?? 0)
        request.sortDescriptors = [NSSortDescriptor(key: "createDate", ascending: false)]
        return request
    }

    init(fetchedResultsControllerDelegate: NSFetchedResultsControllerDelegate?,
        coreDataStack: CoreDataStack = CoreDataStack.shared) {
        self.fetchedResultsControllerDelegate = fetchedResultsControllerDelegate
        self.coreDataStack = coreDataStack
    }

    lazy var fetchedResultsController: NSFetchedResultsController<PostEntity> = {
        var fetchRequest: NSFetchRequest<PostEntity>
        if let request = fetchRequestByPageType {
           fetchRequest = request
        } else {
            fetchRequest = PostEntity.fetchRequest()
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: false)]
        }
        
        let controller: NSFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                                managedObjectContext: coreDataStack.mainContext,
                                                                                sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = fetchedResultsControllerDelegate

        do {
            try controller.performFetch()
        } catch {
            let nserror: NSError = error as NSError
            fatalError("###\(#function): Failed to performFetch: \(nserror), \(nserror.userInfo)")
        }
        return controller
    }()

    /// PostEntity를 새로 추가한다.
    /// - Parameters:
    ///   - newPost: PostEntity의 속성을 담은 모델 객체
    ///   - completion: 결과를 클로저 형태로 반환한다. 성공했을 경우 무조건 true를 반환하며, 실패했을 경우 PostRepositoryError 타입을 반환한다.
    func create(_ newPost: Post, completion: @escaping (Result<Bool, RepositoryError>) -> Void) {
        let context: NSManagedObjectContext = coreDataStack.mainContext
        context.perform {
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
    func update(_ updatePost: Post, completion: @escaping (Result<Bool, RepositoryError>) -> Void) {
        get(withIdentifier: updatePost.identifier) { result in
            switch result {
            case .success(let postEntity):
                let context: NSManagedObjectContext = self.coreDataStack.mainContext
                context.perform {
                    do {
                        postEntity.update(with: updatePost, in: context)
                        try context.save()
                        completion(.success(true))
                    } catch {
                        completion(.failure(.failedUpdate))
                    }
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
    func get(withIdentifier identifier: UUID, completion: @escaping (Result<PostEntity, RepositoryError>) -> Void) {
        let context: NSManagedObjectContext = coreDataStack.mainContext
        let request: NSFetchRequest = PostEntity.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "identifier == %@", identifier as CVarArg)

        context.perform {
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
    func fetchAll(completion: @escaping (Result<[PostEntity], RepositoryError>) -> Void) {
        let context: NSManagedObjectContext = coreDataStack.mainContext
        let request: NSFetchRequest = PostEntity.fetchRequest()
        context.perform {
            do {
                let result: [PostEntity] = try request.execute()
                completion(.success(result))
            } catch {
                completion(.failure(.failedFetch))
            }
        }
    }

    /// indexPath에 해당하는 PostEntity를 삭제한다.
    /// - Parameter indexPath: UITableView 혹은 UICollectionView에서 삭제하려는 PostEntity의 indexPath를 받는다.
    func delete(at indexPath: IndexPath) {
        let context: NSManagedObjectContext = fetchedResultsController.managedObjectContext
        context.perform {
            context.delete(self.fetchedResultsController.object(at: indexPath))
            do {
                try context.save()
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }

    /// Core Data에 저장된 모든 PostEntity를 삭제한다.
    /// - Parameter completion: 결과를 클로저 형태로 반환한다. 성공했을 경우 true를 반환하며, 실패했을 경우 PostRepositoryError 타입을 반환한다.
    func deleteAll(completion: @escaping (Result<Bool, RepositoryError>) -> Void) {
        let context: NSManagedObjectContext = coreDataStack.mainContext
        context.perform {
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
