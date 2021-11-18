//
//  DropDownView+DataSource.swift
//  ThingLog
//
//  Created by 이지원 on 2021/11/10.
//

import UIKit

extension DropDownView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.reuseIdentifier, for: indexPath)

        let item: String = items[indexPath.row]
        cell.selectionStyle = .none
        cell.textLabel?.text = item
        cell.textLabel?.font = UIFont.Pretendard.body3
        cell.textLabel?.textColor = SwiftGenColors.primaryBlack.color
        cell.backgroundColor = SwiftGenColors.primaryBackground.color

        return cell
    }
}
