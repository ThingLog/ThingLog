//
//  ImageWithTwoLabelVerticalView.swift
//  ThingLog
//
//  Created by hyunsu on 2021/10/28.
//

import UIKit

/// 상단에 이미지뷰와 하단에 label, imageView, label, 이 모두 수직으로 가운데 정렬된 뷰다. 상황에 맞게 커스텀 할 수 있도록 hide메서드와  label들의 폰트타입, 폰트 사이즈 등을 변경하는 set메서드가 있다.
///
/// [이미지](https://www.notion.so/ImageWithTwoLabellVerticalCetnerXView-81792a3403fa4620988a130772557236)
///
/// 사용예
///
/// `DrawerViewController 상단,
///
/// `DrawerCell` 내부에서 사용,
///
/// `SelectingDrawerViewController`에서 사용
final class ImageWithTwoLabelVerticalCetnerXView: UIView {
    private let imageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.tintColor = SwiftGenColors.primaryBlack.color
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "문구세트"
        label.textAlignment = .center
        label.font = UIFont.Pretendard.title1
        label.textColor = SwiftGenColors.primaryBlack.color
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let questionImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.image = SwiftGenIcons.displayCaseNoneM.image.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = SwiftGenColors.primaryBlack.color
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let newBadge: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.image = SwiftGenIcons.new.image
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let subLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "방문 30회 달성"
        label.textAlignment = .center
        label.font = UIFont.Pretendard.body1
        label.textColor = SwiftGenColors.primaryBlack.color
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var informationStackView: UIStackView = {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [
            titleLabel,
            questionImageView,
            subLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let imageViewHeight: CGFloat
    
    init(imageViewHeight: CGFloat) {
        self.imageViewHeight = imageViewHeight
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        self.imageViewHeight = 100
        super.init(coder: coder)
    }
    
    private func setupView() {
        addSubviews(imageView,
                    informationStackView,
                    newBadge)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: imageViewHeight),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            
            informationStackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            informationStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            informationStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            newBadge.topAnchor.constraint(equalTo: imageView.topAnchor, constant: -10),
            newBadge.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -10)
        ])
    }
}

// MARK: - Custom Public Method 
// 상황에 맞게 커스텀할 수 있도록 hide와 set메서드가 있다.
extension ImageWithTwoLabelVerticalCetnerXView {
    func setTitleLabel(fontType: UIFont, color: UIColor, text: String?) {
        titleLabel.font = fontType
        titleLabel.textColor = color
        titleLabel.text = text
    }
    
    func setSubLabel(fontType: UIFont, color: UIColor, text: String?) {
        subLabel.font = fontType
        subLabel.textColor = color
        subLabel.text = text
    }
    
    func setImage(_ image: UIImage) {
        imageView.image = image
    }
    
    func hideSubLabel(_ bool: Bool) {
        subLabel.isHidden = bool
    }
    
    func hideQuestionImageView(_ bool: Bool) {
        questionImageView.isHidden = bool
    }
    
    func hideTitleLabel(_ bool: Bool) {
        titleLabel.isHidden = bool
    }
    
    func hideNewBadge(_ bool: Bool) {
        newBadge.isHidden = bool
    }
}
