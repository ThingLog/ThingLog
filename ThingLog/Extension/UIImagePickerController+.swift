//
//  UIImagePickerController+.swift
//  ThingLog
//
//  Created by 이지원 on 2021/11/23.
//  Source: https://stackoverflow.com/questions/12630155/uiimagepicker-allowsediting-stuck-in-center

import UIKit

/// UIImagePickerController 를 이용해 사진 촬영 후, 이미지를 편집할 때 이미지 중앙에서 이동할 수 없는 문제가 있다. 이를 해결하기 위한 익스텐션
extension UIImagePickerController {
    override open var childForStatusBarHidden: UIViewController? {
        nil
    }

    override open var prefersStatusBarHidden: Bool {
        true
    }

    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        fixCannotMoveEditingBox()
    }

    func fixCannotMoveEditingBox() {
        if let cropView: UIView = cropView,
           let scrollView: UIScrollView = scrollView,
           scrollView.contentOffset.y == 0 {
            let top: CGFloat = cropView.frame.minY
            let bottom: CGFloat = scrollView.frame.height - cropView.frame.height - top
            scrollView.contentInset = UIEdgeInsets(top: top, left: 0, bottom: bottom, right: 0)

            var offset: CGFloat = 0
            if scrollView.contentSize.height > scrollView.contentSize.width {
                offset = 0.5 * (scrollView.contentSize.height - scrollView.contentSize.width)
            }
            scrollView.contentOffset = CGPoint(x: 0, y: -top + offset)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.fixCannotMoveEditingBox()
        }
    }

    var cropView: UIView? {
        findCropView(from: self.view)
    }

    var scrollView: UIScrollView? {
        findScrollView(from: self.view)
    }

    func findCropView(from view: UIView) -> UIView? {
        let width: CGFloat = UIScreen.main.bounds.width
        let size: CGSize = view.bounds.size
        if width == size.height, width == size.height {
            return view
        }
        for view in view.subviews {
            if let cropView: UIView = findCropView(from: view) {
                return cropView
            }
        }
        return nil
    }

    func findScrollView(from view: UIView) -> UIScrollView? {
        if let scrollView: UIScrollView = view as? UIScrollView {
            return scrollView
        }
        for view in view.subviews {
            if let scrollView: UIScrollView = findScrollView(from: view) {
                return scrollView
            }
        }
        return nil
    }
}
