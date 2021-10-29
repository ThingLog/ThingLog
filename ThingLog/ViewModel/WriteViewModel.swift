//
//  WriteViewModel.swift
//  ThingLog
//
//  Created by 이지원 on 2021/10/03.
//

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
    var writeType: WriteType
    /// WriteTextFieldCell을 표시할 때 필요한 keyboardType, placeholder 구성. writeType에 따라 개수가 다르다.
    var typeInfo: [(keyboardType: UIKeyboardType, placeholder: String)] {
        switch writeType {
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
    private var passToSelectedCategoryIndexPaths: Set<IndexPath> = []
    private let disposeBag: DisposeBag = DisposeBag()

    init(writeType: WriteType) {
        self.writeType = writeType

        bindPassToSelectedCategoryIndexPaths()
    }

    private func bindPassToSelectedCategoryIndexPaths() {
        NotificationCenter.default.rx.notification(.passToSelectedCategoryIndexPaths, object: nil)
            .map { notification -> Set<IndexPath> in
                notification.userInfo?[Notification.Name.passToSelectedCategoryIndexPaths] as? Set<IndexPath> ?? []
            }
            .bind { [weak self] indexPaths in
                self?.passToSelectedCategoryIndexPaths = indexPaths
            }.disposed(by: disposeBag)
    }
}
