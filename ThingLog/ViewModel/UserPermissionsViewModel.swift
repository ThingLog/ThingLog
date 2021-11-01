//
//  UserPermissionsViewModel.swift
//  ThingLog
//
//  Created by 이지원 on 2021/11/01.
//

import Foundation
import Photos

final class UserPermissionsViewModel {
    @available(iOS 14, *)
    /// 사용자에게 앨범 사용 권한을 요청한다. iOS 14 이상 버전인 경우 이 메서드를 사용한다.
    /// - Parameter completion: 권한이 승인된 경우 true, 권한이 거부당한 경우 false를 반환한다.
    func requestPhotoLibraryAccessWithAccessLevel(completion: @escaping (Bool) -> Void) {
        let requiredAccessLevel: PHAccessLevel = .readWrite
        PHPhotoLibrary.requestAuthorization(for: requiredAccessLevel) { status in
            PHPhotoLibrary.requestAuthorization { status in
                switch status {
                case .authorized: // 권한 승인
                    completion(true)
                case .denied, .restricted: // 권한 거절
                    completion(false)
                case .notDetermined: // 권한 미설정
                    completion(false)
                case .limited: // 권한 일부 승인
                    completion(true)
                @unknown default:
                    fatalError("Unimplemented")
                }
            }
        }
    }

    /// 사용자에게 앨범 사용 권한을 요청한다. iOS 14 이하 버전인 경우 이 메서드를 사용한다.
    /// - Parameter completion: 권한이 승인된 경우 true, 권한이 거부당한 경우 false를 반환한다.
    func requestPhotoLibraryAccess(completion: @escaping (Bool) -> Void) {
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized: // 권한 승인
                completion(true)
            case .denied, .restricted: // 권한 거절
                completion(false)
            case .notDetermined: // 권한 설정을 하지 않음
                completion(false)
            @unknown default:
                fatalError("Unimplemented")
            }
        }
    }
}
