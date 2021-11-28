//
//  WriteViewModel.swift
//  ThingLog
//
//  Created by 이지원 on 2021/10/03.
//

import Photos
import UIKit

import RxSwift

final class WriteViewModel {
    enum Section: Int, CaseIterable {
        case image
        case category
        /// 물건 이름, 가격 등 WriteTextField를 사용하는 항목을 나타내는 섹션
        case type
        case rating
        case contents
    }

    // MARK: - Properties
    var pageType: PageType
    /// WriteTextFieldCell을 표시할 때 필요한 keyboardType, placeholder 구성. writeType에 따라 개수가 다르다.
    var typeInfo: [(keyboardType: UIKeyboardType, placeholder: String)] {
        switch pageType {
        case .bought:
            return [(.default, "물건 이름"), (.numberPad, "가격"), (.default, "구매처")]
        case .wish:
            return [(.default, "물건 이름"), (.numberPad, "가격"), (.default, "판매처")]
        case .gift:
            return [(.default, "물건 이름"), (.default, "선물 준 사람")]
        }
    }
    var createDate: String = "\(Date().toString(.year))년 \(Date().toString(.month))월 \(Date().toString(.day))일"
    /// Section 마다 표시할 항목의 개수
    lazy var itemCount: [Int] = [1, 1, typeInfo.count, pageType == .wish ? 0 : 1, 1]
    private let repository: PostRepository = PostRepository(fetchedResultsControllerDelegate: nil)
    private var isSelectImages: Bool = false

    // MARK: - Properties for save Post
    var price: Int = 0
    var rating: Int = 0
    var contents: String = ""
    lazy var typeValues: [String?] = Array(repeating: "", count: typeInfo.count)
    private(set) var originalImages: [UIImage] = []
    private var categories: [Category] = []
    private(set) var modifyEntity: PostEntity?

    // MARK: - Rx
    private(set) var thumbnailImagesSubject: BehaviorSubject<[UIImage]> = BehaviorSubject<[UIImage]>(value: [])
    private(set) var categorySubject: BehaviorSubject<[Category]> = BehaviorSubject<[Category]>(value: [])
    private let disposeBag: DisposeBag = DisposeBag()

    // MARK: - Init
    init(pageType: PageType, modifyEntity: PostEntity? = nil) {
        self.pageType = pageType
        self.modifyEntity = modifyEntity

        setupBinding()
    }

    // MARK: - setup
    private func setupBinding() {
        bindNotificationPassToSelectedCategories()
        bindNotificationThumbnailImagesSubject()
        bindNotificationRemoveSelectedThumbnail()
        bindCategorySubject()
        
        bindNotificationPassSelectImages()
        bindModifyEntity()
    }

    /// Core Data에 게시물을 저장한다.
    /// - Parameter completion: 성공 여부를 반환한다.
    func save(completion: @escaping (Bool) -> Void) {
        guard isSelectImages else {
            completion(false)
            return
        }

        if let modifyEntity: PostEntity = modifyEntity {
            updatePost()
            repository.update(modifyEntity) { result in
                switch result {
                case .success:
                    completion(true)
                case .failure(let error):
                    fatalError(error.localizedDescription)
                }
            }
        } else {
            let newPost: Post = createNewPost()
            repository.create(newPost) { result in
                switch result {
                case .success:
                    completion(true)
                case .failure(let error):
                    fatalError(error.localizedDescription)
                }
            }
        }
    }

    /// 사용자에게 입력받은 데이터를 토대로 Post 객체를 생성한다.
    private func createNewPost() -> Post {
        let title: String = typeValues[0] ?? ""
        var purchasePlace: String = ""
        var giftGiver: String = ""

        switch pageType {
        case .bought:
            price = Int(typeValues[1]?.filter("0123456789".contains) ?? "") ?? 0
            purchasePlace = typeValues[2] ?? ""
        case .wish:
            price = Int(typeValues[1]?.filter("0123456789".contains) ?? "") ?? 0
            purchasePlace = typeValues[2] ?? ""
        case .gift:
            giftGiver = typeValues[1] ?? ""
        }

        let attachments: [Attachment] = createAttachment()

        return Post(title: title,
                    price: price,
                    purchasePlace: purchasePlace,
                    contents: contents,
                    giftGiver: giftGiver,
                    postType: PostType(isDelete: false, type: pageType),
                    rating: Rating(score: ScoreType(rawValue: Int16(rating)) ?? ScoreType.unrated),
                    categories: categories,
                    attachments: attachments)
    }

    /// originalImages로 [Attachment] 를 생성한다.
    private func createAttachment() -> [Attachment] {
        var attachments: [Attachment] = []
        for index in 0..<originalImages.count {
            if let thumbnail: UIImage = try? thumbnailImagesSubject.value()[index] {
                let attachment: Attachment = Attachment(thumbnail: thumbnail,
                                                        imageData: .init(originalImage: originalImages[index]))
                attachments.append(attachment)
            }
        }
        return attachments
    }

