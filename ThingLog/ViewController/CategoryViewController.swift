//
//  CategoryViewController.swift
//  ThingLog
//
//  Created by hyunsu on 2021/09/20.
//

import UIKit

final class CategoryViewController: UIViewController {
    var coordinator: Coordinator?
    
    // MARK: - Life cycle 
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = SwiftGenColors.white.color
        
        // Test 
        let label: UILabel = UILabel(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 100)))
        label.center = view.center
        label.backgroundColor = SwiftGenColors.white.color
        label.textColor = SwiftGenColors.black.color
        label.textAlignment = .center
        label.text = "Category"
        view.addSubview(label)
    }
}