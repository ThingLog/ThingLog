//
//  ContentsDetailCollectionViewCell.swift
//  ThingLog
//
//  Created by hyunsu on 2021/10/04.
//

import UIKit
/*
 
 categoryStackView: UIStackView - Horizontal {
    [_categoryLabel,
     categoryLabel]
 }
 
 postTitleStackView: UIStackView - Horizontal {
    [_postTitleLabel,
     postTitleLabel]
 }
 
 categoryAndPostTitleStackView: UIStackView - Horizontal  {
    [categoryStackView,
     postTitleStackView]
 }
 
 rightStackView: UIStackView - Vertical  {
    [dateTopEmptyView,
     dateLabel,
     categoryAndPostTitleStackView,
     contentsLabel ]
 }
 
 imageWithRightStackView: UIStackView - Horizontal {
    [iamgeView,
     rightStackView ]
 }
 
 stackView: UIStackView - Veritcal   {
    [topBortderLineView,
     imageWithRightStackView,
     bottomBorderLineView]
 }

 */

/// 좌측에는 이미지가 있고, 우측에는 기록날짜, 카테고리, 물건이름, 내용(최대3줄) 을 담는 Cell이다.
final class ContentsDetailCollectionViewCell: UICollectionViewCell {
    // MARK: - Views
    private let imageView: UIImageView = {
        let imageview: UIImageView = UIImageView()
        imageview.backgroundColor = SwiftGenColors.gray5.color
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    private let dateTopEmptyView: UIView  = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let dateLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.Pretendard.body3
        label.textColor = SwiftGenColors.gray3.color
        label.setContentHuggingPriority(.required, for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let categoryLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.Pretendard.body3
        label.textColor = SwiftGenColors.black.color
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()
    
    private let _categoryLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.Pretendard.title3
        label.text = "카테고리"
        label.textColor = SwiftGenColors.black.color
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var categoryStackView: UIStackView = {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [
                                                    _categoryLabel,
                                                    categoryLabel])
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.setContentHuggingPriority(.required, for: .horizontal)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let postTitleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.Pretendard.body3
        label.textColor = SwiftGenColors.black.color
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let _postTitleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.Pretendard.title3
        label.text = "물건이름"
        label.textColor = SwiftGenColors.black.color
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var postTitleStackView: UIStackView = {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [
                                                    _postTitleLabel,
                                                    postTitleLabel])
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return stackView
    }()
    
    private lazy var categoryAndPostTitleStackView: UIStackView = {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [
                                                    categoryStackView,
                                                    postTitleStackView])
        stackView.axis = .horizontal
        stackView.spacing = 18
        stackView.setContentHuggingPriority(.required, for: .vertical)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let contentsLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.Pretendard.body3
        label.textColor = SwiftGenColors.black.color
        label.numberOfLines = 3
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var rightStackView: UIStackView = {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [
                                                    dateTopEmptyView,
                                                    dateLabel,
                                                    categoryAndPostTitleStackView,
                                                    contentsLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return stackView
    }()
    
    private lazy var imageWithRightStackView: UIStackView = {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [
                                                    imageView,
                                                    rightStackView])
        stackView.axis = .horizontal
        stackView.spacing = 6
        stackView.alignment = .top
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let topBortderLineView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = SwiftGenColors.gray5.color
        return view
    }()
    
    private let bottomBorderLineView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = SwiftGenColors.gray5.color
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [
                                                    topBortderLineView,
                                                    imageWithRightStackView,
                                                    bottomBorderLineView])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupView() {
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            imageView.heightAnchor.constraint(equalTo: imageWithRightStackView.heightAnchor),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            
            bottomBorderLineView.heightAnchor.constraint(equalToConstant: 0.5),
            topBortderLineView.heightAnchor.constraint(equalToConstant: 0.5),
            
            dateTopEmptyView.heightAnchor.constraint(equalToConstant: 4)
        ])
    }
    
    /// PostEntity객체로 뷰들을 업데이트한다.
    func updateView() { // TODO: ⚠️ by post: PostEntity
        // 날짜
        dateLabel.text = "2021.06.18"
        categoryLabel.text = "학용품"
        postTitleLabel.text = "현수"
        contentsLabel.text = "내가 제일 좋아하는 노트브랜드 먕먕 오늘 또 사버렸다. 내가 제일 좋아하는 노트브랜드 먕먕 오늘 또 사버렸다. 내가 제일 좋아하는 노트브랜드 먕먕 오늘 또 사버렸다."
//        categoryLabel.text = post.categories
    }
}
