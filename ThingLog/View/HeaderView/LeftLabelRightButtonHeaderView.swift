//
//  LeftLabelRightButtonHeaderView.swift
//  ThingLog
//
//  Created by hyunsu on 2021/10/04.
//

import UIKit

/// 좌측에 titleLabel과 subTitleLabel을, 우측에 button을 가지는 Collection HeaderView다.
class LeftLabelRightButtonHeaderView: UICollectionReusableView {
    // MARK: - View
    private let titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.Pretendard.title2
        label.textColor = SwiftGenColors.black.color
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.text = "HEADER"
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.Pretendard.body2
        label.textColor = SwiftGenColors.gray3.color
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.text = "10 건"
        return label
    }()
    
    private lazy var labelStackView: UIStackView = {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [
        titleLabel,
        subTitleLabel])
        stackView.axis = .horizontal
        stackView.spacing = 6
        stackView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let rightButton: UIButton = {
        let button: TemplateImageButton = TemplateImageButton(swiftGenImage: SwiftGenAssets.chevronRight.image)
        button.setImage(SwiftGenAssets.chevronRight.image.resizedImage(Size: CGSize(width: 20, height: 20)), for: .normal)
        button.tintColor = SwiftGenColors.gray3.color
        button.setTitle("모두보기", for: .normal)
        button.setTitleColor(SwiftGenColors.gray3.color, for: .normal)
        button.titleLabel?.font = UIFont.Pretendard.body2
        button.semanticContentAttribute = .forceRightToLeft
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.contentMode = .scaleAspectFit
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
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupView() {
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: paddingLeadingTrailingConstraint),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -paddingLeadingTrailingConstraint),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func updateTitle(title: String?, subTitle: String? = nil ) {
        titleLabel.text = title
        subTitleLabel.text = subTitle
    }
}
