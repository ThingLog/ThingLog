//
//  WriteView.swift
//  ThingLog
//
//  Created by hyunsu on 2021/09/20.
//

import UIKit

import RxCocoa
import RxSwift

/// 샀다, 사고싶다, 선물받았다의 선택지를 나타내는 뷰다.
final class ChoiceWritingView: UIView {
    private let boughtButton: WriteTypeButton = WriteTypeButton(type: .bought)
    private let wishButton: WriteTypeButton = WriteTypeButton(type: .wish)
    private let giftButton: WriteTypeButton = WriteTypeButton(type: .gift)

    private lazy var choiceView: UIStackView = {
        let writeView: UIStackView = UIStackView(arrangedSubviews: [boughtButton, wishButton, giftButton])
        writeView.clipsToBounds = true
        writeView.distribution = .fillEqually
        writeView.translatesAutoresizingMaskIntoConstraints = false
        return writeView
    }()

    let selectedWriteTypeSubject: PublishSubject<PageType> = PublishSubject<PageType>()
    private var heightConstraint: NSLayoutConstraint?
    private let heightMax: CGFloat = 90.0
    private let disposeBag: DisposeBag = DisposeBag()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setChoiceViewTapGesture()
        setupBackgroundColor()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    // MARK: - Setup
    
    private func setupBackgroundColor() {
        backgroundColor = SwiftGenColors.primaryBackground.color
    }
    
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

        clipsToBounds = true
        layer.cornerRadius = 17.0
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }

    private func setChoiceViewTapGesture() {
        let tap: [UITapGestureRecognizer] = (1...3).map { _ in
            UITapGestureRecognizer(target: self, action: #selector(tappedWriteButton(_:)))
        }
        (0...2).forEach { index in
            choiceView.arrangedSubviews[index].addGestureRecognizer(tap[index])
        }
    }
}

extension ChoiceWritingView {
    /// 현재 자신이 보여지고 있는 상태인지 아닌지를 나타내는 Bool타입 프로퍼티다.
    var isShowing: Bool {
        heightConstraint?.constant == heightMax
    }

    private func dimButtonTitle(_ dimmed: Bool) {
        choiceView.arrangedSubviews.forEach {
            if let button: WriteTypeButton = $0 as? WriteTypeButton {
                button.setIcon(dimmed ? true : false)
                button.setColor(dimmed ? SwiftGenColors.white.color : SwiftGenColors.primaryBlack.color)
            }
        }
    }

    /// 자신을 숨기거나 나타나도록 한다.
    /// - Parameter hide: 숨기고자 하는 경우는 true, 나타나고자 하는 경우는 false 이다.
    func hide(_ hide: Bool) {
        heightConstraint?.constant = hide ? 0 : heightMax
        dimButtonTitle(hide)
    }

    @objc
    /// 부모 뷰에게 입력받은 WriteType을 넘겨 준다.
    /// - Parameter sender: sender를 이용해 tap한 뷰를 가려낸다.
    private func tappedWriteButton(_ sender: UITapGestureRecognizer) {
        guard let button: WriteTypeButton = sender.view as? WriteTypeButton,
              let type: PageType = button.type else {
                  return
              }
        selectedWriteTypeSubject.onNext(type)
    }
}
