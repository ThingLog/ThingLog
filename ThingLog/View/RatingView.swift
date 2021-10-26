//
//  RatingView.swift
//  ThingLog
//
//  Created by 이지원 on 2021/10/11.
//  Source: https://ios-development.tistory.com/638

import UIKit

final class RatingView: UIView {
    private var buttons: [UIButton] = []
    private lazy var stackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 14
        return stackView
    }()

    private let fillImage: UIImage = SwiftGenAssets.rating.image.withTintColor(SwiftGenColors.black.color)
    private let emptyImage: UIImage = SwiftGenAssets.rating.image

    // MARK: - Properties
    var maxCount: Int = 5 {
        didSet { setupRatingButton() }
    }
    var currentRating: Int = 0
    /// 버튼을 선택했을 때 호출할 클로저
    var didTapButtonBlock: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupRatingButton()
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RatingView {
    private func setupView() {
        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func setupRatingButton() {
        (0..<maxCount).forEach {
            let button: UIButton = UIButton()
            button.setImage(emptyImage, for: .normal)
            button.tag = $0
            buttons += [button]
            stackView.addArrangedSubview(button)
            button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        }
    }

    @objc
    private func didTapButton(_ sender: UIButton) {
        didTapButtonBlock?()

        let end: Int = sender.tag

        (0...end).forEach { buttons[$0].setImage(fillImage, for: .normal) }
        (end + 1..<maxCount).forEach { buttons[$0].setImage(emptyImage, for: .normal) }

        currentRating = end + 1
    }
}
