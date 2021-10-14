//
//  TwoLabelVerticalHeaderView.swift
//  ThingLog
//
//  Created by hyunsu on 2021/10/14.
//

import UIKit

/// 상단에 titleLabel과 하단에subTitleLabel을 가지는 Collection HeaderView다.
///
/// 사용되는 곳 : 휴지통화면의 HeaderView
class TwoLabelVerticalHeaderView: UICollectionReusableView {
    // MARK: - View
    private let titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.Pretendard.title2
        label.textColor = SwiftGenColors.black.color
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.required, for: .vertical)
        label.text = "**개의 게시물"
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.Pretendard.body3
        label.textColor = SwiftGenColors.black.color
        label.setContentHuggingPriority(.required, for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "게시물이 삭제되기까지 남은 날짜를 보여줍니다. 해당 기간이 지나면 항목이 영구적으로 삭제됩니다. 최대 30일이 소요될 수 있습니다"
        return label
    }()
    
    private let emptyTopView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentHuggingPriority(.defaultLow, for: .vertical)
        return view
    }()
    
    private let emptyBottomView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentHuggingPriority(.defaultLow, for: .vertical)
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [
                                                    emptyTopView,
                                                    titleLabel,
                                                    subTitleLabel,
                                                    emptyBottomView])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let paddingConstraint: CGFloat = 30
    
    // MARK: - Init
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
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: paddingConstraint),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -paddingConstraint),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            emptyTopView.heightAnchor.constraint(equalTo: emptyBottomView.heightAnchor)
        ])
    }
    
    /// 상단의 제목을 변경하기 위한 메소드다
    /// - Parameter title: 변경하고자 하는 상단의 제목을 주입한다.
    func updateTitle(by title: String?) {
        titleLabel.text = title
    }
    
    /// 하단의 부제목을 변경하기 위한 메소드다
    /// - Parameter subTitle: 변경하고자 하는 하단의 부제목을 주입한다.
    func updateSubTitle(by subTitle: String?) {
        subTitleLabel.text = subTitle
    }
}
