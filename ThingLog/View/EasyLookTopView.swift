//
//  EasyLookTopView.swift
//  ThingLog
//
//  Created by hyunsu on 2021/10/01.
//

import RxSwift
import UIKit

/// 모아보기 최상단에 뷰를 구성하는 뷰이다.
final class EasyLookTopView: UIView {
    // MARK: - View
    var easyLookTabView: EasyLookTabView = {
        let easyLookTabView: EasyLookTabView = EasyLookTabView()
        easyLookTabView.translatesAutoresizingMaskIntoConstraints = false
        easyLookTabView.setContentCompressionResistancePriority(.required, for: .vertical)
        return easyLookTabView
    }()
    
    private lazy var borderLineStackView: UIStackView = {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [
            borderLineLeadingView,
            borderLineView,
            borderLineTrailingView
        ])
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var borderLineView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var borderLineLeadingView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var borderLineTrailingView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var horizontalCollectionView: HorizontalCollectionView = {
        let horizontalCollectionView: HorizontalCollectionView = HorizontalCollectionView()
        horizontalCollectionView.translatesAutoresizingMaskIntoConstraints = false
        horizontalCollectionView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        return horizontalCollectionView
    }()
    
    var resultsWithDropBoxView: ResultsWithDropBoxView
    
    private lazy var stackView: UIStackView = {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [
            easyLookTabView,
            borderLineStackView,
            horizontalCollectionView,
            resultsWithDropBoxView
        ])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - Properties
    private var superView: UIView
    
    private let categoryContentsConstraint: CGFloat = 44
    private let borderLineHeightConstraint: CGFloat = 0.5
    
    // 외부에서 참조하기 위한 뷰 사이즈다. 카테고리를 클릭했을 때 최대 높이를 반환한다.
    var maxHeight: CGFloat {
        categoryContentsConstraint * 3 + borderLineHeightConstraint
    }
    // 외부에서 참조하기 위한 뷰 사이즈다. 카테고리를 클릭하지 않았을 때 최대 높이를 반환한다.
    var normalHeight: CGFloat {
        categoryContentsConstraint * 2 + borderLineHeightConstraint
    }
    
    private var disposeBag: DisposeBag = DisposeBag()
    
    // MARK: - Init
    
    /// 뷰를 초기화하는 메서드이며, CategoryFilterView의 DropBoxView의 계층구조를 위해 ViewController 의 view가 필요하다.
    /// - Parameter superView: ViewController의 view를 주입한다.
    init(superView: UIView) {
        self.superView = superView
        self.resultsWithDropBoxView = {
            let categoryFilterView: ResultsWithDropBoxView = ResultsWithDropBoxView(superView: superView)
            categoryFilterView.setContentCompressionResistancePriority(.required, for: .vertical)
            categoryFilterView.updateDropBoxView(.total, superView: superView)
            return categoryFilterView
        }()
        
        super.init(frame: .zero)
        setupView()
        setupBackgroundColor()
    }
    
    required init?(coder: NSCoder) {
        self.resultsWithDropBoxView = ResultsWithDropBoxView(superView: UIView())
        
        self.superView = UIView()
        super.init(coder: coder)
    }
    
    private func setupBackgroundColor() {
        borderLineView.backgroundColor = SwiftGenColors.gray4.color
    }
    
    private func setupView() {
        addSubview(stackView)
        
        let const1: NSLayoutConstraint = easyLookTabView.heightAnchor.constraint(equalToConstant: categoryContentsConstraint)
        let const2: NSLayoutConstraint = borderLineView.heightAnchor.constraint(equalToConstant: borderLineHeightConstraint)
        let const3: NSLayoutConstraint = resultsWithDropBoxView.heightAnchor.constraint(equalToConstant: categoryContentsConstraint)
        
        const1.priority = UILayoutPriority(rawValue: 900)
        const2.priority = UILayoutPriority(rawValue: 800)
        const3.priority = UILayoutPriority(rawValue: 700)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            borderLineLeadingView.widthAnchor.constraint(equalToConstant: 20),
            borderLineTrailingView.widthAnchor.constraint(equalToConstant: 20),
            const1,
            const3,
            const2
        ])
    }
}
