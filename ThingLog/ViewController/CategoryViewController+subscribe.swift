//
//  CategoryViewController+subscribe.swift
//  ThingLog
//
//  Created by hyunsu on 2021/10/02.
//

import UIKit

extension CategoryViewController {
    /// CategoryView의 액션에 맞게 원하는 결과값이 담기는지 확인하기 위한 메서드다. 이것이 성공한다면 각 조합에 맞는 fetchRequest가 정상적으로 호출할 수 있다.
    func testViewModel() {
        print(viewModel.currentTopCategoryType)
        print(viewModel.currentSubCategoryType)
        print(viewModel.currentFilterType)
        print()
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
                    self?.testViewModel()
                })
                .disposed(by: disposeBag)
        }
    }
    
    /// "카테고리"의 sub Category를 선택하는 경우를 subscribe한다.
    func subscribeHorizontalCollectionView() {
        categoryView.horizontalCollectionView.categoryTitleSubject
            .subscribe( onNext: { [weak self] titleCategory in
                self?.viewModel.currentSubCategoryType = titleCategory
                self?.testViewModel()
            })
            .disposed(by: disposeBag)
    }
    
    /// 최상단 CategoryTab에서 특정 카테고리를 탭할 경우를 subscribe한다.
    func subscribeCategoryView() {
        categoryView.categoryTapView.topCategoryTypeSubject
            .subscribe(onNext: { [weak self] type in
                // 1. ViewModel 변경
                self?.viewModel.currentTopCategoryType = type
                
                // 2. HorizontalCollectionView 애니메이션
                UIView.animate(withDuration: 0.2) {
                    self?.categoryViewHeightConstriant?.constant = type == .category ? self?.categoryView.maxHeight ?? 0 : self?.categoryView.normalHeight ?? 0
                    self?.currentCategoryHeight = type == .category ? self?.categoryView.maxHeight ?? 0 : self?.categoryView.normalHeight ?? 0
                    
                    self?.view.layoutIfNeeded()
                }
                
                // 3. DropBox 변경
                self?.categoryView.categoryFilterView.updateDropBoxView(type, superView: self?.view ?? UIView() )
                
                // 4. DropBox가 전부 변경되므로 subscribe한다.
                self?.subscribeCategoryFilterView()
                
                // 5. HorizontalCollectionView 데이터 변경
                if type == .category {
                    // TODO: - ⚠️CoreData를 이용하여 가져올 예정이다.
                    self?.categoryView.horizontalCollectionView.categoryList = [
                        "학용품", "다이어리", "학용품", "다이어리", "학용품", "다이어리", "학용품", "다이어리",
                        "학용품", "다이어리", "학용품", "다이어리", "학용품", "다이어리", "학용품", "다이어리"
                    ]
                    self?.categoryView.horizontalCollectionView.isCollapse = false
                    self?.categoryView.horizontalCollectionView.reloadData()
                }
                
                self?.testViewModel()
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
}
