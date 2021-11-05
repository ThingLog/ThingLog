//
//  SplashViewController.swift
//  ThingLog
//
//  Created by hyunsu on 2021/11/05.
//
import Lottie
import UIKit

/// 가장 처음에 앱이 시작될 때 보여지는 화면이다.
class SplashViewController: UIViewController {
    let starAnimationView: AnimationView = {
        let view: AnimationView = AnimationView(name: "splash")
        view.animationSpeed = 1.1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// 애니메이션이 끝난 후 호출 되는 클로저다.
    var lottieCompletion: (() -> Void)?
    
    /// 초기화를 담당하고, 애니메이션이 끝난 후 동작되기를 원하는 로직이 담긴 클로저를 주입한다.
    /// - Parameter lottieCompletion: 애니메이션이 끝난 후 동작되기를 원하는 로직.
    init(lottieCompletion: @escaping () -> Void) {
        self.lottieCompletion = lottieCompletion
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        setupView()
    }
    
    func setupView() {
        view.backgroundColor = SwiftGenColors.primaryBackground.color
        view.addSubview(starAnimationView)
        
        NSLayoutConstraint.activate([
            starAnimationView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            starAnimationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            starAnimationView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.65),
            starAnimationView.heightAnchor.constraint(equalTo: starAnimationView.widthAnchor)
        ])
        
        starAnimationView.play { (finished) in
            if finished {
                self.lottieCompletion?()
            }
        }
    }
}
