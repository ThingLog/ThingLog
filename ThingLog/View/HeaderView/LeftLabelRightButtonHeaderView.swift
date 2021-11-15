//
//  LeftLabelRightButtonHeaderView.swift
//  ThingLog
//
//  Created by hyunsu on 2021/10/04.
//
import RxSwift
import UIKit

/// 좌측에 titleLabel과 subTitleLabel을, 우측에 button을 가지는 Collection HeaderView다.
class LeftLabelRightButtonHeaderView: UICollectionReusableView {
    // MARK: - View
    // 로그인화면에서 사용하기 위해 있는 이미지뷰이고, 기본적으로 hide되어있다. 
    let leftIconView: UIImageView = {
        let imageView: UIImageView = UIImageView(image: SwiftGenIcons.loginStar.image.withRenderingMode(.alwaysTemplate))
        imageView.tintColor = SwiftGenColors.primaryBlack.color
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        imageView.setContentHuggingPriority(.required, for: .vertical)
        imageView.isHidden = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.Pretendard.title2
        label.textColor = SwiftGenColors.primaryBlack.color
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.text = "HEADER"
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.Pretendard.body2
        label.textColor = SwiftGenColors.gray2.color
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.text = "10 건"
        return label
    }()
    
    private lazy var labelStackView: UIStackView = {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [
                                                    leftIconView,
                                                    titleLabel,
                                                    subTitleLabel])
        stackView.axis = .horizontal
        stackView.spacing = 6
        stackView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let rightButton: UIButton = {
        let button: TemplateImageButton = TemplateImageButton(swiftGenImage: SwiftGenIcons.dropBoxArrow.image)
        button.tintColor = SwiftGenColors.gray2.color
        button.setTitle("모두보기", for: .normal)
        button.setTitleColor(SwiftGenColors.gray2.color, for: .normal)
        button.titleLabel?.font = UIFont.Pretendard.body2
        button.semanticContentAttribute = .forceRightToLeft
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.contentMode = .scaleAspectFit
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [
                                                    labelStackView,
                                                    rightButton])
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let paddingLeadingTrailingConstraint: CGFloat = 18
    var disposeBag: DisposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupView() {
        setupBackgroundColor()
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: paddingLeadingTrailingConstraint),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -paddingLeadingTrailingConstraint),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func updateTitle(title: String?, subTitle: String? = nil) {
        titleLabel.text = title
        subTitleLabel.text = subTitle
    }
    
    func setupBackgroundColor() {
        backgroundColor = SwiftGenColors.primaryBackground.color
    }
}
