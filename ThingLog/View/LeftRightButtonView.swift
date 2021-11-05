//
//  LeftRightButtonView.swift
//  ThingLog
//
//  Created by hyunsu on 2021/10/14.
//

import UIKit

/// 왼쪽, 오른쪽 각각 버튼을 가지는 뷰다. 왼쪽 버튼이 강조되어 있다. ( 휴지통에서 주로 사용된다. )
class LeftRightButtonView: UIView {
    let leftButton: UIButton = {
        let button: UIButton = UIButton()
        button.setTitle("모두 삭제", for: .normal)
        button.setTitleColor(SwiftGenColors.systemRed.color, for: .normal)
        button.titleLabel?.font = UIFont.Pretendard.title1
        return button
    }()
    
    let rightButton: UIButton = {
        let button: UIButton = UIButton()
        button.setTitle("모두 복구", for: .normal)
        button.setTitleColor(SwiftGenColors.primaryBlack.color, for: .normal)
        button.titleLabel?.font = UIFont.Pretendard.body1
        return button
    }()
    
    private let borderLine: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = SwiftGenColors.gray2.color
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [leftButton,
                                                                    borderLine,
                                                                    rightButton])
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let topLineView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = SwiftGenColors.gray2.color
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupView() {
        addSubview(stackView)
        addSubview(topLineView)
        
        let window: UIWindow? = UIApplication.shared.windows.first
        let bottomPadding: CGFloat = window?.safeAreaInsets.bottom ?? 0.0
        
        let topLineConstraint: NSLayoutConstraint = topLineView.heightAnchor.constraint(equalToConstant: 0.5)
        topLineConstraint.isActive = true
        topLineConstraint.priority = .defaultHigh
        
        let borderLineConstraint: NSLayoutConstraint = borderLine.widthAnchor.constraint(equalToConstant: 0.5)
        borderLineConstraint.isActive = true
        borderLineConstraint.priority = .defaultHigh
                    
        NSLayoutConstraint.activate([
            topLineView.leadingAnchor.constraint(equalTo: leadingAnchor),
            topLineView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            topLineView.topAnchor.constraint(equalTo: topAnchor),
            
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topLineView.bottomAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -bottomPadding),
 
            leftButton.widthAnchor.constraint(equalTo: rightButton.widthAnchor)
        ])
    }
}
