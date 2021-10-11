//
//  ContentsPageViewController.swift
//  ThingLog
//
//  Created by hyunsu on 2021/09/21.
//

import RxSwift
import UIKit

class ContentsPageViewController: UIPageViewController {
    let controllers: [UIViewController] = [BaseContentsCollectionViewController(willHideFilterView: true),
                                           BaseContentsCollectionViewController(willHideFilterView: true),
                                           BaseContentsCollectionViewController(willHideFilterView: true)]
    
    var currentPageIndexSubject: PublishSubject = PublishSubject<Int>()
    var currentScrollContentsOffsetYSubject: PublishSubject = PublishSubject<CGFloat>()
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
        view.backgroundColor = SwiftGenColors.white.color
        dataSource = self
        delegate = self
        setViewControllers([controllers[0]], direction: .forward, animated: true, completion: nil)
    }
    
    /// 스크롤을 감지하여 위치값을 subscribe하여 Subject에 주입시킨다.
    func subscribeControllers() {
        controllers.forEach {
            if let controller: BaseContentsCollectionViewController = $0 as? BaseContentsCollectionViewController {
                controller.scrollOffsetYSubject
                    .subscribe(onNext: { [weak self] in
                        self?.currentScrollContentsOffsetYSubject.onNext($0)
                    })
                    .disposed(by: controller.disposeBag)
            }
        }
    }
}

extension ContentsPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = controllers.firstIndex(of: viewController) else { return nil }
        let previousIndex: Int = index - 1
        if previousIndex < 0 {
            return nil
        } else {
            return controllers[previousIndex]
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = controllers.firstIndex(of: viewController) else { return nil }
        let afterIndex: Int = index + 1
        if afterIndex >= controllers.count {
            return nil
        } else {
            return controllers[afterIndex]
        }
    }
}

extension ContentsPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        currentPageIndexSubject.onNext(currentPageIndex)
    }
}

