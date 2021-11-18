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
    [ leadingEmptyView, leftLabel, rightToggleButton, rightButton, trailingEmptyView ]
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
/// 재사용하기 위해 우측 버튼은 버튼 또는 UISwitch로 변경할 수 있는 메서드가 있다.
/// 재사용하기 위해 좌측 Label의 폰트를 변경할 수 있는 메서드가 있다.
final class LeftLabelRightButtonTableCell: UITableViewCell {
    
    /// 우측 버튼을 UISwitch 또는 UIButton의 특정 이미지를 지정하는 타입
    enum ButtonType {
        case withClearButton // X 삭제 이미지 버튼
        case withToggleButton // UISwitch 버튼
        case withChevronRight // 오른쪽 화살표 이미지 버튼
    }
    
    /// 좌측 Label의 폰트를 지정하는 타입
    enum LabelFontType {
        case withBody1
        case withBody2
    }
    
    /// 하단의 경계선의 높이를 지정하는 타입
    enum BorderLineHeight {
        case with1Height // 1 높이
        case with05Height // 0.5 높이
    }
    
    /// 하단의 경계선의 색을 지정하는 타입
    enum BorderLineColor {
        case withGray5
        case withGray4
    }
    
    var leftLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.Pretendard.body2
        label.textColor = SwiftGenColors.primaryBlack.color
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.numberOfLines = 0
        return label
    }()
    
    var rightButton: UIButton = {
        let button: UIButton = UIButton()
        button.setImage(SwiftGenIcons.close.image.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = SwiftGenColors.primaryBlack.color
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setContentCompressionResistancePriority(.required, for: .horizontal)
        button.setContentHuggingPriority(.required, for: .horizontal)
        return button
    }()
    
    var rightToggleButton: UISwitch = {
        let button: UISwitch = UISwitch()
        button.tintColor = SwiftGenColors.gray3.color
        button.layer.cornerRadius = button.frame.height / 2.0
        button.backgroundColor = SwiftGenColors.gray3.color
        button.clipsToBounds = true
        button.onTintColor = SwiftGenColors.systemGreen.color
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setContentCompressionResistancePriority(.required, for: .horizontal)
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.isHidden = true
        return button
    }()
    
    private var borderLineView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let emptyView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let emptyView2: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let leadingEmptyView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let trailingEmptyView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentCompressionResistancePriority(.required, for: .horizontal)
        return view
    }()
    
    private lazy var contentsStackView: UIStackView = {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [
                                                    leadingEmptyView,
                                                    leftLabel,
                                                    rightToggleButton,
                                                    rightButton,
                                                    trailingEmptyView])
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
    private let trailingEmptyViewWidth: CGFloat = 5
    var disposeBag: DisposeBag = DisposeBag()
    private var borderLineHeightConstraint: NSLayoutConstraint?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupBackgroundColor()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupBackgroundColor() {
        contentView.backgroundColor = SwiftGenColors.primaryBackground.color
        borderLineView.backgroundColor = SwiftGenColors.gray4.color
    }
    private func setupView() {
        
        contentView.addSubview(stackView)
        selectionStyle = .none
        borderLineHeightConstraint = borderLineView.heightAnchor.constraint(equalToConstant: 0.5)
        borderLineHeightConstraint?.isActive = true
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: paddingConstraint),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -paddingConstraint),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            
            trailingEmptyView.widthAnchor.constraint(equalToConstant: trailingEmptyViewWidth),
            emptyView.heightAnchor.constraint(equalToConstant: emptyViewHeight),
            emptyView2.heightAnchor.constraint(equalToConstant: emptyViewHeight),
            leadingEmptyView.widthAnchor.constraint(equalToConstant: leadingEmptyViewWidth)
        ])
    }
}

extension LeftLabelRightButtonTableCell {
    func updateLeftLabelTitle(_ title: String ) {
        leftLabel.text = title
    }
    
    /// leftLabel의 폰트와 rightButton의 이미지 또는 toggle버튼으로 변경하는 메서드다.
    func changeViewType(labelType: LabelFontType,
                        buttonType: ButtonType,
                        borderLineHeight: BorderLineHeight,
                        borderLineColor: BorderLineColor) {
        changeLabelType(labelType: labelType)
        changeButtonType(buttonType: buttonType)
        changeBorderLineHeight(borderLineHeight: borderLineHeight)
        changeBorderLineColor(borderLineColor: borderLineColor)
    }

    private func changeLabelType(labelType: LabelFontType) {
        switch labelType {
        case .withBody1:
            leftLabel.font = UIFont.Pretendard.body1
            leadingEmptyView.isHidden = true
        case .withBody2:
            leftLabel.font = UIFont.Pretendard.body2
            leadingEmptyView.isHidden = false
        }
    }
    
    private func changeButtonType(buttonType: ButtonType) {
        switch buttonType {
        case .withChevronRight:
            let image: UIImage? = SwiftGenIcons.shortArrowRM.image.withRenderingMode(.alwaysTemplate)
            rightButton.setImage(image, for: .normal)
            rightButton.tintColor = SwiftGenColors.primaryBlack.color
            rightButton.isUserInteractionEnabled = false
            rightButton.isHidden = false
            rightToggleButton.isHidden = true
        case .withClearButton:
            let image: UIImage? = SwiftGenIcons.close.image.withRenderingMode(.alwaysTemplate)
            rightButton.setImage(image, for: .normal)
            rightButton.tintColor = SwiftGenColors.primaryBlack.color
            rightButton.isUserInteractionEnabled = true
            rightButton.isHidden = false
            rightToggleButton.isHidden = true
        case .withToggleButton:
            rightButton.isHidden = true
            rightToggleButton.isHidden = false
        }
    }
    
    private func changeBorderLineColor(borderLineColor: BorderLineColor) {
        switch borderLineColor {
        case .withGray4:
            borderLineView.backgroundColor = SwiftGenColors.gray4.color
        case .withGray5:
            borderLineView.backgroundColor = SwiftGenColors.gray5.color
        }
    }
    
    private func changeBorderLineHeight(borderLineHeight: BorderLineHeight) {
        switch borderLineHeight {
        case .with05Height:
            borderLineHeightConstraint?.constant = 0.5
        case .with1Height:
            borderLineHeightConstraint?.constant = 1
        }
    }
}
