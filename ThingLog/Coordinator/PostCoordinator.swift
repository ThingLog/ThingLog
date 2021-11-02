//
//  PostCoordinator.swift
//  ThingLog
//
//  Created by 이지원 on 2021/11/02.
//

import Foundation

protocol PostCoordinatorProtocol: Coordinator {
    func showPostViewController(with viewModel: PostViewModel)
}
