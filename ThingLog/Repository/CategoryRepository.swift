//
//  CategoryRepository.swift
//  ThingLog
//
//  Created by 이지원 on 2021/09/29.
//

import CoreData
import Foundation

protocol CategoryRepositoryProtocol {
    func create(_ newCategory: Category, completion: @escaping(Result<Bool, CategoryRepositoryError>) -> Void)
    func fetchAll(completion: @escaping (Result<[Category], CategoryRepositoryError>) -> Void)
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
    func create(_ newCategory: Category, completion: @escaping(Result<Bool, CategoryRepositoryError>) -> Void) {
        coreDataStack.performBackgroundTask { context in
            do {
                let category: CategoryEntity = newCategory.toEntity(in: context)
                try context.save()
                completion(.success(true))
            } catch {
                completion(.failure(.failedCreateCategory))
            }
        }
    }

    /// 모든 CategoryEntity를 가져와서 Cateogy 타입으로 변환하여 반환한다.
    /// - Parameter completion: 결과를 클로저 형태로 반환한다. 성공했을 경우 [Category]를 반환하며, 실패했을 경우 PostRepositoryError 타입을 반환한다.
    func fetchAll(completion: @escaping (Result<[Category], CategoryRepositoryError>) -> Void) {
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
}
