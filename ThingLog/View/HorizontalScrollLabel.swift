//
//  HorizontalScrollLabel.swift
//  ThingLog
//
//  Created by 이지원 on 2021/11/05.
//

import UIKit

/// 스크롤 뷰로 감싼 Label이다. 수평으로 스크롤 할 수 있다. 게시물 화면에서 물건 이름, 장소 이름을 표시할 때 사용한다.
/// [이미지](https://www.notion.so/HorizontalScrollLabel-8e858ea324db46a0a18c4bea93b8e368)
final class HorizontalScrollLabel: UIView {
    private let scrollView: UIScrollView = {
        let scrollView: UIScrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()

    private let contentView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let label: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.Pretendard.title1
        label.textColor = SwiftGenColors.black.color
        label.text = "asdfasdf"
        return label
    }()

    var text: String? {
        didSet { label.text = text }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(label)

        let centerXConstraint: NSLayoutConstraint = contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor)
        centerXConstraint.priority = .defaultLow
        centerXConstraint.isActive = true

        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),

            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),

            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            label.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor)
        ])
    }
}
