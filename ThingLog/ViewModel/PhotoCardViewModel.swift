//
//  PhotoCardViewModel.swift
//  ThingLog
//
//  Created by hyunsu on 2021/11/17.
//
import RxSwift
import UIKit

/// PhotoCardViewController의 데이터를 위한 ViewModel이다.
final class PhotoCardViewModel {
    // MARK: - Data Properties
    var postEntity: PostEntity
    var selectImage: UIImage
    var selectColorIndex: Int = 0 {
        didSet {
            selectColorSubject.onNext(colorList[selectColorIndex])
        }
    }
    var selectFrameIndex: Int = 0 {
        didSet {
            selectFrameSubject.onNext((frameList[selectFrameIndex],
                                       frameLineList[selectFrameIndex]))
        }
    }
    
    lazy var selectColorSubject: BehaviorSubject<UIColor> = BehaviorSubject(value: colorList[0])
    lazy var selectFrameSubject: BehaviorSubject<(UIImage, UIImage)> = BehaviorSubject(value: (frameList[0], frameLineList[0]))
    
    // MARK: - Default Properties
    let colorList: [UIColor] = [.black,  #colorLiteral(red: 0.9856583476, green: 0.4182627201, blue: 0.2466820776, alpha: 1),  #colorLiteral(red: 0.4393753409, green: 0.7447527051, blue: 0.6234906316, alpha: 1),  #colorLiteral(red: 0.24669227, green: 0.5205383301, blue: 0.9343541265, alpha: 1),  #colorLiteral(red: 1, green: 0.9198737741, blue: 0.424084425, alpha: 1),  #colorLiteral(red: 1, green: 0.9680470824, blue: 0.9291128516, alpha: 1)]
    /// 포토카드 하단의 프레임을 결정짓는 작은 아이콘리스트
    let smallFrameList: [UIImage] = [SwiftGenFrame.flower.image.withRenderingMode(.alwaysTemplate),
                                     SwiftGenFrame.heart.image.withRenderingMode(.alwaysTemplate),
                                     SwiftGenFrame.circle.image.withRenderingMode(.alwaysTemplate),
                                     SwiftGenFrame.biscuit.image.withRenderingMode(.alwaysTemplate)]
    /// 포토카드에 실제로 보여질 프레임 리스트
    let frameList: [UIImage] = [SwiftGenFrame.flowerBig.image.withRenderingMode(.alwaysTemplate),
                                SwiftGenFrame.heartBig.image.withRenderingMode(.alwaysTemplate),
                                SwiftGenFrame.circleBig.image.withRenderingMode(.alwaysTemplate),
                                SwiftGenFrame.biscuitBig.image.withRenderingMode(.alwaysTemplate)]
    /// 포토카드에 실제로 보여질 프레임의 라인 리스트
    let frameLineList: [UIImage] = [SwiftGenFrame.flowerLine.image.withRenderingMode(.alwaysTemplate),
                                    SwiftGenFrame.heartLine.image.withRenderingMode(.alwaysTemplate),
                                    SwiftGenFrame.circleLine.image.withRenderingMode(.alwaysTemplate),
                                    SwiftGenFrame.biscuitLine.image.withRenderingMode(.alwaysTemplate)]
    // MARK: - Init
    init(postEntity: PostEntity,
         selectImage: UIImage) {
        self.postEntity = postEntity
        self.selectImage = selectImage
    }
}
