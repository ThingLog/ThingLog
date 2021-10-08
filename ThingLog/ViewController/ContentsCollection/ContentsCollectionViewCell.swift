//
//  ContentsCollectionViewCell.swift
//  ThingLog
//
//  Created by hyunsu on 2021/09/22.
//

import UIKit

class ContentsCollectionViewCell: UICollectionViewCell {
    let imageView: UIImageView = {
        let imageview: UIImageView = UIImageView()
        imageview.backgroundColor = .clear
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    private let smallIconView: UIImageView = {
        let image: UIImage? = UIImage(systemName: "square.on.square.fill")
        let imageView: UIImageView = UIImageView(image: image)
        imageView.transform = CGAffineTransform(rotationAngle: .pi)
        imageView.tintColor = SwiftGenColors.white.color
        imageView.translatesAutoresizingMaskIntoConstraints = false
       return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupView() {
        contentView.addSubview(imageView)
        contentView.addSubview(smallIconView)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            smallIconView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 7),
            smallIconView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -7),
            smallIconView.widthAnchor.constraint(equalToConstant: 10),
            smallIconView.heightAnchor.constraint(equalToConstant: 10)
        ])
    }
    // TODO: ⚠️ 이미지가 여러개인 경우에만 보여주도록 하는 메서드를 추가한다.
}
