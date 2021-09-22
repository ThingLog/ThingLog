//
//  TemplateButton.swift
//  ThingLog
//
//  Created by hyunsu on 2021/09/22.
//

import UIKit

class TemplateImageButton: UIButton {
    init(imageName: String) {
        super.init(frame: .zero)
        let image: UIImage? = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
        setImage(image, for: .normal)
        setTitle("89", for: .normal)
        setTitleColor(.black, for: .normal)
        tintColor = .black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateColor(_ color: UIColor) {
        setTitleColor(color, for: .normal)
        tintColor = color
    }
}
