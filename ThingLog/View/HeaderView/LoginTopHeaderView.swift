//
//  LoginTopHeaderView.swift
//  ThingLog
//
//  Created by hyunsu on 2021/10/19.
//
import RxSwift
import UIKit

/// 로그인 화면에 상단에 나타나는 뷰다.  왼쪽에 2열로 보여주는 Label과 우측에 버튼이 있는 Collection HeaderView다.
/// [이미지](https://www.notion.so/LoginTopHeaderView-bb63faf9cb56461b9a06dd4bc345e584)
final class LoginTopHeaderView: UICollectionReusableView {
    let logoView: UIImageView = {
        let imageView: UIImageView = UIImageView(image: SwiftGenIcons.group.image)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = SwiftGenFonts.Pretendard.regular.font(size: 24)
        label.text = "안녕하세요\n띵로그입니다."
        label.numberOfLines = 2
        label.textColor = SwiftGenColors.primaryBlack.color
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    let laterButton: InsetButton = {
        let button: InsetButton = InsetButton()
        // text에 button 크기를 딱 맞춘다 ( 위아래 패딩 값을 없애기 위함 )
        button.titleEdgeInsets = UIEdgeInsets(top: .leastNormalMagnitude, left: .leastNormalMagnitude, bottom: .leastNormalMagnitude, right: .leastNormalMagnitude)
        button.contentEdgeInsets = UIEdgeInsets(top: .leastNormalMagnitude, left: .leastNormalMagnitude, bottom: .leastNormalMagnitude, right: .leastNormalMagnitude)
        button.titleLabel?.font = UIFont.Pretendard.body1
        button.setTitleColor(SwiftGenColors.primaryBlack.color, for: .normal)
        button.setTitle("나중에", for: .normal)
        return button
    }()
    
    var leadingEmptyView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return view
    }()
    
    lazy var stackView: UIStackView = {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [
                                                    titleLabel,
                                                    leadingEmptyView,
                                                    laterButton])
        stackView.axis = .horizontal
        stackView.alignment = .bottom
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let paddingConstraint: CGFloat = 20.0
    private let logoViewHeight: CGFloat = 80
    var disposeBag: DisposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not beem implemented")
    }
    
    private func setupView() {
        setupBackgroundColor()
        addSubview(logoView)
        addSubview(stackView)
        NSLayoutConstraint.activate([
            logoView.topAnchor.constraint(equalTo: topAnchor, constant: paddingConstraint),
            logoView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: paddingConstraint),
            logoView.heightAnchor.constraint(equalToConstant: logoViewHeight),
            stackView.topAnchor.constraint(greaterThanOrEqualTo: logoView.bottomAnchor, constant: -paddingConstraint),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: paddingConstraint),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -paddingConstraint),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor) 
        ])
    }
    
    private func setupBackgroundColor() {
        logoView.backgroundColor = SwiftGenColors.primaryBackground.color
        backgroundColor = SwiftGenColors.primaryBackground.color
    }
}
