//
//  ProfileView.swift
//  ThingLog
//
//  Created by hyunsu on 2021/09/21.
//

import UIKit

final class ProfileView: UIView {
    var userAliasNameButton: UIButton = {
        let button: UIButton = UIButton()
        button.setTitle("분더카머", for: .normal)
        button.setTitleColor(SwiftGenColors.black.color, for: .normal)
        button.titleLabel?.font = UIFont.Pretendard.headline3
        button.setImage(SwiftGenAssets.modifyText.image, for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        button.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        return button
    }()
    
    var userOneLineIntroductionLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "나를 찾는 여정 나를 찾는 여정"
        label.font = UIFont.Pretendard.body2
        label.textColor = SwiftGenColors.gray4.color
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        return label
    }()
    
    var userBadgeImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        imageView.setContentHuggingPriority(.required, for: .vertical)
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
        let stackView: UIStackView = UIStackView(arrangedSubviews: [userAliasNameButton, userOneLineIntroductionLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
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
        stackView.spacing = 44
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = SwiftGenColors.white.color
        addSubview(totalView)
        
        userBadgeImageView.layer.cornerRadius = imageHeight / 2
        
        NSLayoutConstraint.activate([
            userBadgeImageView.widthAnchor.constraint(equalTo: userBadgeImageView.heightAnchor),
            userBadgeImageView.heightAnchor.constraint(lessThanOrEqualToConstant: imageHeight),
            
            emptyLeadingView.widthAnchor.constraint(equalToConstant: 0),
            emptyTrailingView.widthAnchor.constraint(equalToConstant: 0),
            
            totalView.leadingAnchor.constraint(equalTo: leadingAnchor),
            totalView.trailingAnchor.constraint(equalTo: trailingAnchor),
            totalView.topAnchor.constraint(equalTo: topAnchor),
            totalView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            emptyVerticalView.heightAnchor.constraint(equalToConstant: 16)
        ])
    }
}
