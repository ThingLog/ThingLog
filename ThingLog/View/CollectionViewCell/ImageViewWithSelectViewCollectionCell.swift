//
//  CircleCollectionCell.swift
//  ThingLog
//
//  Created by hyunsu on 2021/11/17.
//

import UIKit

/// 가운데 이미지뷰를 가지면서, 선택될 때 이미지뷰 주변에 라운딩되는 selectView를 가지는 CollectionViewCell이다. 포토카드 색 옵션을 위한 뷰다.
final class ImageViewWithSelectViewCollectionCell: UICollectionViewCell {
    private let selectView: UIView = {
        let view: UIView = UIView()
        view.layer.borderWidth = 3
        view.layer.borderColor = SwiftGenColors.gray4.color.cgColor
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let imageView: UIImageView = {
        let view: UIImageView = UIImageView()
        view.tintColor = SwiftGenColors.primaryBlack.color
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupView() {
        contentView.addSubviews(selectView, imageView)
        
        NSLayoutConstraint.activate([
            selectView.topAnchor.constraint(equalTo: contentView.topAnchor),
            selectView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            selectView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            selectView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
    }
}

extension ImageViewWithSelectViewCollectionCell {
    /// 해당 뷰를 강조시키거나 시키지 않는다 강조하는 경우에는 주변에 라운딩 된 selectView를 나타낸다.
    func tint(_ bool: Bool) {
        selectView.isHidden = !bool
    }
    
    /// 배경과 비슷한 색인 경우에 구별하기 위해 레이어에 검은색을 지정한다.
    func setImageViewLayerBorderWithBlackColor(_ bool: Bool) {
        imageView.layer.borderWidth = bool ? 0.5 : 0
        imageView.layer.borderColor = UIColor.black.cgColor
    }
    
    /// 배경과 비슷한 색인 경우에 구별하기 위해 레이어에 흰색을 지정한다.
    func setImageViewLayerBorderWithWhiteColor(_ bool: Bool) {
        imageView.layer.borderWidth = bool ? 0.5 : 0
        imageView.layer.borderColor = UIColor.white.cgColor
    }
    
    func changeLayerCornerRadius(imageRadius: CGFloat, selectRadius: CGFloat) {
        imageView.layer.cornerRadius = imageRadius
        selectView.layer.cornerRadius = selectRadius
    }
    
    func changeImageView(_ image: UIImage) {
        imageView.image = image
    }
    
    /// 해당 이미지뷰의 배경색을 변경한다.
    func changeImageViewBackgroundColor(_ color: UIColor) {
        imageView.backgroundColor = color
    }
}
