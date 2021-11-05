//
//  EmptyPostView.swift
//  ThingLog
//
//  Created by hyunsu on 2021/10/08.
//

import UIKit

/// Post가 없는 경우에 게시물 없음을 나타내는 뷰다.
final class EmptyPostView: UIView {
    private let topBorderLine: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentHuggingPriority(.required, for: .vertical)
        return view
    }()
    
    private let label: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.Pretendard.body1
        label.textColor = SwiftGenColors.gray4.color
        label.text = "게시물 없음"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [
                                                    topBorderLine,
                                                    label])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupBackgroundColor()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupBackgroundColor() {
        topBorderLine.backgroundColor = SwiftGenColors.gray4.color
        backgroundColor = SwiftGenColors.primaryBackground.color
    }
    
    private func setupView() {
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            topBorderLine.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
}
