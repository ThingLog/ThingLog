//
//  ContentsPageViewController.swift
//  ThingLog
//
//  Created by hyunsu on 2021/09/22.
//
import UIKit

class ContentsPageViewController: UIPageViewController {
    let controllers: [UIViewController] = [BoughtContentsCollectionViewController(),
                                           WishContentsCollectionViewController(),
                                           GiftContentsCollectionViewController()]
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
    }
}
