//
//  CategoryFilterView.swift
//  ThingLog
//
//  Created by hyunsu on 2021/10/01.
//

import UIKit

/// 모아보기 - 상단 카테고리 탭에서 선택에 따라 검색결과 및 `DropBoxView`들을 구성하는 View다.
final class CategoryFilterView: UIView {
    // MARK: - View
    private let emptyView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = SwiftGenColors.white.color
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return view
    }()
    
    private let resultTotalLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.Pretendard.body2
        label.textColor = SwiftGenColors.gray3.color
        label.text = "총 0건"
        label.backgroundColor = SwiftGenColors.white.color
        return label
    }()
    
    private let emptyLeadingView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = SwiftGenColors.white.color
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var stackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.backgroundColor = .white
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - Properties
    // DropBox뷰를 addSubView할 superView 프로퍼티다 ( ViewController.view )
    private var superView: UIView
    
    private let leadingMarginConstraint: CGFloat = 16
    
    // MARK: - Init
    /// 현재 해당 뷰가 뷰 계층 구조에서 최상단에 속해있는 view를 넣는다.
    /// - Parameter superView: VIewController의 View를 넣는다
    init(superView: UIView) {
        self.superView = superView
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        self.superView = UIView()
        super.init(coder: coder)
    }
    
    private func setupView() {
        backgroundColor = SwiftGenColors.white.color
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        updateDropBoxView(.total, superView: superView)
    }
}

extension CategoryFilterView {
    /// 상단 카테고리의 탭을 클릭할 때 마다 DropBoxView의 구성을 변경하기 위한 메소드이다.
    /// - Parameters:
    ///   - type: 클릭한 카테고리의 탭의 타입( TopCategoryType ) 을 넣는다.
    ///   - superView: 현재 해당 뷰가 뷰 계층 구조에서 최상단에 속해있는 view를 넣는다. ( VIewController의 View를 넣는다 )
    func updateDropBoxView(_ type: TopCategoryType, superView: UIView ) {
        // 기존 stackView를 모두 제거한다.
        stackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
        stackView.addArrangedSubview(emptyLeadingView)
        stackView.addArrangedSubview(resultTotalLabel)
        stackView.addArrangedSubview(emptyView)
        
        emptyLeadingView.widthAnchor.constraint(equalToConstant: leadingMarginConstraint).isActive = true
        
        type.filterTypes.forEach {
            let dropBox: DropBoxView = DropBoxView(type: $0, superView: superView)
            dropBox.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(dropBox)
            NSLayoutConstraint.activate([
                dropBox.widthAnchor.constraint(equalToConstant: dropBox.titleButton.intrinsicContentSize.width)
            ])
        }
    }
    
    /// 결과에 따른 총 게시물 검색 수를 변경하기 위한 메서드다.
    /// - Parameter totalCount: 총 게시물 검색 수를 지정한다.
    func udpateResultTotalLabel(totalCount: Int ) {
        resultTotalLabel.text = "총 " + String(totalCount) + "건"
    }
}
