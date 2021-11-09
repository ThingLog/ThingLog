//
//  PostViewController+setup.swift
//  ThingLog
//
//  Created by 이지원 on 2021/11/09.
//

import UIKit

extension PostViewController {
    func setupTableView() {
        view.addSubviews(tableView)

        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.register(PostTableCell.self, forCellReuseIdentifier: PostTableCell.reuseIdentifier)
    }
}
