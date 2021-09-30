//
//  InsetButton.swift
//  ThingLog
//
//  Created by hyunsu on 2021/09/29.
//

import UIKit.UIButton

class InsetButton: UIButton {
    override var intrinsicContentSize: CGSize {
        CGSize(width: super.intrinsicContentSize.width + contentEdgeInsets.left + contentEdgeInsets.right + titleEdgeInsets.left + titleEdgeInsets.right,
               height: super.intrinsicContentSize.height + contentEdgeInsets.top + contentEdgeInsets.bottom + titleEdgeInsets.top + titleEdgeInsets.bottom )
    }
}
