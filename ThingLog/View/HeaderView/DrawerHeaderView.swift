//
//  DrawerHeaderView.swift
//  ThingLog
//
//  Created by hyunsu on 2021/10/29.
//

import UIKit

/// DrawerViewController에서 헤더뷰로 쓰일 대표진열장 HeaderView다.  [이미지](https://www.notion.so/DrawerHeaderView-19e668df2e994f008669223a67895571)
class DrawerHeaderView: UICollectionReusableView {
    // MARK: - View
    let drawerView: ImageWithTwoLabellVerticalCetnerXView = {
        let drawerView: ImageWithTwoLabellVerticalCetnerXView = ImageWithTwoLabellVerticalCetnerXView(imageViewHeight: 100)
        drawerView.translatesAutoresizingMaskIntoConstraints = false
        return drawerView
    }()
    
    private let borderView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = SwiftGenColors.gray4.color
        return view
    }()
    
    // MARK: - Properties
    private let drawerViewTopPadding: CGFloat = 40
    private let borderViewTopPadding: CGFloat = 36
    private let borderViewBottomPadding: CGFloat = 40
    private let padding: CGFloat = 20
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupView() {
        addSubview(drawerView)
        addSubview(borderView)
        
        NSLayoutConstraint.activate([
            drawerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            drawerView.topAnchor.constraint(equalTo: topAnchor, constant: drawerViewTopPadding),
            
            borderView.topAnchor.constraint(equalTo: drawerView.bottomAnchor, constant: borderViewTopPadding),
            borderView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            borderView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            borderView.heightAnchor.constraint(equalToConstant: 0.5),
            borderView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -borderViewBottomPadding)
        ])
    }
}
