//
//  PostViewModel.swift
//  ThingLog
//
//  Created by 이지원 on 2021/11/02.
//

import CoreData
import Foundation

protocol PostViewModelProtocol: AnyObject {
    associatedtype Screen

    var fetchedResultsController: NSFetchedResultsController<PostEntity> { get set }
    /// 데이터 표시 시작 지점을 위한 프로퍼티
    var startIndexPath: IndexPath { get set }
    /// 어느 화면에서 표시하는 지 알기 위한 프로퍼티
    var screen: Screen { get set }

    init(fetchedResultsController: NSFetchedResultsController<PostEntity>,
         startIndexPath: IndexPath,
         from screen: Screen)
}

final class PostViewModel: PostViewModelProtocol {
    enum Screen {
        case buy
        case bought
        case gift
        case search
        case trash
    }

    var fetchedResultsController: NSFetchedResultsController<PostEntity>
    var startIndexPath: IndexPath
    var screen: Screen

    init(fetchedResultsController: NSFetchedResultsController<PostEntity>,
         startIndexPath: IndexPath,
         from screen: Screen) {
        self.fetchedResultsController = fetchedResultsController
        self.startIndexPath = startIndexPath
        self.screen = screen
    }
}
