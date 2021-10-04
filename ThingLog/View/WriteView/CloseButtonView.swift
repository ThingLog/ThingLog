//
//  CloseButtonView.swift
//  ThingLog
//
//  Created by 이지원 on 2021/10/04.
//

import UIKit

/// 글쓰기 화면에 들어가는 선택한 사진을 삭제할 때 쓰이는 버튼
final class CloseButtonView: UICollectionReusableView {
    // MARK: View
    private let button: UIButton = {
        let button: UIButton = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(SwiftGenAssets.closeBadge.image, for: .normal)
        return button
    }()

    // MARK: Properties
    var closeButtonDidTappedCallback: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
}

extension CloseButtonView {
    private func configure() {
        addSubview(button)

        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: centerXAnchor),
            button.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        button.addTarget(self, action: #selector(tapped), for: .touchUpInside)
    }

    @objc
    private func tapped() {
        closeButtonDidTappedCallback?()
    }
}
