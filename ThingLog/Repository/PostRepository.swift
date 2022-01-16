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
    
    /// 휴지통에 있는 데이터들이 30일 이상된 데이터들을 삭제하도록 한다.
    func checkTrashData(completion: ((Result<Bool, RepositoryError>) -> Void)?)
    
    /// 휴지통에 있는 특정 데이터를 복구한다.
    func recover(_ trashPosts: [PostEntity], completion: @escaping (Result<Bool, RepositoryError>) -> Void)
    
    /// PostEntity배열들을 삭제하도록 한다.
    func delete(_ posts: [PostEntity], completion: @escaping (Result<Bool, RepositoryError>) -> Void)
}

final class PostRepository: PostRepositoryProtocol {
    private let coreDataStack: CoreDataStack
    private weak var fetchedResultsControllerDelegate: NSFetchedResultsControllerDelegate?
    private lazy var drawerRepository: DrawerRepositoryable = DrawerCoreDataRepository(coreDataStack: coreDataStack)
    
    /// 휴지통에서나, 홈화면 등에서 fetchResultsController를 사용하고자 할 때, 타입을 지정하여 간단하게 가져오기 위한 타입이다.
    enum RequestType {
        case fromHome
        case fromTrash
        case fromTitleSorting
    }
    /// 홈에서 PostType별로 갖고 오기 위해 필요한 프로퍼티다
    var pageType: PageType?
    
    init(fetchedResultsControllerDelegate: NSFetchedResultsControllerDelegate?,
         coreDataStack: CoreDataStack = CoreDataStack.shared) {
        self.fetchedResultsControllerDelegate = fetchedResultsControllerDelegate
        self.coreDataStack = coreDataStack
    }
    
    lazy var fetchedResultsController: NSFetchedResultsController<PostEntity> = {
        var fetchRequest: NSFetchRequest<PostEntity>
        fetchRequest = PostEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: false)]
        
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
    
    /// RequestType별로 해당하는 FetchedResultsController를 반환한다.
    /// - Parameter requestType: 홈에서 가져올지, 휴지통에서 가져올지, 그외인 경우를 지정한다.
    /// - Returns: 데이터를 가져온 ResultsController를 반환한다.
    func fetchResultsController(by requestType: RequestType) -> NSFetchedResultsController<PostEntity> {
        let fetchRequest: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
        let minDate: Date = Date().offset(-29, byAdding: .day) ?? Date()
        switch requestType {
        case .fromHome:
            fetchRequest.predicate = NSPredicate(format: "postType.isDelete == false AND postType.type == %d", pageType?.rawValue ?? 0)
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createDate", ascending: false)]
        case .fromTrash:
            fetchRequest.predicate = NSPredicate(format: "postType.isDelete == true AND deleteDate > %@ AND deleteDate <= %@", minDate as NSDate, Date() as NSDate )
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "deleteDate", ascending: true)]
        case .fromTitleSorting:
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
    }
    
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
                
                // 진열장 아이템 조건 ( VIP, 드래곤볼 )
                if newPost.postType.type == .bought {
                    self.updateVIP()
                }
                self.drawerRepository.updateDragonBall(rating: newPost.rating.score.rawValue)
                
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
                        
                        // 진열장 아이템 조건 ( 드래곤볼 )
                        self.drawerRepository.updateDragonBall(rating: updatePost.rating.score.rawValue)
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

    /// PostEntity의 속성을 변경한다.
    /// - Parameters:
    ///   - updatePost: PostEntity의 속성을 담은 모델 객체, identifier 속성을 통해 PostEntity를 가져오고 변경 사항을 반영한다.
    ///   - completion: 결과를 클로저 형태로 반환한다. 성공했을 경우 무조건 true를 반환하며, 실패했을 경우 PostRepositoryError 타입을 반환한다.
    func update(_ updateEntity: PostEntity, completion: @escaping (Result<Bool, RepositoryError>) -> Void) {
        let context: NSManagedObjectContext = coreDataStack.mainContext
        context.performAndWait {
            do {
                // 진열장 아이템 조건 ( 드래곤볼, VIP )
                if updateEntity.postType?.pageType == .bought {
                    self.updateVIP()
                }
                self.drawerRepository.updateDragonBall(rating: updateEntity.rating?.scoreType.rawValue ?? 0)
                try context.save()

                completion(.success(true))
            } catch {
                completion(.failure(.failedUpdate))
            }
        }
    }
    
    /// 이미 VIP를 획득했다면 종료한다.
    /// VIP를 획득하지 않았다면, 샀다 게시물의 모든 가격의 합을 구한 뒤, drawerRepository.updateVIP를 호출한다.
    private func updateVIP() {
        let defaultDrawerModel: DefaultDrawerModel = DefaultDrawerModel()
        if let blackCard: Drawerable = defaultDrawerModel.drawers.first(where: { $0.imageName == SwiftGenDrawerList.blackCard.imageName }) {
            drawerRepository.hasItem(for: blackCard) { [weak self] isAcquired in
                if isAcquired { return }
                self?.getSumAllPriceofBought { price in
                    self?.drawerRepository.updateVIP(by: price)
                }
            }
        }
    }
    
    /// 모든 샀다 게시물의 가격 합을 구한다.
    private func getSumAllPriceofBought(_ completion: @escaping (Int) -> Void) {
        let context: NSManagedObjectContext = coreDataStack.mainContext
        let request: NSFetchRequest = PostEntity.fetchRequest()
        request.predicate = NSPredicate(format: "postType.isDelete == false AND postType.type == %d", PageType.bought.rawValue)
        
        context.perform {
            do {
                let result: [PostEntity] = try request.execute()
                let sum: Int = result.compactMap { Int($0.price) }.reduce(0, +)
                completion(sum)
            } catch {
                completion(0)
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

    func delete(_ posts: [PostEntity], completion: @escaping (Result<Bool, RepositoryError>) -> Void) {
        let context: NSManagedObjectContext = coreDataStack.mainContext
        context.perform {
            posts.forEach {
                context.delete($0)
            }
            do {
                try context.save()
                completion(.success(true))
            } catch {
                completion(.failure(.failedUpdate))
                fatalError(error.localizedDescription)
            }
        }
    }
    
    func recover(_ trashPosts: [PostEntity], completion: @escaping (Result<Bool, RepositoryError>) -> Void) {
        let context: NSManagedObjectContext = coreDataStack.mainContext
        context.perform {
            trashPosts.forEach {
                $0.postType?.isDelete = false
                $0.deleteDate = nil
            }
            do {
                try context.save()
                completion(.success(true))
            } catch {
                completion(.failure(.failedUpdate))
                fatalError(error.localizedDescription)
            }
        }
    }
    
    func checkTrashData(completion: ((Result<Bool, RepositoryError>) -> Void)? = nil) {
        let context: NSManagedObjectContext = coreDataStack.mainContext
        context.perform {
            do {
                let minDate: Date = Date().offset(-29, byAdding: .day) ?? Date()
                let request: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
                request.predicate = NSPredicate(format: "postType.isDelete == true AND deleteDate <= %@", minDate as NSDate )
                request.sortDescriptors = [NSSortDescriptor(key: "deleteDate", ascending: true)]
                
                let result: [PostEntity] = try context.fetch(request)
                result.forEach { context.delete($0) }
                try context.save()
                completion?(.success(true))
            } catch {
                completion?(.failure(.failedDelete))
            }
        }
    }
}
