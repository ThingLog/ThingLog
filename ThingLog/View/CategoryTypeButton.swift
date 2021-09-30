//
//  CategoryTypeButton.swift
//  ThingLog
//
//  Created by hyunsu on 2021/09/30.
//

import UIKit

/// CategoryTapView에 들어가는 Button에 TopCategoryType을 프로퍼티로 가지는 UIButton이다.
final class CategoryTypeButton: UIButton {
    var type: TopCategoryType
    
    init(type: TopCategoryType) {
        self.type = type
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        self.type = .category
        super.init(coder: coder)
    }
    
    func updateColor(isTint: Bool) {
        titleLabel?.font = isTint ? UIFont.Pretendard.title2 : UIFont.Pretendard.body2
        setTitleColor(isTint ? SwiftGenColors.black.color : SwiftGenColors.gray4.color, for: .normal)
    }
}
