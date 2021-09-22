//
//  ContentsTabView.swift
//  ThingLog
//
//  Created by hyunsu on 2021/09/22.
//

import RxSwift
import UIKit

/// 홈화면 ContentsCollectionView들이 보이는 상단의 탭을 나타내는 뷰다.
class ContentsTabView: UIView {
    var boughtButton: UIButton = {
        let button: UIButton = UIButton()
        let image: UIImage? = UIImage(named: "bought")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.setTitle("89", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.tintColor = .black
        return button
    }()
    
    var wishButton: UIButton = {
        let button: UIButton = UIButton()
        let image: UIImage? = UIImage(named: "wish")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.setTitle("89", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.tintColor = .gray
        return button
    }()
    
    var giftButton: UIButton = {
        let button: UIButton = UIButton()
        let image: UIImage? = UIImage(named: "gift")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.setTitle("89", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.tintColor = .gray
        return button
    }()
    
    var indicatorBar: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var topBorderLine: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = UIColor(white: 239.0 / 255.0, alpha: 1.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var buttonStackView: UIStackView = {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [boughtButton, wishButton, giftButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    var leadingAnchorIndicatorBar: NSLayoutConstraint?
    var disposeBag: DisposeBag = DisposeBag() 
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupView() {
        backgroundColor = .white 
        addSubview(topBorderLine)
        addSubview(indicatorBar)
        addSubview(buttonStackView)
        
        leadingAnchorIndicatorBar = indicatorBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0)
        leadingAnchorIndicatorBar?.isActive = true
        NSLayoutConstraint.activate([
            topBorderLine.leadingAnchor.constraint(equalTo: leadingAnchor),
            topBorderLine.trailingAnchor.constraint(equalTo: trailingAnchor),
            topBorderLine.topAnchor.constraint(equalTo: topAnchor),
            topBorderLine.heightAnchor.constraint(equalToConstant: 1),
            
            indicatorBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            indicatorBar.heightAnchor.constraint(equalToConstant: 1),
            indicatorBar.bottomAnchor.constraint(equalTo: bottomAnchor),
            indicatorBar.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1 / 3 ),
            
            buttonStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            buttonStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            buttonStackView.topAnchor.constraint(equalTo: topBorderLine.bottomAnchor),
            buttonStackView.bottomAnchor.constraint(equalTo: indicatorBar.topAnchor)
        ])
    }
    
    /// 선택한 index를 통하여 해당 버튼을 tint 시키고, 그 외 버튼들은 연한 색깔로 변경한다.
    /// - Parameters:
    ///   - index: 선택한 index를 넣는다.
    func updateButton(by index: Int) {
        buttonStackView.arrangedSubviews.forEach {
            if let button: UIButton = $0 as? UIButton {
                button.setTitleColor(.gray, for: .normal)
                button.tintColor = .gray
            }
        }
        switch index {
        case 0:
            boughtButton.setTitleColor(.black, for: .normal)
            boughtButton.tintColor = .black
        case 1:
            wishButton.setTitleColor(.black, for: .normal)
            wishButton.tintColor = .black
        default:
            giftButton.setTitleColor(.black, for: .normal)
            giftButton.tintColor = .black
        }
    }
    
    /// 선택한 index를 통하여 indicatorBar를 애니메이션으로 움직이는 메소드다.
    /// - Parameter index: 선택한 index를 넣는다.
    func updateIndicatorBar(by index: Int ) {
        UIView.animate(withDuration: 0.3) {
            self.leadingAnchorIndicatorBar?.constant = (UIScreen.main.bounds.width / 3 ) * CGFloat(index)
            self.layoutIfNeeded()
        }
    }
}
