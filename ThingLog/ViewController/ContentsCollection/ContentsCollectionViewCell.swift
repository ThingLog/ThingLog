//
//  ContentsCollectionViewCell.swift
//  ThingLog
//
//  Created by hyunsu on 2021/09/22.
//
import CoreData
import UIKit

class ContentsCollectionViewCell: UICollectionViewCell {
    let imageView: UIImageView = {
        let imageview: UIImageView = UIImageView()
        imageview.backgroundColor = .clear
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    var testLabel: UILabel = {
        var label: UILabel = UILabel()
        label.textColor = SwiftGenColors.systemBlue.color
        label.font = UIFont.Pretendard.caption
        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        testSetupLabel()
    }
    
    func testSetupLabel() {
        contentView.addSubview(testLabel)
        NSLayoutConstraint.activate([
            testLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            testLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            testLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            testLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    /// PostEntity를 기반으로 뷰를 업데이트한다.
    /// - Parameter postEntity: 특정 PostEntity를 주입한다.
    func updateView(_ postEntity: PostEntity) {
        var text: String = ""
        text += "제목: " + postEntity.title!
        text += "\n카테고리: " + (postEntity.categories?.allObjects as? [CategoryEntity])!.map{ $0.title! }.joined(separator: " - ")
        text += "\n가격: " + String(postEntity.price)
        text += "\n" + ( postEntity.isLike ? "좋아요" : "싫어요" )
        text += "\n날짜: " + (postEntity.createDate!.toString(.year))+(postEntity.createDate!.toString(.month))+(postEntity.createDate!.toString(.day))
        text += "\n만족도: " + String(postEntity.rating!.score)
        testLabel.text = text 
    }
    // TODO: ⚠️ 이미지가 여러개인 경우에만 보여주도록 하는 메서드를 추가한다.
}
