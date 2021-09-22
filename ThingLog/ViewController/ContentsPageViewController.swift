//
//  ContentsPageViewController.swift
//  ThingLog
//
//  Created by hyunsu on 2021/09/21.
//

import UIKit
import RxSwift

class ContentsPageViewController: UIPageViewController {
    let controllers: [UIViewController] = [BoughtContentsCollectionViewController(),
                                           WishContentsCollectionViewController(),
                                           GiftContentsCollectionViewController()]
    
    var currentPageIndexSubject: PublishSubject = PublishSubject<Int>()
    var currentContentsOffsetYSubject: PublishSubject = PublishSubject<CGFloat>()
    var currentPageIndex: Int {
        guard let controller = viewControllers?.first,
              let idx = controllers.firstIndex(of: controller) else {
            return 0
        }
        return idx
    }
    
    var disposeBag: DisposeBag = DisposeBag()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        subscribeControllers()
    }
    
    func setupView() {
        view.backgroundColor = .gray
        dataSource = self
        delegate = self
        setViewControllers([controllers[0]], direction: .forward, animated: true, completion: nil)
    }
    
    
    /// 스크롤을 감지하여 위치값을 subscribe한다.
    func subscribeControllers() {
        controllers.forEach {
            if let controller = $0 as? BaseContentsCollectionViewController {
                controller.contentsOffsetYSubject
                    .subscribe(onNext: { [weak self] in
                        self?.currentContentsOffsetYSubject.onNext($0)
                    })
                    .disposed(by: controller.disposeBag)
            }
        }
    }
}

extension ContentsPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = controllers.firstIndex(of: viewController) else { return nil }
        var previousIndex: Int = index - 1
        previousIndex = previousIndex < 0 ? controllers.count - 1 : previousIndex
        return controllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = controllers.firstIndex(of: viewController) else { return nil }
        var afterIndex: Int = index + 1
        afterIndex = afterIndex >= controllers.count ? 0 : afterIndex
        return controllers[afterIndex]
    }
}

extension ContentsPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        currentPageIndexSubject.onNext(currentPageIndex)
    }
}

