//
//  PhotoCardViewController+subscribe.swift
//  ThingLog
//
//  Created by hyunsu on 2021/11/17.
//

import RxSwift
import UIKit

extension PhotoCardViewController {
    /// 모양 또는 색 버튼을 누를 때 하단의 컬렉션뷰를 변경한다.
    func subscribeOptionView() {
        let shapeTapGesture: UITapGestureRecognizer = UITapGestureRecognizer()
        frameOptionView.addGestureRecognizer(shapeTapGesture)
        shapeTapGesture.rx.event.bind { [weak self] _ in
            self?.frameOptionView.tint(true)
            self?.colorOptionView.tint(false)
            self?.colorCollectionView.isHidden = true
            self?.frameCollectionView.isHidden = false
        }.disposed(by: disposeBag)
        
        let colorTapGesture: UITapGestureRecognizer = UITapGestureRecognizer()
        colorOptionView.addGestureRecognizer(colorTapGesture)
        colorTapGesture.rx.event.bind { [weak self] _ in
            self?.frameOptionView.tint(false)
            self?.colorOptionView.tint(true)
            self?.colorCollectionView.isHidden = false
            self?.frameCollectionView.isHidden = true
        }.disposed(by: disposeBag)
    }
    
    /// 색상 또는 모양을 변경할 때 옵저빙하여 포토카드 뷰를 변화시킨다.
    func subscribePhotoCardViewModel() {
        photoCardViewModel.selectColorSubject.bind { [weak self] color in
            self?.photoFrameView.tintColor = color
            self?.photoFrameLineView.tintColor = color == UIColor.black ? .white : .black
            self?.dateLabel.textColor = color == UIColor.black ? .white : .black
            self?.nameLabel.textColor = color == UIColor.black ? .white : .black
            self?.ratingView.tintButton(color == UIColor.black ? .white : .black)
        }.disposed(by: disposeBag)
        
        photoCardViewModel.selectFrameSubject.bind { [weak self] frame, line in
            self?.photoFrameView.image = frame
            self?.photoFrameLineView.image = line
        }.disposed(by: disposeBag)
    }
}
