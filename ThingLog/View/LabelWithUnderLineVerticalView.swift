//
//  LabelWithUnderLineVerticalView.swift
//  ThingLog
//
//  Created by hyunsu on 2021/11/17.
//

import UIKit

/// 상단에 label과 하단에 밑줄있는 뷰다. [이미지링크](https://www.notion.so/LabelWithUnderLineVerticalView-e91f9eead6e04f1f912a34bbe2787934)
final class LabelWithUnderLineVerticalView: UIView {
    private let label: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.Pretendard.title1
        label.textColor = SwiftGenColors.primaryBlack.color
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let underLineView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [label, underLineView])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setupView() {
        addSubviews(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            underLineView.widthAnchor.constraint(equalTo: label.widthAnchor),
            underLineView.heightAnchor.constraint(equalToConstant: 2)
        ])
    }
}

extension LabelWithUnderLineVerticalView {
    /// 해당 뷰를 강조하거나 강조하지 않는다. 강조하는 경우에는 label의 색을 찐하게 하고, underLineView를 나타낸다. 강조하지 않는 경우에는 label색을 연하게 하고, underLineView를 숨긴다.
    func tint(_ bool: Bool) {
        label.textColor = bool ? SwiftGenColors.primaryBlack.color : SwiftGenColors.gray3.color
        underLineView.backgroundColor = bool ? SwiftGenColors.primaryBlack.color : .clear
    }
    
    func changeLabelText(_ text: String) {
        label.text = text
    }
}
