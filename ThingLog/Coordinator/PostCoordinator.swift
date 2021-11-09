//
//  PostCoordinator.swift
//  ThingLog
//
//  Created by 이지원 on 2021/11/02.
//

import Foundation

protocol PostCoordinatorProtocol: Coordinator {
    /// `PostViewController`를 보여준다. `PostViewController`에서 데이터를 표시하기 위해 `PostViewModel`이 필요하다.
    func showPostViewController(with viewModel: PostViewModel)
}
