//
//  CommentViewModel.swift
//  ThingLog
//
//  Created by 이지원 on 2021/11/22.
//

import CoreData
import Foundation

final class CommentViewModel {
    // MARK: - Properties
    var commentCount: Int { postEntity.comments?.count ?? 0 }
    var contents: String? { postEntity.contents }
    private(set) var postEntity: PostEntity
    private(set) var repository: PostRepository = PostRepository(fetchedResultsControllerDelegate: nil)
    private var comments: [CommentEntity] {
        guard let commentEntities: [CommentEntity] = postEntity.comments?.allObjects as? [CommentEntity] else {
            return []
        }
        let sortedComment: [CommentEntity] = commentEntities.sorted(by: {
            $0.createDate ?? Date() < $1.createDate ?? Date()
        })
        return sortedComment
    }

    // MARK: - Init
    init(postEntity: PostEntity) {
        self.postEntity = postEntity
    }

    // MARK: - Public
    /// 특정 위치의 댓글을 반환한다.
    func getComment(at index: Int) -> String? {
        comments[index].contents
    }

    /// 특정 위치의 댓글의 날짜를 반환한다.
    func getCommentDate(at index: Int) -> String {
        guard let date: Date = comments[index].createDate else {
            let today: Date = Date()
            return "\(today.toString(.year))년 \(today.toString(.month))월 \(today.toString(.day))일"
        }
        return "\(date.toString(.year))년 \(date.toString(.month))월 \(date.toString(.day))일"
    }

    /// 댓글을 Core Data에 저장한다.
    func saveComment(_ text: String, completion: @escaping (Bool) -> Void) {
        let comment: Comment = Comment(contents: text)
        postEntity.addToComments(comment.toEntity(in: CoreDataStack.shared.mainContext))
        repository.update(postEntity) { result in
            switch result {
            case .success:
                completion(true)
            case .failure(let error):
                fatalError("\(#function): \(error.localizedDescription)")
            }
        }
    }

    /// 댓글을 Core Data에서 삭제한다.
    func removeComment(at index: Int) {
        do {
            CoreDataStack.shared.mainContext.delete(comments[index])
            try CoreDataStack.shared.mainContext.save()
        } catch {
            fatalError("\(#function): Failed to Remove Comment Entity")
        }
    }

    /// 댓글을 수정한다.
    func updateComment(at index: Int, text: String?) {
        do {
            comments[index].contents = text
            try CoreDataStack.shared.mainContext.save()
        } catch {
            fatalError("\(#function): Failed to Update Comment Entity")
        }
    }
}
