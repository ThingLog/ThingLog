//
//  ProfileView.swift
//  ThingLog
//
//  Created by hyunsu on 2021/09/21.
//

import UIKit

/// 홈화면 상단에 유저 `닉네임`, 유저 `한 줄 소개` 및 `벳지` 이미지를 보여주는 뷰다. [이미지](https://www.notion.so/ProfileView-2ec81d3153944a198ed01320a070cf63)
///
/// `HomeViewController`에서 사용
final class ProfileView: UIView {
    var userAliasNameButton: UIButton = {
        let button: UIButton = UIButton()
        button.setTitle("분더카머", for: .normal)
        button.setTitleColor(SwiftGenColors.primaryBlack.color, for: .normal)
        button.titleLabel?.font = UIFont.Pretendard.headline3
        button.setImage(SwiftGenIcons.edit.image, for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: -8)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
        button.setContentCompressionResistancePriority(.required, for: .vertical)
        return button
    }()
    
    var userOneLineIntroductionLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "나를 찾는 여정 나를 찾는 여정"
        label.font = UIFont.Pretendard.body2
        label.textColor = SwiftGenColors.primaryBlack.color
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        return label
    }()
    
    private let paddingViewBetweenLabel: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var userBadgeImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        imageView.setContentHuggingPriority(.required, for: .vertical)
        imageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        imageView.backgroundColor = SwiftGenColors.gray6.color
        return imageView
    }()
    
    private let emptyLeadingView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let emptyTrailingView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let emptyVerticalView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        return view
    }()
    
    private lazy var verticalStackView: UIStackView = {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [userAliasNameButton,
                                                                    paddingViewBetweenLabel,
                                                                    userOneLineIntroductionLabel])
        stackView.axis = .vertical
        stackView.alignment = .leading
        return stackView
    }()
    
    private lazy var horizontalStackView: UIStackView = {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [ emptyLeadingView,
                                                                     verticalStackView,
                                                                     userBadgeImageView,
                                                                     emptyTrailingView ])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var totalView: UIStackView = {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [horizontalStackView, emptyVerticalView])
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let imageHeight: CGFloat = 44
    private let emptyWidth: CGFloat = 44
    private let emptyHeight: CGFloat = 16
    private let paddingViewHeight: CGFloat = 4
    
    // 배지이미지를 저장하기 위한 프로퍼티
    private var badgeImage: UIImage?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBackgroundColor()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func setupBackgroundColor() {
        backgroundColor = SwiftGenColors.primaryBackground.color
    }
    
    private func setupView() {
        
        addSubview(totalView)
        
        userBadgeImageView.layer.cornerRadius = imageHeight / 2
        let emptyVerticalConstraint: NSLayoutConstraint = emptyVerticalView.heightAnchor.constraint(equalToConstant: emptyHeight)
        emptyVerticalConstraint.isActive = true
        emptyVerticalConstraint.priority = .defaultHigh
        
        let paddingViewConstraint: NSLayoutConstraint = paddingViewBetweenLabel.heightAnchor.constraint(equalToConstant: paddingViewHeight)
        paddingViewConstraint.isActive = true
        paddingViewConstraint.priority = .defaultHigh
        let userBadgeImageViewHeightConstraint: NSLayoutConstraint = userBadgeImageView.heightAnchor.constraint(equalToConstant: imageHeight)
        userBadgeImageViewHeightConstraint.isActive = true
        userBadgeImageViewHeightConstraint.priority = .defaultHigh
        NSLayoutConstraint.activate([
            userBadgeImageView.widthAnchor.constraint(equalTo: userBadgeImageView.heightAnchor),
            
            emptyLeadingView.widthAnchor.constraint(equalToConstant: emptyWidth),
            emptyTrailingView.widthAnchor.constraint(equalToConstant: emptyWidth),
            
            totalView.leadingAnchor.constraint(equalTo: leadingAnchor),
            totalView.trailingAnchor.constraint(equalTo: trailingAnchor),
            totalView.topAnchor.constraint(equalTo: topAnchor),
            totalView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

extension ProfileView {
    /// 배지 이미지 뷰를 변경하기 위한 메서드다
    /// - Parameter image: 변경하고자 하는 이미지를 주입한다.
    func updateBadgeView(image: UIImage?) {
        badgeImage = image
        userBadgeImageView.image = badgeImage
    }
    
    /// 배지 이미지 뷰를 숨기거나 나타내기 위한 메소드다.
    /// - Parameter bool: 숨기고자 하는 경우는 true, 그렇지 않다면 false를 넣는다.
    func hideBadgeView(_ bool: Bool) {
        userBadgeImageView.backgroundColor = bool ? .clear : SwiftGenColors.gray6.color
        userBadgeImageView.image = bool ? nil : badgeImage
    }
}
