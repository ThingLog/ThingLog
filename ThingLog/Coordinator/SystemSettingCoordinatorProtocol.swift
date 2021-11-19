//
//  SystemSettingCoordinator.swift
//  ThingLog
//
//  Created by hyunsu on 2021/11/18.
//

import UIKit

/// 시스템 설정을 가기 위한 메소드를 정의한 Coordinator 프로토콜이다. 미리 구현되어있다.
protocol SystemSettingCoordinatorProtocol: Coordinator, AnyObject {
    /// 사용자에게 사진 접근 권한이 없음을 알리고, 앱 설정으로 이동하는 버튼을 제공하는 Alert을 띄운다.
    ///
    /// 이 메서드를 호출하는 `WriteImageTableCell` 에서는 ViewController를 present 할 수 없기 때문에 coordinator에서 처리한다.
    func showMoveSettingAlert()

    /// 앱 설정 화면으로 이동한다.
    func moveAppSetting()
}

extension SystemSettingCoordinatorProtocol {
    func showMoveSettingAlert() {
        let alert: UIAlertController = UIAlertController(title: "",
                                                         message: "사진 접근 권한이 없습니다.\n설정 > 개인정보 보호 > 사진에서\n권한을 추가하세요.",
                                                         preferredStyle: .alert)
        let cancleAction: UIAlertAction = UIAlertAction(title: "취소",
                                                        style: .cancel,
                                                        handler: nil)
        let settingAction: UIAlertAction = UIAlertAction(title: "설정",
                                                         style: .default,
                                                         handler: { [weak self] _ in
            self?.moveAppSetting()
        })

        alert.addAction(cancleAction)
        alert.addAction(settingAction)
        navigationController.present(alert, animated: true, completion: nil)
    }
    
    func moveAppSetting() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }

        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}
