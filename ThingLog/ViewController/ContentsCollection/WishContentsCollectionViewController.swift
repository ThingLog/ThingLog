//
//  WishViewController.swift
//  ThingLog
//
//  Created by hyunsu on 2021/09/21.
//

import UIKit

class WishContentsCollectionViewController: BaseContentsCollectionViewController {
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        collectionView.backgroundColor = .blue
        setupBaseCollectionView()
    }
}
