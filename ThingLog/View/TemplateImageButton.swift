//
//  TemplateButton.swift
//  ThingLog
//
//  Created by hyunsu on 2021/09/22.
//

import UIKit

/// 이미지를 원본이 아닌 Template로 적용한 Button 클래스다.
class TemplateImageButton: UIButton {
    init(swiftGenImage: UIImage) {
        super.init(frame: .zero)
        let image: UIImage? = swiftGenImage.withRenderingMode(.alwaysTemplate)
        setImage(image, for: .normal)
        setTitle("89", for: .normal)
        setTitleColor(SwiftGenColors.black.color, for: .normal)
        tintColor = SwiftGenColors.black.color
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateColor(_ color: UIColor) {
        setTitleColor(color, for: .normal)
        tintColor = color
    }
}
