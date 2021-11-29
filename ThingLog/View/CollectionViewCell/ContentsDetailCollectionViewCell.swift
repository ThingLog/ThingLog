//
//  ContentsDetailCollectionViewCell.swift
//  ThingLog
//
//  Created by hyunsu on 2021/10/04.
//
import CoreData
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
        imageview.contentMode = .scaleAspectFill
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
        label.textColor = SwiftGenColors.gray2.color
        label.setContentHuggingPriority(.required, for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let categoryLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.Pretendard.body3
        label.textColor = SwiftGenColors.primaryBlack.color
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    private let _categoryLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.Pretendard.title3
        label.text = "카테고리"
        label.textColor = SwiftGenColors.primaryBlack.color
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var categoryStackView: UIStackView = {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [
                                                    _categoryLabel,
                                                    categoryLabel])
        stackView.axis = .horizontal
        stackView.spacing = 10
//        stackView.setContentHuggingPriority(.required, for: .horizontal)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let postTitleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.Pretendard.body3
        label.textColor = SwiftGenColors.primaryBlack.color
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let _postTitleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.Pretendard.title3
        label.text = "물건이름"
        label.textColor = SwiftGenColors.primaryBlack.color
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
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
        label.textColor = SwiftGenColors.primaryBlack.color
        label.numberOfLines = 3
        label.lineBreakMode = .byCharWrapping
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
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
//        stackView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return stackView
    }()
    
    private let rightStackViewTrailing: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var imageWithRightStackView: UIStackView = {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [
                                                    imageView,
                                                    rightStackView,
                                                    rightStackViewTrailing])
        stackView.axis = .horizontal
        stackView.spacing = 6
        stackView.alignment = .top
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let topBorderLineView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let bottomBorderLineView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [
                                                    topBorderLineView,
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
        setBackgroundColor()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contentsLabel.attributedText = nil 
    }
    
    // MARK: - Setup
    private func setBackgroundColor() {
        topBorderLineView.backgroundColor = SwiftGenColors.gray4.color
        bottomBorderLineView.backgroundColor = SwiftGenColors.gray4.color
    }
    
    private func setupView() {
        imageView.clipsToBounds = true
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            topBorderLineView.heightAnchor.constraint(equalToConstant: 0.3),
            bottomBorderLineView.heightAnchor.constraint(equalToConstant: 0.5),
            
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            imageView.heightAnchor.constraint(equalTo: imageWithRightStackView.heightAnchor),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
                        
            dateTopEmptyView.heightAnchor.constraint(equalToConstant: 4),
            
            categoryLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 80),
            postTitleLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 80),
            
            rightStackViewTrailing.widthAnchor.constraint(equalToConstant: 10),
            rightStackViewTrailing.heightAnchor.constraint(equalToConstant: 10)
        ])
    }
    
    /// PostEntity객체로 뷰들을 업데이트한다.
    func updateView(post: PostEntity? = nil, keyWord: String? = nil) {
        // 날짜
        if let post: PostEntity = post {
            if let createDate: Date = post.createDate {
                dateLabel.text = createDate.toString(.year) + "." + createDate.toString(.month) + "." + createDate.toString(.day)
            }
            
            if let imageData: Data = (post.attachments?.allObjects as? [AttachmentEntity])?[0].thumbnail {
                imageView.image = UIImage(data: imageData)
            }
            
            categoryLabel.text = (post.categories?.allObjects as? [CategoryEntity])?.first?.title
            postTitleLabel.text = post.title
            contentsLabel.text = post.contents
            
            guard let contents: String = post.contents,
                  let keyWord = keyWord else {
                return
            }
            tintTextOnContentsLabel(keyWord: keyWord, contents: contents)
            return
        }
    }
    
    /// contentsLabel에 특정 키워드만 빨갛게 강조하는 메서드다.
    private func tintTextOnContentsLabel(keyWord: String, contents: String) {
        // ⚠️ Post 키워드만 강조하는 로직 추가하기
        let nsStr: NSString = contents as NSString
        let range: NSRange = nsStr.range(of: keyWord)
        if range.location == Int.max { return }
        let newContents: String = nsStr.substring(from: range.location)
        
        let attributedStr: NSMutableAttributedString = NSMutableAttributedString(string: newContents)
        attributedStr.addAttribute(NSAttributedString.Key.foregroundColor,
                                   value: SwiftGenColors.systemRed.color,
                                   range: (newContents as NSString).range(of: keyWord))
        contentsLabel.attributedText = attributedStr
    }
}
