//
//  CenterTextButton.swift
//  ThingLog
//
//  Created by 이지원 on 2021/10/22.
//

import UIKit

/// 로그인, 글쓰기, 게시물>사고싶다 화면 하단에 들어가는 버튼
/// [이미지](https://www.notion.so/CenterTextButton-6be63ac5586348669a2559f0774eb4fb)
final class CenterTextButton: UIButton {
    private var buttonHeight: CGFloat

    init(buttonHeight: CGFloat, title: String?) {
        self.buttonHeight = buttonHeight

        super.init(frame: .zero)
        setTitle(title, for: .normal)
        backgroundColor = SwiftGenColors.black.color
        setTitleColor(SwiftGenColors.white.color, for: .normal)
        titleLabel?.font = UIFont.Pretendard.button
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        var size: CGSize = super.intrinsicContentSize
        size.height = buttonHeight
        return size
    }
}
