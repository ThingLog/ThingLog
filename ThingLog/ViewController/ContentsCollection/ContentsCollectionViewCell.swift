//
//  ContentsCollectionViewCell.swift
//  ThingLog
//
//  Created by hyunsu on 2021/09/22.
//
import CoreData
import UIKit

import RxCocoa
import RxSwift
import Photos

/// 기본적인 이미지만을 보여주기 위한 cell이다.
///
/// 기본적인 구성으로는 imageView, smallIconView 로 구성된다. smallIconView는 이미지가 여러개인 경우에 표시한다.
///
/// 추가적으로 하단의 그라데이션뷰와, 하단의 label, 우측상단의 체크버튼이 존재한다. ( 이는 휴지통 화면에서 재사용하기 위해 존재한다. )
/// ```swift
/// // 휴지통 화면에서 사용하고자 하는 경우
/// cell.smallIconView.isHidden = true
/// cell.bottomGradientView.isHidden = false
/// cell.bottomLabel.isHidden = false
/// cell.checkButton.isHidden = false
/// ```
class ContentsCollectionViewCell: UICollectionViewCell {
    // MARK: - Views
    let imageView: UIImageView = {
        let imageview: UIImageView = UIImageView()
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.contentMode = .scaleAspectFill
        return imageview
    }()
    
    // smallIconView는 이미지가 여러개인 경우에 표시한다.
    let smallIconView: UIImageView = {
        let image: UIImage? = UIImage(systemName: "square.on.square.fill")
        let imageView: UIImageView = UIImageView(image: image)
        imageView.transform = CGAffineTransform(rotationAngle: .pi)
        imageView.tintColor = .white
        imageView.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        imageView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        imageView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // 하단에 그라데이션을 강조하기 위한 뷰다. ( 주로 휴지통 화면에서 사용된다. )
    let bottomGradientView: UIView = {
        let view: UIView = UIView()
        view.alpha = 0.6
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // 하단에 정보를 표시하기 위한 Label이다. ( 주로 휴지통 화면에서 몇일 남았는지를 알려주기 위해 사용된다. )
    let bottomLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = .white
        label.font = UIFont.Pretendard.body3
        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.text = "20일"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    /// 우측 상단에 체크하기 위한 버튼이다. ( 주로 휴지통 화면에서 삭제 또는 복구하기 위해 사용되는 버튼이다. )
    let checkButton: CheckView = {
        let button: CheckView = CheckView()
        button.layer.borderWidth = 1
        button.imageView.tintColor = .white
        button.layer.borderColor = UIColor.white.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        button.isUserInteractionEnabled = false
        return button
    }()

    // MARK: - Propertis
    /// 셀이 동일한 에셋을 표시하는 경우에만 썸네일 이미지를 설정하기 위한 프로퍼티
    var representedAssetIdentifier: String = ""
    var imageRequestID: PHImageRequestID?
    var disposeBag: DisposeBag = DisposeBag()
    private let paddingCheckButton: CGFloat = 8
    private let checkButtonSize: CGFloat = 20

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()

        guard let imageRequestID = imageRequestID else { return }
        PHCachingImageManager.default().cancelImageRequest(imageRequestID)
        self.imageRequestID = nil
    }
    
    /// 그라데이션 뷰의 크기를 결정하기 위해 구현한다.
    override func layoutSubviews() {
        super.layoutSubviews()
        bottomGradientView.frame = contentView.bounds
        bottomGradientView.frame.size.height = contentView.bounds.height / 4
        bottomGradientView.setGradient(startColor: .black,
                                       endColor: .clear,
                                       startPoint: CGPoint(x: 0.0, y: 1.0),
                                       endPoint: CGPoint(x: 0.0, y: 0.0))
    }
    
    // MARK: - Setup
    private func setupView() {
        backgroundColor = SwiftGenColors.primaryBackground.color
        clipsToBounds = true
        contentView.addSubviews(imageView,
                                smallIconView,
                                bottomGradientView,
                                bottomLabel,
                                checkButton)
        checkButton.layer.cornerRadius = checkButtonSize / 2
        
        let imageViewHeight: NSLayoutConstraint = imageView.heightAnchor.constraint(equalToConstant: 124)
        imageViewHeight.isActive = true
        imageViewHeight.priority = .defaultHigh
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            smallIconView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 7),
            smallIconView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -7),
            smallIconView.widthAnchor.constraint(equalToConstant: 10),
            smallIconView.heightAnchor.constraint(equalToConstant: 10),
            
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            
            bottomGradientView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bottomGradientView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bottomGradientView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            bottomGradientView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 1 / 5),
            
            bottomLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bottomLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bottomLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -7),
            
            checkButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: paddingCheckButton),
            checkButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -paddingCheckButton),
            checkButton.widthAnchor.constraint(equalToConstant: checkButtonSize),
            checkButton.heightAnchor.constraint(equalToConstant: checkButtonSize)
        ])
    }
    
    /// PostEntity를 기반으로 뷰를 업데이트한다.
    /// - Parameter postEntity: 특정 PostEntity를 주입한다.
    func updateView(_ postEntity: PostEntity) {
        if let imageData: Data = (postEntity.attachments?.allObjects as? [AttachmentEntity])?[0].thumbnail {
            imageView.image = UIImage(data: imageData)
        }
        smallIconView.isHidden = postEntity.attachments?.allObjects.count == 1
    }

    /// PostEntity가 아닌 `이미지`만으로 이미지뷰를 업데이트 한다 ( PhotosViewController 에서 )
    func update(image: UIImage?) {
        imageView.image = image
    }
}

extension ContentsCollectionViewCell {
    /// 휴지통화면에서 사용하고자 하는 경우에 내부 뷰들을 보여주거나 숨김처리 하는 메서드다.
    func setupForTrashView() {
        smallIconView.isHidden = true
        bottomGradientView.isHidden = false
        bottomLabel.isHidden = false
    }

    /// 이미지와 체크 버튼만 표시하고 나머지 뷰들은 숨김처리한다.
    func setupImageViewWithCheckButton() {
        smallIconView.isHidden = true
        bottomGradientView.isHidden = true
        bottomLabel.isHidden = true
        checkButton.isHidden = false
        checkButton.isUserInteractionEnabled = true
    }

    /// 이미지만 표시하고 나머지 뷰들은 숨김처리한다.
    func setupDisplayOnlyImageView() {
        smallIconView.isHidden = true
        bottomGradientView.isHidden = true
        bottomLabel.isHidden = true
        checkButton.isHidden = true
        checkButton.isUserInteractionEnabled = false
    }
    
    /// 체크버튼을 강조하거나 강조하지 않도록 변경하는 메서드다
    func changeCheckButton(isSelected: Bool) {
        checkButton.imageView.isHidden = !isSelected
        checkButton.backgroundColor = isSelected ? .white : .clear
        checkButton.layer.borderColor = isSelected ? UIColor.clear.cgColor : SwiftGenColors.white.color.cgColor
    }

    /// 체크 버튼의 `titleLabel`과 배경색을 변경한다.
    /// - Parameters:
    ///   - string: checkButton.titleLabel 에 지정할 문자열
    ///   - backgroundColor: checkButton.backgroundColor 로 지정할 색상
    func updateCheckButton(string: String?, backgroundColor: UIColor?) {
        checkButton.label.text = string
        checkButton.backgroundColor = backgroundColor
    }
}
