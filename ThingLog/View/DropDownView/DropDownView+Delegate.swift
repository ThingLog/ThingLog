//
//  DropDownView+Delegate.swift
//  ThingLog
//
//  Created by 이지원 on 2021/11/12.
//

import UIKit

extension DropDownView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        isShowDropDown.toggle()
        if indexPath.row == 0 {
            // TODO: 수정
            print("\(#function) 수정!")
            modifyPostCallback?()
        } else {
            // TODO: 삭제
            print("\(#function) 삭제!")
            removePostCallback?()
        }
    }
}
