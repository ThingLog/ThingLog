//
//  CategoryRepository.swift
//  ThingLog
//
//  Created by 이지원 on 2021/09/29.
//

import CoreData
import Foundation

protocol CategoryRepositoryProtocol {
    func create(_ newCategory: Category, completion: @escaping(Result<Bool, RepositoryError>) -> Void)
    func find(with categoryName: String, completion: @escaping ((Bool, CategoryEntity?) -> Void))
    func fetchAll(completion: @escaping (Result<[Category], RepositoryError>) -> Void)
    func deleteAll(completion: @escaping (Result<Bool, RepositoryError>) -> Void)
}

final class CategoryRepository: CategoryRepositoryProtocol {
    private let coreDataStack: CoreDataStack
    private weak var fetchedResultsControllerDelegate: NSFetchedResultsControllerDelegate?

    init(fetchedResultsControllerDelegate: NSFetchedResultsControllerDelegate?,
         coreDataStack: CoreDataStack = CoreDataStack.shared) {
        self.coreDataStack = coreDataStack
        self.fetchedResultsControllerDelegate = fetchedResultsControllerDelegate
    }

    lazy var fetchedResultsController: NSFetchedResultsController<CategoryEntity> = {
        let fetchRequest: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
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

    /// CategoryEntity를 새로 추가한다.
    /// - Parameters:
    ///   - newCategory: CategoryEntity의 속성을 담은 모델 객체
    ///   - completion: 결과를 클로저 형태로 반환한다. 성공했을 경우 무조건 true를 반환하며, 실패했을 경우 PostRepositoryError 타입을 반환한다.
    func create(_ newCategory: Category, completion: @escaping(Result<Bool, RepositoryError>) -> Void) {
        coreDataStack.performBackgroundTask { context in
            do {
                let category: CategoryEntity = newCategory.toEntity(in: context)
                try context.save()
                completion(.success(true))
            } catch {
                completion(.failure(.failedCreate))
            }
        }
    }

    /// 중복 Category 생성을 방지하기 위한 메서드, Category title으로 Entity가 있는지 찾는다. Post를 생성할 때 사용되기 때문에 동기적으로 동작한다.
    /// - Parameters:
    ///   - categoryName: Category 이름
    ///   - completion: 결과를 클로저 형태로 반환한다. categoryName과 동일한 CategoryEntity가 있으면 true를 반환하며, 없는 경우 false를 반환한다.
    func find(with categoryName: String, completion: @escaping ((Bool, CategoryEntity?) -> Void)) {
        let fetchRequest: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", categoryName)

        coreDataStack.mainContext.performAndWait {
            do {
                if let find: CategoryEntity = try fetchRequest.execute().first {
                    completion(true, find)
                } else {
                    completion(false, nil)
                }
            } catch {
                completion(false, nil)
            }
        }
    }

    /// 모든 CategoryEntity를 가져와서 Cateogy 타입으로 변환하여 반환한다.
    /// - Parameter completion: 결과를 클로저 형태로 반환한다. 성공했을 경우 [Category]를 반환하며, 실패했을 경우 PostRepositoryError 타입을 반환한다.
    func fetchAll(completion: @escaping (Result<[Category], RepositoryError>) -> Void) {
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

    /// Core Data에 저장된 모든 CategoryEntity를 삭제한다.
    /// - Parameter completion: 결과를 클로저 형태로 반환한다. 성공했을 경우 true를 반환하며, 실패했을 경우 CategoryRepositoryError 타입을 반환한다.
    func deleteAll(completion: @escaping (Result<Bool, RepositoryError>) -> Void) {
        coreDataStack.performBackgroundTask { context in
            do {
                let request: NSFetchRequest = CategoryEntity.fetchRequest()
                let result: [CategoryEntity] = try context.fetch(request)
                result.forEach { context.delete($0) }
                try context.save()
                completion(.success(true))
            } catch {
                completion(.failure(.failedDelete))
            }
        }
    }
}
