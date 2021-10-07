//
//  BoughtViewController.swift
//  ThingLog
//
//  Created by hyunsu on 2021/09/21.
//

import UIKit

class BoughtContentsCollectionViewController: BaseContentsCollectionViewController {
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        originScrollContentsHeight = collectionView.contentSize.height
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }
}
