//
//  LogoView.swift
//  ThingLog
//
//  Created by hyunsu on 2021/09/30.
//

import UIKit.UILabel

/// NavigationBar에 좌측에 들어가는 Logo를 가지는 Label이다.
final class LogoView: UILabel {
    init(_ title: String, font: UIFont = UIFont.Pretendard.headline3) {
        super.init(frame: .zero)
        text = title
        textColor = SwiftGenColors.primaryBlack.color
        self.font = font
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
