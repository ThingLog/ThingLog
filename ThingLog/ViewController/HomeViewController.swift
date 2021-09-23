//
//  HomeViewController.swift
//  ThingLog
//
//  Created by hyunsu on 2021/09/20.
//

import UIKit

final class HomeViewController: UIViewController {
    var coordinator: Coordinator?
    
    // MARK: - Life cycle 
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // Test
        let label: UILabel = UILabel(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 100)))
        label.center = view.center
        label.backgroundColor = .white
        label.textAlignment = .center
        label.textColor = .black
        label.text = "Home"
        view.addSubview(label)
    }
}
