//
//  LeftLabelRightButtonTableCell.swift
//  ThingLog
//
//  Created by hyunsu on 2021/10/03.
//
import RxSwift
import UIKit
/* 구조
 contentsStackView: UIStackView  {
    [ leadingEmptyView, leftLabel, rightButton ]
 }
 
 stackView: UIStackView {
    [ emptyView,
      contentsStackView,
      emptyView2,
      borderLineView
    ]
 */

/// 좌측엔 label과 우측엔 Button이 있는 tableViewCell이다.
/// 내부적으로 위 아래, 양 옆에 padding이 있다.
final class LeftLabelRightButtonTableCell: UITableViewCell {
    var leftLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.Pretendard.body2
        label.textColor = SwiftGenColors.black.color
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    var rightButton: UIButton = {
        let button: UIButton = UIButton()
        button.setImage(SwiftGenAssets.clear.image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var borderLineView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = SwiftGenColors.gray4.color
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let emptyView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = SwiftGenColors.white.color
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let emptyView2: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = SwiftGenColors.white.color
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let leadingEmptyView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = SwiftGenColors.white.color
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var contentsStackView: UIStackView = {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [
                                                    leadingEmptyView,
                                                    leftLabel,
                                                    rightButton])
        stackView.axis = .horizontal
        return stackView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [
                                                    emptyView,
                                                    contentsStackView,
                                                    emptyView2,
                                                    borderLineView])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - Properties
    private let emptyViewHeight: CGFloat = 11
    private let rightButtonWidth: CGFloat = 40
    private let paddingConstraint: CGFloat = 16
    private let leadingEmptyViewWidth: CGFloat = 10
    var disposeBag: DisposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.backgroundColor = SwiftGenColors.white.color
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: paddingConstraint),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -paddingConstraint),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            
            rightButton.widthAnchor.constraint(equalToConstant: rightButtonWidth),
            borderLineView.heightAnchor.constraint(equalToConstant: 0.5),
            emptyView.heightAnchor.constraint(equalToConstant: emptyViewHeight),
            emptyView2.heightAnchor.constraint(equalToConstant: emptyViewHeight),
            leadingEmptyView.widthAnchor.constraint(equalToConstant: leadingEmptyViewWidth)
        ])
    }
    
    func updateLeftLabelTitle(_ title: String) {
        leftLabel.text = title
    }
}
