//
//  IgnoreTouchView.swift
//  ThingLog
//
//  Created by hyunsu on 2021/09/29.
//

import UIKit.UIView

/// 해당 View가 Touch를 받아도 다음 View로 터치 이벤트를 넘기는 View이다.
class IgnoreTouchView: UIView {
    var executeClosure: (() -> Void)?
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView: UIView? = super.hitTest(point, with: event)
        executeClosure?()
        if hitView == self {
            return nil
        }
        return hitView
    }
}
