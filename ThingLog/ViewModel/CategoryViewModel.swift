//
//  CategoryViewModel.swift
//  ThingLog
//
//  Created by hyunsu on 2021/09/28.
//

import CoreData
import Foundation

/// 모아보기 홈에서 상단의 탭들의 선택에 따른 `NSFetchRequest<PostEntity>`를 쉽게 생성하여 `NSFetchResultsController`를 호출하도록 한다.
/// 모아보기에서 각 뷰들의 액션에 따라 프로퍼티들을 변경하도록 하여, `fetchRequest`를 호출한다.
final class CategoryViewModel {
    // MARK: - Properties
    // 모아보기 최상단 탭
    var currentTopCategoryType: TopCategoryType {
        // 최상 단 탭이 변경될 때 SubCategoryType 및 FilterType을 초기화한다.
        didSet {
            if currentTopCategoryType != .category {
                currentSubCategoryType = nil
            }
            currentFilterType = currentTopCategoryType.filterTypes.map { ($0, $0.defaultValue) }
        }
    }
    var currentSubCategoryType: String?          /// 최상단 탭이 `카테고리`인 경우
    var currentFilterType: [(type: FilterType, value: String)]
    var fetchResultController: NSFetchedResultsController<PostEntity>?
    private let batchSize: Int = 25
    
    // MARK: - init
    /// 모아보기 처음 진입시, 초기 탭 및 FilterType을 초기화한다. ex) 전체 - 최신순
    init() {
        currentTopCategoryType = .total
        currentFilterType = currentTopCategoryType.filterTypes.map { ($0, $0.defaultValue) }
    }
    
    /// 드롭박스의 데이터를 선택했을 때 변경한 데이터로 FilterType을 변경한다.
    /// - Parameters:
    ///   - type: 해당 범주의 타입을 주입한다.
    ///   - value: 해당 범주의 변경한 데이터를 주입한다.
    func changeCurrentFilterType( type: FilterType, value: String) {
        guard let index = currentTopCategoryType.filterTypes.firstIndex(of: type) else {
            return
        }
        currentFilterType[index].value = value
    }
    
    /// 선택되어진 `FilterType`을 기반으로 `NSFetchRequest`를 작성한다.
    /// - Returns: PostEntity의 NSFetchRequest를 반환한다.
    private func currentNSFetchRequest() -> NSFetchRequest<PostEntity> {
        let request: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
        var predicates: [NSPredicate] = [NSPredicate]()
        if let subType: String = currentSubCategoryType {
            predicates.append(NSPredicate(format: "ANY categories.title == %@", subType))
        }
        var yearMonth: String = ""
        
        currentFilterType.forEach {
            switch $0.type {
            case .latest:
                let isAscending: Bool = $0.value == "최신순" ? false : true
                request.sortDescriptors = [NSSortDescriptor(key: "createDate", ascending: isAscending)]
            case .month:
                if $0.value.count == 2 {
                    yearMonth += "0"+$0.value
                } else {
                    yearMonth += $0.value
                }
            case .year:
                yearMonth += $0.value
            case .preference:
                // 높은순, 낮은순은 최상단 탭이 좋아요, 만족도, 가격 탭일 경우에만 해당한다.
                switch currentTopCategoryType {
                case .like:
                request.sortDescriptors = [NSSortDescriptor(key: "isLike", ascending: $0.value == "낮은순")]
                case .preference:
                    request.sortDescriptors = [NSSortDescriptor(key: "rating.score", ascending: $0.value == "낮은순")]
                case .price:
                    request.sortDescriptors = [NSSortDescriptor(key: "price", ascending: $0.value == "낮은순")]
                default:
                    return
                }
            }
        }
        
        if let startDate: Date = yearMonth.convertToDate(dateFormat: "yyyy년MM월"),
           let endDate: Date = startDate.offset(+1, byAdding: .month) {
            predicates.append(NSPredicate(format: "createDate < %@ AND createDate >= %@", endDate as NSDate, startDate as NSDate))
        }
        
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        return request
    }
    
    /// 현재 상태에 따른 `NSfetchRequest`를 통하여 `NSFetchResultController`를 초기화하여 데이터를 가져와 completion 블록을 호출한다.
    /// - Parameter completion: NSfetchResultsController의 데이터를 사용할 컬렉션뷰를 reload하도록 한다.
    func fetchRequest(_ completion: @escaping (Result<Bool, Error>) -> Void) {
        let request: NSFetchRequest<PostEntity> = currentNSFetchRequest()
        request.fetchBatchSize = batchSize
        fetchResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataStack.shared.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try fetchResultController?.performFetch()
            completion(.success(true))
        } catch {
            completion(.failure(error))
            print(error.localizedDescription)
        }
    }
}
