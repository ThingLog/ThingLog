//
//  PhotosViewController+crop.swift
//  ThingLog
//
//  Created by hyunsu on 2021/11/25.
//

import UIKit

extension PhotosViewController {
    /// 오른쪽에서 왼쪽으로 나타나는 애니메이션과 함께 CropViewController를 표시한다.
    func showCropViewController(selectedImage: ImageEditInfo) {
        cropViewController = CropViewController(selectedImage: selectedImage)
        //        cropViewController?.numberView.label.text = "\(selectedImages.count)"
        cropViewController?.backCompletion = dismissCropViewController
        guard let cropViewController: CropViewController = cropViewController else { return }
        let cropView: UIView = cropViewController.view
        cropView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cropView)
        addChild(cropViewController)
        
        let safeArea: UILayoutGuide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            cropView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            cropView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            cropView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            cropView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        UIView.animate(withDuration: 0.3, delay: 0.2, options: .curveEaseIn) {
            let transition: CATransition = CATransition()
            transition.type = .push
            transition.subtype = .fromRight
            cropViewController.view.layer.add(transition, forKey: "showCrop")
        } completion: { _ in
            cropViewController.view.layer.removeAnimation(forKey: "showCrop")
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
            self.changeNavigationBar()
        }
    }
    
    /// 왼쪽에서 오른쪽으로 사라지는 애니메이션과 함께 CropViewController를 숨긴다.
    func dismissCropViewController() {
        guard let crop: CropViewController = cropViewController else { return }
        saveCropImageInfo()
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn) {
            let transition: CATransition = CATransition()
            transition.type = .push
            transition.subtype = .fromLeft
            crop.view.layer.add(transition, forKey: "showCrop")
            crop.view.isHidden = true
        } completion: { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                crop.view.layer.removeAnimation(forKey: "showCrop")
                crop.view.removeFromSuperview()
                crop.removeFromParent()
                self.cropViewController = nil
                self.setupNavigationBar()
                self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
            }
        }
    }
    
    func changeNavigationBar() {
        let logoView: LogoView = LogoView("사진", font: UIFont.Pretendard.headline4)
        logoView.textAlignment = .center
        navigationItem.titleView = logoView
        
        let backButton: UIButton = UIButton()
        backButton.setImage(SwiftGenIcons.longArrowR.image.withRenderingMode(.alwaysTemplate), for: .normal)
        backButton.tintColor = SwiftGenColors.primaryBlack.color
        backButton.rx.tap
            .bind { [weak self] in
                self?.dismissCropViewController()
            }
            .disposed(by: disposeBag)
        let backBarButton: UIBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backBarButton
    }
    
    func saveCropImageInfo() {
        guard let image = cropViewController?.cropImage(),
              let index = cropViewController?.selectedImage.indexPath,
              let firstIndex = selectedImages.firstIndex(where: { $0.indexPath == index }) else {
                  return
              }
        selectedImages[firstIndex].image = nil
        selectedImages[firstIndex].cropImage = image
        selectedImages[firstIndex].zoomScale = cropViewController?.zoomScale
        selectedImages[firstIndex].contentOffset = cropViewController?.contentOffset
    }
}
