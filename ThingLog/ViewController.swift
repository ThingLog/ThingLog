//
//  ViewController.swift
//  ThingLog
//
//  Created by 이지원 on 2021/08/23.
//

import UIKit

class ViewController: UIViewController {
    var horizontalView: HorizontalCollectionView = {
        let view =  HorizontalCollectionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.addSubview(horizontalView)
        horizontalView.categoryList = ["학용품","다이어리","학용품","다이어리","학용품","다이어리","학용품","다이어리", "학용품","다이어리","학용품","다이어리","학용품","다이어리","학용품","다이어리"]
        NSLayoutConstraint.activate([
            horizontalView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            horizontalView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            horizontalView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            horizontalView.heightAnchor.constraint(equalToConstant: 44)
        ])
        // Do any additional setup after loading the view.
    }
}
