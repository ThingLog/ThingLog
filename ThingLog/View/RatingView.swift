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

    private let fillImage: UIImage = SwiftGenIcons.satisfactionFill.image.withRenderingMode(.alwaysTemplate)
    private let emptyImage: UIImage = SwiftGenIcons.satisfactionStroke.image.withRenderingMode(.alwaysTemplate)

    // MARK: - Properties
    var maxCount: Int = 5 {
        didSet { setupRatingButton() }
    }
    var currentRating: Int = 0 {
        didSet { updateCurrentRating() }
    }
    /// 버튼을 선택했을 때 호출할 클로저
    var didTapButtonBlock: (() -> Void)?

    init(buttonSpacing: CGFloat = 14.0) {
        super.init(frame: .zero)
        stackView.spacing = buttonSpacing
        setupRatingButton()
        setupView()
    }

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
            button.tintColor = SwiftGenColors.primaryBlack.color
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

    /// currentRating 값 만큼 button의 색상을 채운다.
    private func updateCurrentRating() {
        (0...currentRating - 1).forEach { buttons[$0].setImage(fillImage, for: .normal) }
        (currentRating..<maxCount).forEach { buttons[$0].setImage(emptyImage, for: .normal) }
    }
    
    /// 다크모드와 별개로 색을 지정하려고 하는 경우에 사용한다.
    func tintButton(_ color: UIColor) {
        buttons.forEach {
            $0.tintColor = color
        }
    }
}
