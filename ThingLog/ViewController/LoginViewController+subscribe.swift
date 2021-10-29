//
//  LoginViewController+subscribe.swift
//  ThingLog
//
//  Created by hyunsu on 2021/10/20.
//

import UIKit

extension LoginViewController {
    /// 유저 닉네임 textField `Enter` 키를 누르는 경우를 subscribe한다.
    func subscribeEnterKeyOfUserNameTextField(_ cell: TextFieldWithLabelWithButtonCollectionCell,
                                              _ collectionView: UICollectionView,
                                              cellForItemAt indexPath: IndexPath) {
        cell.textField.rx.controlEvent(.editingDidEndOnExit)
            .asObservable()
            .bind { [weak self] in
                self?.isEditMode = false
                
                // 하단의 한 줄 소개 뷰로 이동한다.
                guard let cell = collectionView.cellForItem(at: IndexPath(item: 0, section: LoginCollectionSection.userOneLine.section)) as? TextFieldWithLabelWithButtonCollectionCell else { return }
                cell.textField.becomeFirstResponder()
            }.disposed(by: cell.disposeBag)
    }
    
    /// 한 줄 소개 textField `Enter` 키를 누르는 경우를 subscribe한다.
    func subscribeEnterKeyOfUserOneLineTextField(_ cell: TextFieldWithLabelWithButtonCollectionCell,
                                                 _ collectionView: UICollectionView,
                                                 cellForItemAt indexPath: IndexPath) {
        cell.textField.rx.controlEvent(.editingDidEndOnExit)
            .asObservable()
            .bind { [weak self] in
                self?.deleteBottomPaddingSection()
            }.disposed(by: cell.disposeBag)
    }
    
    /// 공통적인 부분으로, 편집을 시작할 때,
    /// clear버튼 누를 때,
    /// toolBar버튼 누를 때를 subscribe한다.
    func subscribeTextFieldCell(_ cell: TextFieldWithLabelWithButtonCollectionCell,
                                _ collectionView: UICollectionView,
                                cellForItemAt indexPath: IndexPath) {
        cell.textField.rx.controlEvent(.editingDidBegin)
            .asObservable()
            .bind { [weak self] in
                if self?.isEditMode == true {
                    self?.moveTo(indexPath: indexPath, collectionView: collectionView)
                    return
                }
                self?.isEditMode = true
                
                // bottomPadding이 없는 경우에만 insert하여 약간의 스크롤 가능하게 한다.
                if collectionView.cellForItem(at: IndexPath(item: 0, section: LoginCollectionSection.bottomPadding.section)) == nil {
                    collectionView.insertSections(IndexSet(integer: LoginCollectionSection.bottomPadding.section))
                }
                
                self?.moveTo(indexPath: indexPath, collectionView: collectionView)
            }.disposed(by: cell.disposeBag)
        
        cell.clearButton.rx.tap.bind { 
            cell.textField.text = nil
            cell.hideCountingLabelAndClearButton(true)
        }
        .disposed(by: cell.disposeBag)
        
        cell.toolBarCheckButton.rx.tap
            .bind { [weak self] in
                self?.deleteBottomPaddingSection()
                cell.hideCountingLabelAndClearButton(true)
            }.disposed(by: cell.disposeBag)
    }
    
    func deleteBottomPaddingSection() {
        isEditMode = false
        collectionView.deleteSections(IndexSet(integer: LoginCollectionSection.bottomPadding.section))
    }
    
    func moveTo(indexPath: IndexPath, collectionView: UICollectionView) {
        if indexPath.section != LoginCollectionSection.userOneLine.section { return }
        guard let userOnLineCell = collectionView.cellForItem(at: indexPath) as? TextFieldWithLabelWithButtonCollectionCell else { return }
        let yPosition: CGFloat = userOnLineCell.frame.origin.y - 43.0
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.collectionView.setContentOffset(CGPoint(x: 0, y: yPosition), animated: true)
        }
    }
}
