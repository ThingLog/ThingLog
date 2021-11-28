//
//  ThumbnailCell.swift
//  ThingLog
//
//  Created by 이지원 on 2021/10/02.
//

import UIKit

/// 글쓰기 화면에 들어가는 첨부한 사진을 보여주는 셀
final class ThumbnailCell: UICollectionViewCell {
    private let imageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 1
        imageView.layer.cornerRadius = 4
        imageView.layer.borderColor = SwiftGenColors.gray5.color.cgColor
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let closeButton: UIButton = {
        let button: UIButton = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(SwiftGenIcons.photoClose.image, for: .normal)
        return button
    }()
    
    // MARK: Properties
    var closeButtonDidTappedCallback: (() -> Void)?
    private let thumbnailImageViewWidth: CGFloat = 62.0
    private let closeButtonWidth: CGFloat = 16.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        closeButton.addTarget(self, action: #selector(tappedCloseButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not beem implemented")
    }
    
    func configure(image: UIImage?) {
        DispatchQueue.main.async {
            self.imageView.image = image
        }
    }
}

extension ThumbnailCell {
    private func setupView() {
        closeButton.layer.cornerRadius = closeButtonWidth / 2
        
        let containerView: UIView = {
            let view: UIView = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        containerView.addSubview(imageView)
        containerView.addSubview(closeButton)
        contentView.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            // containerView
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            // imageView
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: closeButtonWidth / 2),
            imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -(closeButtonWidth / 2)),
            imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            // closeButton
            closeButton.widthAnchor.constraint(equalToConstant: closeButtonWidth),
            closeButton.heightAnchor.constraint(equalTo: closeButton.widthAnchor),
            closeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            closeButton.topAnchor.constraint(equalTo: containerView.topAnchor)
        ])
    }
    
    @objc
    private func tappedCloseButton() {
        closeButtonDidTappedCallback?()
    }
}