    private func updatePost() {
        guard let modifyEntity = modifyEntity else {
            return
        }

        modifyEntity.title = typeValues[0]
        modifyEntity.price = Int64(typeValues[1]?.filter("0123456789".contains) ?? "") ?? 0
        modifyEntity.purchasePlace = typeValues[2]
        modifyEntity.postType?.pageType = .bought

        if let attachmentEntities: NSSet = modifyEntity.attachments {
            modifyEntity.removeFromAttachments(attachmentEntities)
        }
        let attachments: [Attachment] = createAttachment()
        attachments.forEach { attachment in
            let attachmentEntity: AttachmentEntity = attachment.toEntity(in: CoreDataStack.shared.mainContext)
            modifyEntity.addToAttachments(attachmentEntity)
        }

        if let categoryEntities: NSSet = modifyEntity.categories {
            modifyEntity.removeFromCategories(categoryEntities)
        }
        categories.forEach { category in
            let categoryEntity: CategoryEntity = category.toEntity(in: CoreDataStack.shared.mainContext)
            modifyEntity.addToCategories(categoryEntity)
        }

        modifyEntity.contents = contents
        modifyEntity.rating?.scoreType = ScoreType(rawValue: Int16(rating)) ?? ScoreType.unrated
    }
}

extension WriteViewModel {
    /// `CategoryViewController`에서 전달받은 데이터를 `selectedCategoryIndexPaths`에 저장한다.
    private func bindNotificationPassToSelectedCategories() {
        NotificationCenter.default.rx.notification(.passToSelectedCategories, object: nil)
            .map { notification -> [Category] in
                notification.userInfo?[Notification.Name.passToSelectedCategories] as? [Category] ?? []
            }
            .bind { [weak self] categories in
                self?.categorySubject.onNext(categories)
            }.disposed(by: disposeBag)
    }
    
    /// PhotosViewController 에서 전달받은 이미지를 바인딩한다.
    private func bindNotificationPassSelectImages() {
        NotificationCenter.default.rx
            .notification(.passSelectImages, object: nil)
            .map { notification -> [(original: UIImage, thumbnail: UIImage)] in
                notification.userInfo?[Notification.Name.passSelectImages] as? [(original: UIImage, thumbnail: UIImage)] ?? []
            }
            .bind { [weak self] images in
                let thumbnails: [UIImage] = images.map { $0.thumbnail }
                let originals: [UIImage] = images.map { $0.original }
                self?.thumbnailImagesSubject.onNext(thumbnails)
                self?.originalImages = originals
            }.disposed(by: disposeBag)
    }

    /// 이미지가 선택되어 있는 지 여부를 `isSelectImages` 에 갱신한다.
    private func bindNotificationThumbnailImagesSubject() {
        thumbnailImagesSubject
            .map { $0.isNotEmpty }
            .bind { [weak self] isNotEmpty in
                self?.isSelectImages = isNotEmpty
            }.disposed(by: disposeBag)
    }

    /// WriteImageTableCell 에서 삭제한 썸네일을 originalImages에서도 삭제한다.
    private func bindNotificationRemoveSelectedThumbnail() {
        NotificationCenter.default.rx
            .notification(.removeSelectedThumbnail)
            .map { notification -> IndexPath in
                notification.userInfo?[Notification.Name.removeSelectedThumbnail] as? IndexPath ?? IndexPath()
            }
            .bind { [weak self] indexPath in
                self?.originalImages.remove(at: indexPath.row - 1)
            }.disposed(by: disposeBag)
    }

    /// CategorySubject가 갱신될 때마다 categories에 저장한다.
    private func bindCategorySubject() {
        categorySubject
            .bind { [weak self] categories in
                self?.categories = categories
            }.disposed(by: disposeBag)
    }

    /// modifyEntity가 있다면(게시물을 수정 중이라면), 뷰를 위한 프로퍼티에 갱신한다.
    private func bindModifyEntity() {
        guard let entity: PostEntity = modifyEntity,
              let date: Date = entity.createDate else {
                  return
              }

        // 날짜
        createDate = "\(date.toString(.year))년 \(date.toString(.month))월 \(date.toString(.day))일"

        // 이미지
        if let attachmentEntities: [AttachmentEntity] = entity.attachments?.allObjects as? [AttachmentEntity] {
            let thumnailDatas: [Data] = attachmentEntities.compactMap { $0.thumbnail }
            let imageDatas: [Data] = attachmentEntities.compactMap { $0.imageData?.originalImage }
            let thumnails: [UIImage] = thumnailDatas.compactMap { UIImage(data: $0) }
            let images: [UIImage] = imageDatas.compactMap { UIImage(data: $0) }
            thumbnailImagesSubject.onNext(thumnails)
            originalImages = images
        }

        // 카테고리 (현재 동작X)
        if let categoryEntities: [CategoryEntity] = entity.categories?.allObjects as? [CategoryEntity] {
            categorySubject.onNext(categoryEntities.map { $0.toModel() })
        }
        // 제목
        typeValues[0] = entity.title
        // 가격, 판매처/구매처/선물받은사람
        if pageType == .bought || pageType == .wish {
            typeValues[1] = "\(entity.price)"
            typeValues[2] = entity.purchasePlace
        } else {
            typeValues[1] = entity.giftGiver
        }
        // 별점
        rating = Int(entity.rating?.score ?? 0)
        // 본문
        contents = entity.contents ?? ""
    }
}
