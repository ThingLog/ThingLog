//
//  HomeViewController.swift
//  ThingLog
//
//  Created by hyunsu on 2021/09/22.
//

import UIKit

final class HomeViewController: UIViewController {
    var coordinator: Coordinator?
    
    var contentsContainerView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var contentsTabView: ContentsTabView = {
        let view: ContentsTabView = ContentsTabView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let pageViewController: ContentsPageViewController = {
        let controller: ContentsPageViewController = ContentsPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        return controller
    }()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupContainerView()
        setupContentsTabView()
        setupPageViewController()
    }
    
    func setupContainerView() {
        view.addSubview(contentsContainerView)
        NSLayoutConstraint.activate([
            contentsContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentsContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentsContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            contentsContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func setupContentsTabView() {
        contentsContainerView.addSubview(contentsTabView)
        NSLayoutConstraint.activate([
            contentsTabView.leadingAnchor.constraint(equalTo: contentsContainerView.leadingAnchor),
            contentsTabView.trailingAnchor.constraint(equalTo: contentsContainerView.trailingAnchor),
            contentsTabView.topAnchor.constraint(equalTo: contentsContainerView.safeAreaLayoutGuide.topAnchor),
            contentsTabView.heightAnchor.constraint(equalToConstant: 36)
        ])
    }
    
    func setupPageViewController() {
        addChild(pageViewController)
        contentsContainerView.addSubview(pageViewController.view)
        let pageView: UIView = pageViewController.view
        pageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageView.leadingAnchor.constraint(equalTo: contentsContainerView.leadingAnchor),
            pageView.trailingAnchor.constraint(equalTo: contentsContainerView.trailingAnchor),
            pageView.topAnchor.constraint(equalTo: contentsTabView.bottomAnchor),
            pageView.bottomAnchor.constraint(equalTo: contentsContainerView.bottomAnchor)
        ])
    }
}
