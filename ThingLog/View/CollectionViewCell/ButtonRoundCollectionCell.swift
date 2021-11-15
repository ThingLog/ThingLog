//
//  RoundButtonCollectionViewCell.swift
//  ThingLog
//
//  Created by hyunsu on 2021/09/28.
//

import UIKit

/// 버튼이 layer 두깨와 함께 라운딩된 CollectionView Cell이다. 재활용 하기 위해 버튼에 inset을 추가하고,  강조하거나 강조하지 않을 때의 버튼의 색을 변경하는 메서드와 layer의 두깨를 조절하는 메서드가 있다. [이미지](https://www.notion.so/ButtonRoundCollectionCell-dd8b0180bb514743810d6789484c1996)
///
/// 모아보기 - 카테고리의 카테고리들을 보여주는 곳에서 사용
///
/// 로그인화면 - 추천 소개글에도 사용된다.
final class ButtonRoundCollectionCell: UICollectionViewCell {
    var button: InsetButton = {
        let button: InsetButton = InsetButton()
        button.layer.borderWidth = 1.0
        button.layer.borderColor = SwiftGenColors.gray3.color.cgColor
        button.titleLabel?.font = UIFont.Pretendard.body2
        button.clipsToBounds = true
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        button.setTitleColor(SwiftGenColors.primaryBlack.color, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupView() {
        setupBackgroundColor()
        contentView.addSubview(button)
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            button.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
    }
    
    func setupBackgroundColor() {
        contentView.backgroundColor = SwiftGenColors.primaryBackground.color
        button.backgroundColor = SwiftGenColors.primaryBackground.color
    }
}

extension ButtonRoundCollectionCell {
    func updateView(title: String, cornerRadius: CGFloat) {
        button.setTitle(title, for: .normal)
        button.layer.cornerRadius = cornerRadius
    }

    /// 버튼의 layer의 두께를 조절한다. default로는 1이다.
    func changeButtonLayerBorderWidth(_ width: CGFloat) {
        button.layer.borderWidth = width
    }
    
    /// 버튼의 layer, background, text 컬러를 변경한다.
    func changeColor(borderColor: UIColor, backgroundColor: UIColor, textColor: UIColor) {
        button.backgroundColor = backgroundColor
        button.layer.borderColor = borderColor.cgColor
        button.setTitleColor(textColor, for: .normal)
    }
}
