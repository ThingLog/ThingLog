//
//  GiftViewController.swift
//  ThingLog
//
//  Created by hyunsu on 2021/09/21.
//

import UIKit

class GiftContentsCollectionViewController: BaseContentsCollectionViewController {
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBaseCollectionView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        originScrollContentsHeight = collectionView.contentSize.height
    }
}
