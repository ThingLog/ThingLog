//
//  CategoryViewController+subscribe.swift
//  ThingLog
//
//  Created by hyunsu on 2021/10/02.
//
import CoreData
import UIKit

extension CategoryViewController {
    func fetchAllCategory() {
        categoryView.horizontalCollectionView.fetchResultController = categoryRepo.fetchedResultsController
    }
    
    /// CategoryView의 액션에 맞게 원하는 결과값이 담기는지 확인하기 위한 메서드다. 이것이 성공한다면 각 조합에 맞는 fetchRequest가 정상적으로 호출할 수 있다.
    func fetchAllPosts() {
        viewModel.fetchRequest { result in
            switch result {
            case .success(_):
                self.contentsViewController.fetchResultController = self.viewModel.fetchResultController
                let fetchedCount: Int? = self.viewModel.fetchResultController?.fetchedObjects?.count
                self.updateResultsCountView(fetchedCount: fetchedCount)
                self.contentsViewController.collectionView.reloadData()
            case .failure(_):
                return
            }
        }
    }
    
    /// 드롭박스를 탭할 경우를 subscribe한다.
    func subscribeCategoryFilterView() {
        categoryView.categoryFilterView.stackView.arrangedSubviews.forEach {
            guard let dropBox: DropBoxView = $0 as? DropBoxView else {
                return
            }
            dropBox.selectFilterTypeSubject
                .subscribe( onNext: { [weak self] (value: (FilterType, String)) in
                    // ViewModel 변경
                    self?.viewModel.changeCurrentFilterType(type: value.0, value: value.1)
                    self?.fetchAllPosts()
                })
                .disposed(by: disposeBag)
        }
    }
    
    /// "카테고리"의 sub Category를 선택하는 경우를 subscribe한다.
    func subscribeHorizontalCollectionView() {
        categoryView.horizontalCollectionView.categoryTitleSubject
            .subscribe( onNext: { [weak self] titleCategory in
                self?.viewModel.currentSubCategoryType = titleCategory
                self?.fetchAllPosts()
            })
            .disposed(by: disposeBag)
    }
    
    /// 최상단 CategoryTab에서 특정 카테고리를 탭할 경우를 subscribe한다.
    func subscribeCategoryView() {
        categoryView.categoryTapView.topCategoryTypeSubject
            .subscribe(onNext: { [weak self] type in
                // 1. ViewModel 변경
                self?.viewModel.currentTopCategoryType = type
                
                // 2. DropBox 변경
                self?.categoryView.categoryFilterView.updateDropBoxView(type, superView: self?.view ?? UIView())
                self?.view.layoutIfNeeded()
                
                // 3. DropBox가 전부 변경되므로 subscribe한다.
                self?.subscribeCategoryFilterView()
                
                // 4. HorizontalCollectionView 높이 변경
                self?.hideHorizontalCollectionView(type != .category)
                
                self?.fetchAllPosts()
            })
            .disposed(by: disposeBag)
    }
    
    /// CollectionView 스크롤을 subscribe 하여 상단 탭을 애니메이션 한다.
    func subscribeBaseControllerScrollOffset() {
        contentsViewController.scrollOffsetYSubject
            .subscribe(onNext: { [weak self] dist in
                if dist >= 0 {
                    self?.categoryView.horizontalCollectionView.isCollapse = true
                    self?.view.layoutIfNeeded()
                } else if self?.categoryViewHeightConstriant?.constant == self?.categoryView.maxHeight {
                    self?.categoryView.horizontalCollectionView.isCollapse = false
                    self?.view.layoutIfNeeded()
                }
                
                guard let currentConstant = self?.categoryViewHeightConstriant?.constant else { return }
                var dist: CGFloat = dist
                
                // 카테고리 사라질 때
                if dist >= 0 {
                    dist = max(currentConstant - dist, 0)
                } else {
                    // 카테고리 나타날 때
                    dist = min(currentConstant - dist, self?.currentCategoryHeight ?? 0)
                    self?.showTopButton(false)
                }
                
                if dist <= 1 {
                    self?.showTopButton(true)
                }
                
                self?.categoryViewHeightConstriant?.constant = dist
            })
            .disposed(by: disposeBag)
    }
    
    /// 카테고리의 서브카테고리 뷰의 높이를 변경하는 메서드다
    private func hideHorizontalCollectionView(_ bool: Bool) {
        let subCategoryCount: Int = categoryRepo.fetchedResultsController.fetchedObjects?.count ?? 0
        
        UIView.animate(withDuration: 0.2) {
            self.categoryViewHeightConstriant?.constant = (bool || subCategoryCount == 0) ? self.categoryView.normalHeight :  self.categoryView.maxHeight
            self.currentCategoryHeight = (bool || subCategoryCount == 0) ? self.categoryView.normalHeight: self.categoryView.maxHeight
            self.view.layoutIfNeeded()
            self.categoryView.horizontalCollectionView.isCollapse = bool
        }
    }
    
    /// Post의 NSfetchResultsController의 Delegate - didChangeContents에 반응할 클로저를 세팅한다.
    func setupContentsViewControllerCompletion() {
        contentsViewController.completionBlock = { [weak self] updatedFetchCount in
            self?.updateResultsCountView(fetchedCount: updatedFetchCount)
        }
    }
    
    /// Category의 NSfetchResultsController의 Delegate - didChangeContents에 반응할 클로저를 세팅한다.
    func setupHorizontalColletionCompletion() {
        categoryView.horizontalCollectionView.completionBlock = { [weak self] _ in
            if self?.viewModel.currentTopCategoryType == .category {
                self?.hideHorizontalCollectionView(false)
            }
        }
    }

    /// CategoryView의 하단에 fetch된 Post개시물의 개수를 업데이트하는 메서드다
    /// - Parameter fetchedCount: fetch된 Post개시물의 개수를 주입한다.
    private func updateResultsCountView(fetchedCount: Int?) {
        self.categoryView.categoryFilterView.updateResultTotalLabel(by: "총" + String(fetchedCount ?? 0) + "건")
    }
}
