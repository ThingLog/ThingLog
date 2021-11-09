//
//  ContentsTabView.swift
//  ThingLog
//
//  Created by hyunsu on 2021/09/22.
//

import RxSwift
import UIKit

/// 홈화면 ContentsCollectionView들이 보이는 상단의 탭을 나타내는 뷰다.
final class ContentsTabView: UIView {
    var boughtButton: TemplateImageButton = {
        let button: TemplateImageButton = TemplateImageButton(swiftGenImage: SwiftGenIcons.buyVer1.image)
        button.updateColor(SwiftGenColors.primaryBlack.color)
        button.titleLabel?.font = UIFont.Pretendard.title2
        return button
    }()
    var wishButton: TemplateImageButton = {
        let button: TemplateImageButton = TemplateImageButton(swiftGenImage: SwiftGenIcons.wishVer1.image)
        button.updateColor(SwiftGenColors.gray2.color)
        button.titleLabel?.font = UIFont.Pretendard.body2
        return button
    }()
    var giftButton: TemplateImageButton = {
        let button: TemplateImageButton = TemplateImageButton(swiftGenImage: SwiftGenIcons.giftVer1.image)
        button.updateColor(SwiftGenColors.gray2.color)
        button.titleLabel?.font = UIFont.Pretendard.body2
        return button
    }()
    
    private var indicatorBar: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var topBorderLine: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var buttonStackView: UIStackView = {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [boughtButton, wishButton, giftButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var leadingAnchorIndicatorBar: NSLayoutConstraint?
    var disposeBag: DisposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupBackgroundColor()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupBackgroundColor() {
        indicatorBar.backgroundColor = SwiftGenColors.primaryBlack.color
        topBorderLine.backgroundColor = SwiftGenColors.gray4.color
        backgroundColor = SwiftGenColors.primaryBackground.color
    }
    
    func setupView() {
        
        addSubview(topBorderLine)
        addSubview(indicatorBar)
        addSubview(buttonStackView)
        
        leadingAnchorIndicatorBar = indicatorBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0)
        leadingAnchorIndicatorBar?.isActive = true
        NSLayoutConstraint.activate([
            topBorderLine.leadingAnchor.constraint(equalTo: leadingAnchor),
            topBorderLine.trailingAnchor.constraint(equalTo: trailingAnchor),
            topBorderLine.topAnchor.constraint(equalTo: topAnchor),
            topBorderLine.heightAnchor.constraint(equalToConstant: 0.5),
            
            indicatorBar.heightAnchor.constraint(equalToConstant: 2),
            indicatorBar.bottomAnchor.constraint(equalTo: bottomAnchor),
            indicatorBar.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1 / 3),
            
            buttonStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            buttonStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            buttonStackView.topAnchor.constraint(equalTo: topBorderLine.bottomAnchor),
            buttonStackView.bottomAnchor.constraint(equalTo: indicatorBar.topAnchor)
        ])
    }
}

// MARK: - Update
extension ContentsTabView {
    /// 선택한 index를 통하여 해당 버튼을 tint 시키고, 그 외 버튼들은 연한 색깔로 변경한다.
    /// - Parameters:
    ///   - index: 선택한 index를 넣는다.
    func updateButtonTintColor(by index: Int) {
        buttonStackView.arrangedSubviews.forEach {
            if let button: TemplateImageButton = $0 as? TemplateImageButton {
                button.setTitleColor(SwiftGenColors.gray2.color, for: .normal)
                button.tintColor = SwiftGenColors.gray2.color
                button.titleLabel?.font = UIFont.Pretendard.body2
            }
        }
        switch index {
        case 0:
            boughtButton.updateColor(SwiftGenColors.primaryBlack.color)
            boughtButton.titleLabel?.font = UIFont.Pretendard.title2
        case 1:
            wishButton.updateColor(SwiftGenColors.primaryBlack.color)
            wishButton.titleLabel?.font = UIFont.Pretendard.title2
        default:
            giftButton.updateColor(SwiftGenColors.primaryBlack.color)
            giftButton.titleLabel?.font = UIFont.Pretendard.title2
        }
    }
    
    /// 선택한 index를 통하여 indicatorBar를 애니메이션으로 움직이는 메소드다.
    /// - Parameter index: 선택한 index를 넣는다.
    func updateIndicatorBar(by index: Int) {
        UIView.animate(withDuration: 0.3) {
            self.leadingAnchorIndicatorBar?.constant = (UIScreen.main.bounds.width / 3) * CGFloat(index)
            self.layoutIfNeeded()
        }
    }
    
    /// PageType으로 특정 버튼을 반환하는 메소드다 ( 홈화면에서 사용하기 위해 )
    /// - Parameter pageType: PageType을 주입한다.
    /// - Returns: PageType에 맞는 버튼을 반환한다.
    func pageTypeButton(by pageType: PageType) -> UIButton {
        switch pageType {
        case .bought:
            return boughtButton
        case .gift:
            return giftButton
        case .wish:
            return wishButton
        }
    }
}
