//
//  ImageSaver.swift
//  ThingLog
//
//  Created by hyunsu on 2021/11/17.
//

import UIKit

import Firebase

/// 사용자 앨범에 사진을 저장하는 기능을 하는 객체다.
final class ImageSaver: NSObject {
    private var completion: ((Error?) -> Void)?
    
    func saveToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image,
                                       self,
                                       #selector(saveError(_:didFinishSavingWithError:contextInfo:)), nil)
        Analytics.logEvent(AnalyticsEvents.savePhotocard.rawValue, parameters: [
            "event_name": AnalyticsEvents.savePhotocard.rawValue
        ])
    }
    
    init(completion: ((Error?) -> Void)? = nil ) {
        self.completion = completion
    }
    
    @objc
    private func saveError(_ image: UIImage,
                           didFinishSavingWithError error: Error?,
                           contextInfo: UnsafeRawPointer) {
        completion?(error)
    }
}
