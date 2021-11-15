//
//  TrashViewController+Collection.swift
//  ThingLog
//
//  Created by hyunsu on 2021/11/01.
//
import CoreData
import UIKit

extension TrashViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numberOfItems: Int = fetchResultController?.fetchedObjects?.count ?? 0
        emptyView.isHidden = numberOfItems != 0
        return numberOfItems
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: ContentsCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentsCollectionViewCell.reuseIdentifier, for: indexPath)as? ContentsCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        // 휴지통에서 사용할 경우, ContentsCollectionViewCell의 뷰를 약간 조정한다.
        cell.setupForTrashView()
        cell.checkButton.isHidden = !isEditMode
        if isEditMode {
            if deleteStorage.contains(indexPath.item) {
                cell.changeCheckButton(isSelected: true)
            } else {
                cell.changeCheckButton(isSelected: false)
            }
        }
        cell.backgroundColor = .systemGray
        
        if let item: PostEntity = fetchResultController?.fetchedObjects?[indexPath.item],
           let data: Data = (item.attachments?.allObjects as? [AttachmentEntity])?.first?.thumbnail {
            cell.updateView(item)
            cell.bottomLabel.text = "\(29 - (item.deleteDate?.distanceFrom(Date()) ?? 0))일"
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TwoLabelVerticalHeaderView.reuseIdentifier, for: indexPath) as? TwoLabelVerticalHeaderView else {
            return UICollectionReusableView()
        }
        headerView.updateTitle(by: "\(fetchResultController?.fetchedObjects?.count ?? 0)개의 게시물")
        return headerView
    }
}

extension TrashViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isEditMode {
            guard let cell = collectionView.cellForItem(at: indexPath) as? ContentsCollectionViewCell else { return }
            
            if let index: Int = deleteStorage.firstIndex(of: indexPath.item) {
                deleteStorage.remove(at: index)
                cell.changeCheckButton(isSelected: false)
            } else {
                deleteStorage.append(indexPath.item)
                cell.changeCheckButton(isSelected: true)
            }
            
            var deleteStorageCount: String = String(deleteStorage.count)
            if deleteStorageCount == "0" {
                deleteStorageCount = ""
            }
            editButton.setTitle(deleteStorageCount + " 취소", for: .normal)
            editButton.sizeToFit()
        }
    }
}
