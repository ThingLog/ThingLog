//
//  SearchResultsViewModel.swift
//  ThingLog
//
//  Created by hyunsu on 2021/10/10.
//

import CoreData
import Foundation

/// 검색하고자 하는 특정 `keyWord`를 통하여,  `ResultCollectionSection` 의 각 타입별로 조건에 맞는 `NSFetchRequest`를 작성하고, `NSFetchedResultsController`를 초기화하여 데이터를 가져오는 담당을하는 객체.
/// `SearchResultsViewController`는 해당 객체의 `fetchedResultsControllers`를 참조하여 콘텐츠들을 갱신한다.
final class SearchResultsViewModel {
    var keyWord: String = ""
    
    lazy var fetchedResultsControllers: [NSFetchedResultsController<PostEntity>] =
        Array(repeating: NSFetchedResultsController(fetchRequest: emptyRequest(), managedObjectContext: CoreDataStack.shared.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil), count: ResultCollectionSection.allCases.count)
    
    /// NSFetchedResultsController를 위한 빈 NSFetchRequest를 만드는 메서드다.
    /// - Returns: sortDescription만 있는 fetchResultsController를 반환한다.
    private func emptyRequest() -> NSFetchRequest<PostEntity> {
        let request: NSFetchRequest<PostEntity>
        request = PostEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "categoryCount", ascending: true)]
        return request
    }
    
    /// ResultCollectionSection의 타입에 대해 해당 NSFetchRequest를 작성하는 메서드다
    /// - Parameters:
    ///   - keyWord: 검색하고자 하는 키워드를 주입한다.
    ///   - type: 특정 타입의 ResultCollectionSection를 주입한다.
    /// - Returns: predicate, sortDescription이 작성된 NSFetchRequest<PostEntity>를 반환한다.
    private func currentFetchRequest(keyWord: String,
                                     type: ResultCollectionSection) -> NSFetchRequest<PostEntity> {
        let request: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "createDate", ascending: false)]
        switch type {
        case .category:
            request.predicate = NSPredicate(format: "ANY categories.title == %@", keyWord)
        case .postTitle:
            request.predicate = NSPredicate(format: "title CONTAINS %@", keyWord)
        case .postContents:
            request.predicate = NSPredicate(format: "contents CONTAINS %@", keyWord)
        case .gift:
            request.predicate = NSPredicate(format: "giftGiver CONTAINS %@", keyWord)
        case .place:
            request.predicate = NSPredicate(format: "purchasePlace CONTAINS %@", keyWord)
        }
        return request
    }
    
    /// keyWord를 통하여 모든 조건에 대해 NSFetchResultsController를 생성한다.
    /// - Parameters:
    ///   - keyWord: 검색하고자 하는 키워드를 주입한다.
    ///   - completion: 찾은 데이터의 개수를 파라미터로 전달한다.
    func fetchAllRequest(keyWord: String, _ completion: @escaping (Int) -> Void) {
        self.keyWord = keyWord
        var searchedTotalCount: Int = 0
        
        for type in ResultCollectionSection.allCases {
            let request: NSFetchRequest<PostEntity> = currentFetchRequest(keyWord: keyWord,
                                                                          type: type)
            fetchedResultsControllers[type.section] = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataStack.shared.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            do {
                try fetchedResultsControllers[type.section].performFetch()
                searchedTotalCount += fetchedResultsControllers[type.section].fetchedObjects?.count ?? 0
            } catch {
                print(error.localizedDescription)
            }
        }
        completion(searchedTotalCount)
    }
}
