//
//  LoginViewController+dequeueCell.swift
//  ThingLog
//
//  Created by hyunsu on 2021/10/20.
//

import UIKit

extension LoginViewController {
    /// 빈 Cell를 보여주는 메소드다
    func dequeueEmptyView(_ collectionView: UICollectionView,
                          cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let emptyCell: UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: UICollectionViewCell.reuseIdentifier, for: indexPath)
        return emptyCell
    }
    
    /// 추천 소개 글의 셀을 보여주는 메서드다.
    func dequeueRecommandView(_ collectionView: UICollectionView,
                              cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: ButtonRoundCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: ButtonRoundCollectionCell.reuseIdentifier, for: indexPath)as? ButtonRoundCollectionCell else {
            return UICollectionViewCell()
        }
        let item: String = recommendList[indexPath.item]
        cell.changeButtonLayerBorderWidth(0.5)
        cell.changeColor(borderColor: SwiftGenColors.gray3.color,
                         backgroundColor: SwiftGenColors.white.color,
                         textColor: SwiftGenColors.black.color)
        cell.updateView(title: item, cornerRadius: 30 / 2)
        
        // ⚠️test1_Tint() 메서드와 같이 작용해야하는 코드
        //        if let selectedIndex: IndexPath = selectedIndexRecommend {
        //            if selectedIndex == indexPath {
        //                tint(cell, true)
        //            }
        //        }
        return cell
    }
    
    /// textField를 입력할 수 있는 cell을 보여주는 메서드다.
    func dequeueTextFieldCell(_ collectionView: UICollectionView,
                              cellForItemAt indexPath: IndexPath,
                              maximumTextCount: Int,
                              placeHolder: String) -> UICollectionViewCell {
        guard let cell: TextFieldWithLabelWithButtonCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: TextFieldWithLabelWithButtonCollectionCell.reuseIdentifier, for: indexPath)as? TextFieldWithLabelWithButtonCollectionCell else {
            return UICollectionViewCell()
        }
        cell.setupPlaceholder(text: placeHolder)
        cell.setupMaxTextCount(maximumTextCount)
        return cell
    }
}
