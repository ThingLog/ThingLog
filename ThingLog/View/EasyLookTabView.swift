//
//  EasyLookTabView.swift
//  ThingLog
//
//  Created by hyunsu on 2021/09/30.
//
import RxSwift
import UIKit

/// 모아보기 - 최상단에 탭에 나타나기 위한 뷰이다. EasyLookTopTabType 으로 탭들을 결정한다.
final class EasyLookTabView: UIView {
    // MARK: - View
    private var emptyLeadingView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = SwiftGenColors.white.color
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var emptyTrailingView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = SwiftGenColors.white.color
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var stackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - Properties
    private var selectedButton: EasyLookTabTypeButton?
    
    var easyLookTopTabTypeSubject: PublishSubject<EasyLookTabType> = PublishSubject()
    private var previousTopCateogryType: EasyLookTabType = .total
    
    let marginConstant: CGFloat = 15.0
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupView() {
        backgroundColor = SwiftGenColors.white.color
        addView()
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            emptyLeadingView.widthAnchor.constraint(equalToConstant: marginConstant),
            emptyTrailingView.widthAnchor.constraint(equalToConstant: marginConstant)
        ])
    }
    
    private func addView() {
        stackView.addArrangedSubview(emptyLeadingView)
        let cases: [EasyLookTabType] = EasyLookTabType.allCases
        for idx in cases.indices {
            let type: EasyLookTabType = cases[idx]
            let easyLookTabTypeButton: EasyLookTabTypeButton = EasyLookTabTypeButton(type: type)
            easyLookTabTypeButton.updateColor(isTint: idx == 0)
            easyLookTabTypeButton.setTitle(type.rawValue, for: .normal)
            easyLookTabTypeButton.addTarget(self, action: #selector(clickButton), for: .touchUpInside)
            stackView.addArrangedSubview(easyLookTabTypeButton)
            if idx == 0 {
                selectedButton = easyLookTabTypeButton
            }
        }
        stackView.addArrangedSubview(emptyTrailingView)
        addSubview(stackView)
    }
    
    @objc
    private func clickButton(_ sender: EasyLookTabTypeButton) {
        selectedButton?.updateColor(isTint: false)
        sender.updateColor(isTint: true)
        selectedButton = sender
        // 같은 탭의 클릭은 무시하기 위함이다.
        if previousTopCateogryType == sender.type {
            return
        }
        previousTopCateogryType = sender.type
        easyLookTopTabTypeSubject.onNext(sender.type)
    }
}

