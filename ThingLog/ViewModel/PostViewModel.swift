//
//  PostViewModel.swift
//  ThingLog
//
//  Created by 이지원 on 2021/11/02.
//

import CoreData
import Foundation

/// 게시물리스트를 보여주기 위한 뷰모델을 정의한 Protocol이다
protocol PostViewModelProtocol: AnyObject {
    var fetchedResultsController: NSFetchedResultsController<PostEntity> { get set }
    /// 데이터 표시 시작 지점을 위한 프로퍼티
    var startIndexPath: IndexPath { get set }
    
    init(fetchedResultsController: NSFetchedResultsController<PostEntity>,
         startIndexPath: IndexPath)
}

final class PostViewModel: PostViewModelProtocol {
    var fetchedResultsController: NSFetchedResultsController<PostEntity>
    var startIndexPath: IndexPath
    lazy var repository: PostRepository = PostRepository(fetchedResultsControllerDelegate: nil)

    init(fetchedResultsController: NSFetchedResultsController<PostEntity>,
         startIndexPath: IndexPath) {
        self.fetchedResultsController = fetchedResultsController
        self.startIndexPath = startIndexPath
    }
}
