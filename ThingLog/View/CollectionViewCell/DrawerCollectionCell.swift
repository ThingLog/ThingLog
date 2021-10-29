//
//  DrawerCollectionCell.swift
//  ThingLog
//
//  Created by hyunsu on 2021/10/28.
//

import UIKit

/// 진열장의 아이템 화면을 보여주는 CollectionView Cell이다.
final class DrawerCollectionCell: UICollectionViewCell {
    let drawerView: ImageWithTwoLabellVerticalCetnerXView = {
        let drawerView: ImageWithTwoLabellVerticalCetnerXView = ImageWithTwoLabellVerticalCetnerXView(imageViewHeight: 90)
        drawerView.translatesAutoresizingMaskIntoConstraints = false
        return drawerView
    }()
    
    private let drawerViewBottomPadding: CGFloat = 30
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupView() {
        contentView.addSubview(drawerView)
        
        NSLayoutConstraint.activate([
            drawerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            drawerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            drawerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -drawerViewBottomPadding),
            drawerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            drawerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0)
        ])
    }
}
