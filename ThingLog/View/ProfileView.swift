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
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = button.titleLabel?.font.withSize(20.0)
        button.setImage(UIImage(named: "modifyText"), for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        button.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        return button
    }()
    
    var userOneLineIntroductionLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "나를 찾는 여정 나를 찾는 여정"
        label.font = label.font.withSize(14.0)
        label.textColor = .gray
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
        imageView.backgroundColor = UIColor(white: 239.0 / 255.0, alpha: 1.0)
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
        backgroundColor = .white
        addSubview(horizontalStackView)
        
        userBadgeImageView.layer.cornerRadius = imageHeight / 2
        
        NSLayoutConstraint.activate([
            userBadgeImageView.widthAnchor.constraint(equalTo: userBadgeImageView.heightAnchor),
//            userBadgeImageView.heightAnchor.constraint(equalToConstant: imageHeight)
            userBadgeImageView.heightAnchor.constraint(lessThanOrEqualToConstant: imageHeight),
            
            emptyLeadingView.widthAnchor.constraint(equalToConstant: 0),
            emptyTrailingView.widthAnchor.constraint(equalToConstant: 0),
            
            horizontalStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            horizontalStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            horizontalStackView.topAnchor.constraint(equalTo: topAnchor),
            horizontalStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
