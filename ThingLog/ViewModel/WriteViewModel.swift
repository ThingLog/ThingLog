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
    // Section 마다 표시할 항목의 개수
    lazy var itemCount: [Int] = [1, 1, typeInfo.count, 1, 1]
    private(set) var originalImages: [UIImage] = []
    private var selectedCategories: [Category] = []
    private let thumbnailSize: CGSize = CGSize(width: 80, height: 80)
    private let disposeBag: DisposeBag = DisposeBag()

    init(writeType: PageType) {
        self.pageType = writeType

        setupBinding()
    }

    private func setupBinding() {
        bindNotificationPassToSelectedCategories()
        bindNotificationRemoveSelectedCategory()
        bindNotificationPassSelectPHAssets()
    }

    /// 파라미터로 전달받은 PHAsset을 UIImage로 변환하여 반환한다.
    /// - Parameter assets: 가져올 데이터
    /// - Returns: thumbnailSize의 [UIImage]
    func requestThumbnailImages(with assets: [PHAsset]) -> [UIImage] {
        var images: [UIImage] = []
        let options: PHImageRequestOptions = PHImageRequestOptions()
        options.isSynchronous = true

        assets.forEach { asset in
            asset.toImage(targetSize: thumbnailSize, options: options) { image in
                guard let image = image else { return }
                images.append(image)
            }
        }

        return images
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
                self?.selectedCategories = categories
            }.disposed(by: disposeBag)
    }

    /// `WriteCategoryTableCell` 에서 삭제한 카테고리를 `selectedCategoryIndexPaths`에서도 삭제한다.
    private func bindNotificationRemoveSelectedCategory() {
        NotificationCenter.default.rx.notification(.removeSelectedCategory, object: nil)
            .map { notification -> Category? in
                notification.userInfo?[Notification.Name.removeSelectedCategory] as? Category
            }
            .bind { [weak self] category in
                if let category: Category = category,
                   let firstIndex: Int = self?.selectedCategories.firstIndex(of: category) {
                    self?.selectedCategories.remove(at: firstIndex)
                }
            }.disposed(by: disposeBag)
    }

    /// PhotosViewController 에서 전달받은 데이터를 바인딩한다.
    private func bindNotificationPassSelectPHAssets() {
        NotificationCenter.default.rx
            .notification(.passSelectAssets, object: nil)
            .map { notification -> [PHAsset] in
                notification.userInfo?[Notification.Name.passSelectAssets] as? [PHAsset] ?? []
            }
            .bind { [weak self] assets in
                self?.executeOriginalImages(with: assets)
            }.disposed(by: disposeBag)
    }

    /// 파라미터로 받은 `PHAsset`을 `UIImage`로 변환하여 originalImages에 저장한다. 비동기로 동작한다.
    /// - Parameter assets: UIImage로 변환할 [PHAsset]
    private func executeOriginalImages(with assets: [PHAsset]) {
        let options: PHImageRequestOptions = PHImageRequestOptions()
        options.isSynchronous = true

        DispatchQueue.global().async { [weak self] in
            assets.forEach { asset in
                asset.toImage(targetSize: PHImageManagerMaximumSize, options: options) { image in
                    guard let image = image else { return }
                    self?.originalImages.append(image)
                }
            }
        }
    }
}
