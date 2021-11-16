//
//  ViewController.swift
//  ThingLog
//
//  Created by 이지원 on 2021/08/23.
//
import CoreData
import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

/// PostViewController 테스트 용 뷰컨트롤러입니다. 추후에 PostViewController로 사용할 예정입니다. 
class TestPostViewController: UIViewController {
    var postViewModel: PostViewModelProtocol
    let testLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.Pretendard.headline2
        label.textColor = SwiftGenColors.primaryBlack.color
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(postViewModel: PostViewModelProtocol) {
        self.postViewModel = postViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubviews(testLabel)
        view.backgroundColor = SwiftGenColors.primaryBackground.color
        NSLayoutConstraint.activate([
            testLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            testLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        testLabel.text = "총 Post 개수: \(postViewModel.fetchedResultsController.fetchedObjects?.count ?? 0)개 \n 시작 위치: \(postViewModel.startIndexPath.row + 1)번째"
    }
}
