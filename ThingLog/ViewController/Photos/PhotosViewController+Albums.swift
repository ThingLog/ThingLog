//
//  PhotosViewController+setup.swift
//  ThingLog
//
//  Created by 이지원 on 2021/10/28.
//

import UIKit

extension PhotosViewController {
    /// 위에서 아래로 내려오는 애니메이션과 함께 AlbumsViewController를 표시한다.
    func showAlbumsViewController() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn) {
            let transition: CATransition = CATransition()
            transition.type = .push
            transition.subtype = .fromBottom
            self.albumsViewController.view.layer.add(transition, forKey: "showAlbums")
            self.albumsViewController.view.isHidden = false
        } completion: { _ in
            self.albumsViewController.view.layer.removeAnimation(forKey: "showAlbums")
        }
    }

    /// 아래에서 위로 올라가는 애니메이션과 함께 AlbumsViewController를 숨긴다.
    func dismissAlbumsViewController() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn) {
            let transition: CATransition = CATransition()
            transition.type = .push
            transition.subtype = .fromTop
            self.albumsViewController.view.layer.add(transition, forKey: "dismissAlbums")
            self.albumsViewController.view.isHidden = true
        } completion: { _ in
            self.albumsViewController.view.layer.removeAnimation(forKey: "dismissAlbums")
        }
    }
}
