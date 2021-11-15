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
    }
}
