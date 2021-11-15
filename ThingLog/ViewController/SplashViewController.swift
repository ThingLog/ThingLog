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
    var coordinator: SplashCoordinator?
    
    let starAnimationView: AnimationView = {
        let view: AnimationView = AnimationView(name: "splash")
        view.animationSpeed = 1.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        // 애니메이션 동작후, 뷰컨트롤러 전환.
        starAnimationView.play { finished in
            if finished {
                self.coordinator?.next()
            }
        }
    }
}
