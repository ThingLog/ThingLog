//
//  GestureModel.swift
//  ThingLog
//
//  Created by hyunsu on 2021/11/17.
//

import UIKit

/// 뷰가 드래그하면서 움직일 수 있도록 도와주는 객체다.
final class GestureModel: NSObject {
    private var startPoint: CGPoint = CGPoint(x: 0, y: 0)
    /// 움직이고자 하는 뷰
    private var targetView: UIView
    /// targetView가 어디 안에서 움직이고자 하는 뷰
    private var parentView: UIView
    
    init(targetView: UIView,
         parentView: UIView) {
        self.targetView = targetView
        self.parentView = parentView
    }
    
    func startObserving() {
        let longGesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPress(sender:)))
        longGesture.minimumPressDuration = 0.01
        targetView.addGestureRecognizer(longGesture)
    }
    
    @objc
    private func longPress(sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            startPoint = offset(sender: sender)
        case .ended:
            print("end")
        case .cancelled:
            print("cancelled")
        default:
            let nextOffset: CGPoint = offset(sender: sender)
            let nextTargetViewCenterX: CGFloat = targetView.center.x + nextOffset.x - startPoint.x
            let nextTargetViewCenterY: CGFloat = targetView.center.y + nextOffset.y - startPoint.y
            if checkBound(loc: CGPoint(x: nextTargetViewCenterX, y: nextTargetViewCenterY)) {
                targetView.center.x = nextTargetViewCenterX
                targetView.center.y = nextTargetViewCenterY
                startPoint = nextOffset
            }
        }
    }
    
    private func offset(sender: UILongPressGestureRecognizer) -> CGPoint {
        sender.location(in: parentView)
    }
    
    /// targetView 사이즈의 반을 벗어나는지 검사한다. true인 경우에만 안전한 영역이다.
    private func checkBound(loc: CGPoint) -> Bool {
        if loc.y < 0 ||
            loc.y > targetView.frame.size.height ||
            loc.x < 0 ||
            loc.x > targetView.frame.size.width {
            return false
        }
        return true
    }
}
