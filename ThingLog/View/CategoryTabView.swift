//
//  CategoryTabView.swift
//  ThingLog
//
//  Created by hyunsu on 2021/09/30.
//
import RxSwift
import UIKit

/// 모아보기 - 최상단에 탭에 나타나기 위한 뷰이다. TopCategoryType 으로 탭들을 결정한다.
final class CategoryTabView: UIView {
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
    private var selectedButton: CategoryTypeButton?
    
    var topCategoryTypeSubject: PublishSubject<TopCategoryType> = PublishSubject()
    
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
        let cases: [TopCategoryType] = TopCategoryType.allCases
        for idx in cases.indices {
            let type: TopCategoryType = cases[idx]
            let categoryTypeButton: CategoryTypeButton = CategoryTypeButton(type: type)
            categoryTypeButton.updateColor(isTint: idx == 0 )
            categoryTypeButton.setTitle(type.rawValue, for: .normal)
            categoryTypeButton.addTarget(self, action: #selector(clickButton), for: .touchUpInside)
            stackView.addArrangedSubview(categoryTypeButton)
            if idx == 0 {
                selectedButton = categoryTypeButton
            }
        }
        stackView.addArrangedSubview(emptyTrailingView)
        addSubview(stackView)
    }
    
    @objc
    private func clickButton(_ sender: CategoryTypeButton) {
        selectedButton?.updateColor(isTint: false)
        sender.updateColor(isTint: true)
        selectedButton = sender
        topCategoryTypeSubject.onNext(sender.type)
    }
}

