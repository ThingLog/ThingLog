//
//  WriteView.swift
//  ThingLog
//
//  Created by hyunsu on 2021/09/20.
//

import UIKit

/// 샀다, 사고싶다, 선물받았다의 선택지를 나타내는 뷰다.
final class ChoiceWritingView: UIView {
    private let choiceView: UIStackView = {
        let writeView: UIStackView = UIStackView()
        writeView.clipsToBounds = true
        writeView.distribution = .fillEqually
        let titles: [String] = ["샀다", "사고싶다", "선물받았다"]
        titles.forEach {
            let button: UIButton = UIButton()
            button.setTitle($0, for: .normal)
            button.setTitleColor(.black, for: .normal)
            writeView.addArrangedSubview(button)
        }
        writeView.translatesAutoresizingMaskIntoConstraints = false
        return writeView
    }()
    
    private var heightConstraint: NSLayoutConstraint?
    private let heightMax: CGFloat = 90.0
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - Setup
    private func setupView() {
        addSubview(choiceView)
        translatesAutoresizingMaskIntoConstraints = false
        heightConstraint = heightAnchor.constraint(equalToConstant: 0)
        NSLayoutConstraint.activate([
            choiceView.leadingAnchor.constraint(equalTo: leadingAnchor),
            choiceView.trailingAnchor.constraint(equalTo: trailingAnchor),
            choiceView.topAnchor.constraint(equalTo: topAnchor),
            choiceView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        heightConstraint?.isActive = true
        
        backgroundColor = SwiftGenColors.white.color
        clipsToBounds = true
        layer.cornerRadius = 17.0
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
}

extension ChoiceWritingView {
    /// 현재 자신이 보여지고 있는 상태인지 아닌지를 나타내는 Bool타입 프로퍼티다.
    var isShowing: Bool {
        heightConstraint?.constant == heightMax
    }

    private func dimButtonTitle(_ dimmed: Bool) {
        choiceView.arrangedSubviews.forEach {
            if let button: UIButton = $0 as? UIButton {
                button.setTitleColor((dimmed ? SwiftGenColors.white.color : SwiftGenColors.black.color), for: .normal)
            }
        }
    }

    /// 자신을 숨기거나 나타나도록 한다.
    /// - Parameter hide: 숨기고자 하는 경우는 true, 나타나고자 하는 경우는 false 이다.
    func hide(_ hide: Bool) {
        heightConstraint?.constant = hide ? 0 : heightMax
        dimButtonTitle(hide)
    }
}
