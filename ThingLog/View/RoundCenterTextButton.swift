//
//  RoundCenterTextButton.swift
//  ThingLog
//
//  Created by hyunsu on 2021/10/27.
//

import UIKit

/// 가운데 흰색 텍스트를 가지면서, 검은색 배경으로, 초기화로 받는 Radius값을 통해 라운딩된 버튼이다. [이미지](https://www.notion.so/RoundCenterTextButton-63d4032c5dae4ebba2e84fc9b7923909)
class RoundCenterTextButton: UIButton {
    init(cornerRadius: CGFloat) {
        super.init(frame: .zero)
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
        backgroundColor = SwiftGenColors.primaryBlack.color
        setTitleColor(SwiftGenColors.white.color, for: .normal)
        titleLabel?.font = UIFont.Pretendard.title1
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
