//
//  EmptyPostView.swift
//  ThingLog
//
//  Created by hyunsu on 2021/10/08.
//

import UIKit

/// 검색결과가 없는 경우에  `키워드 + 검색결과 없음`을 나타내는 뷰다.
final class EmptyResultsView: UIView {
    private let emptyView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentHuggingPriority(.required, for: .vertical)
        return view
    }()
    
    private let label: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.Pretendard.body2
        label.textColor = SwiftGenColors.black.color
        label.text = "게시물 없음"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [
                                                    label,
                                                    emptyView])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupView() {
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            emptyView.heightAnchor.constraint(equalTo: stackView.heightAnchor,
                                              multiplier: 0.6)
        ])
    }
}

extension EmptyResultsView {
    // 검색결과 없습니다를 title과 함께 붙여 업데이트하는 메서드다
    func updateTitle(_ title: String ) {
        let text: String = title + "의 검색결과가 없습니다"
        label.text = text
        let attributedStr: NSMutableAttributedString = NSMutableAttributedString(string: text)
        attributedStr.addAttribute(NSAttributedString.Key.foregroundColor,
                                   value: SwiftGenColors.systemRed.color,
                                   range: (text as NSString).range(of: title) )
        label.attributedText = attributedStr
    }
}
