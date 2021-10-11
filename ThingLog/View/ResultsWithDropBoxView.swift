//
//  ResultsWithDropBoxView.swift
//  ThingLog
//
//  Created by hyunsu on 2021/10/01.
//

import UIKit
/*
 구조
 
 titleLabelStackView: UIStackView - horizontal {
 [titleLabel,
 emptyTitleLabelTrailingView]
 }
 
 stackView: UIStackView - horizontal {
 [emptyLeadingView,
 titleLabelStackView,
 resultTotalLabel,
 emptyView
 }
 
 */

/// 모아보기 - 상단 카테고리 탭에서 선택에 따라 검색결과 및 `DropBoxView`들을 구성하는 View다.
///
/// 검색결과에서 모두보기 버튼 클릭할 경우 상단에 재사용하기 위해 `titleLabel`을 추가했다. 모아보기에서는 `titleLabel`을 숨김처리한다. 
final class ResultsWithDropBoxView: UIView {
    // MARK: - View
    private let emptyView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return view
    }()
    
    // 검색결과에서 모두보기 버튼 클릭할 경우 상단에 재사용하기 위해 titleLabel을 추가했다.
    let titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.Pretendard.title2
        label.text = "카테고리"
        label.textColor = SwiftGenColors.black.color
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var titleLabelStackView: UIStackView = {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [
                                                    titleLabel,
                                                    emptyTitleLabelTrailingView])
        stackView.backgroundColor = SwiftGenColors.white.color
        stackView.isHidden = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
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
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentHuggingPriority(.required, for: .horizontal)
        return view
    }()
    
    private let emptyTitleLabelTrailingView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentHuggingPriority(.required, for: .horizontal)
        return view
    }()
    
    lazy var stackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.backgroundColor = SwiftGenColors.white.color
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - Properties
    // DropBox뷰를 addSubView할 superView 프로퍼티다 ( ViewController.view )
    private var superView: UIView
    
    private let leadingMarginConstraint: CGFloat = 18
    private let betweenTitleLabelAndResultLabelWidth: CGFloat = 8
    
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
        
        updateDropBoxView(nil, superView: superView)
    }
}

extension ResultsWithDropBoxView {
    /// 상단 카테고리의 탭을 클릭할 때 마다 DropBoxView의 구성을 변경하기 위한 메소드이다.
    /// - Parameters:
    ///   - type: 클릭한 카테고리의 탭의 타입( EasyLookTabType ) 을 넣는다.
    ///   - superView: 현재 해당 뷰가 뷰 계층 구조에서 최상단에 속해있는 view를 넣는다. ( VIewController의 View를 넣는다 )
    func updateDropBoxView(_ type: EasyLookTabType?, superView: UIView) {
        // 기존 stackView를 모두 제거한다.
        stackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
        stackView.addArrangedSubview(emptyLeadingView)
        stackView.addArrangedSubview(titleLabelStackView)
        stackView.addArrangedSubview(resultTotalLabel)
        stackView.addArrangedSubview(emptyView)
        
        emptyLeadingView.widthAnchor.constraint(equalToConstant: leadingMarginConstraint).isActive = true
        emptyTitleLabelTrailingView.widthAnchor.constraint(equalToConstant: betweenTitleLabelAndResultLabelWidth).isActive = true
        
        // type이 필요하지 않은 경우는 DropBox를 더이상 추가하지 않는다.
        guard let type = type else { return }
        
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
    func updateResultTotalLabel(by title: String) {
        resultTotalLabel.text = title
    }
    
    func updateTitleLabel(by title: String?) {
        titleLabelStackView.isHidden = false
        titleLabel.text = title
    }
}
