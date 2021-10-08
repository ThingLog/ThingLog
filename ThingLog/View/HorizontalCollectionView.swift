//
//  HorizontalCollectionView.swift
//  ThingLog
//
//  Created by hyunsu on 2021/09/28.
//
import CoreData
import RxSwift
import UIKit

/// 모아보기에서 최상단 카테고리 - "카테고리"를 선택했을 때, `CategoryEntity`들을 `horizontal`로 스크롤 가능한 뷰를 구성하기위한 뷰입니다.
final class HorizontalCollectionView: UIView {
    private var collectionView: UICollectionView = {
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(RoundButtonCollectionViewCell.self, forCellWithReuseIdentifier: RoundButtonCollectionViewCell.reuseIdentifier)
        collectionView.backgroundColor = SwiftGenColors.white.color
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    // MARK: - Properties
    var fetchResultController: NSFetchedResultsController<CategoryEntity>? {
        didSet {
            fetchResultController?.delegate = self
        }
    }
    // CoreData가 외부에서 변경될 때 호출하는 클로저다
    var completionBlock: ((Int) -> Void)?
    
    private var selectedIndexCell: IndexPath = IndexPath(item: 0, section: 0)
    private let buttonHeight: CGFloat = 26
    
    // 특정 Category를 선택할 때 마다 전달하기 위한 subject입니다.
    var categoryTitleSubject: PublishSubject<String> = PublishSubject()
    
    // 이를 통해 CollectionView Cell Size를 동적으로 관리한다. 
    var isCollapse: Bool = true {
        didSet {
            // 같은 요청은 무시하기 위함
            if oldValue == isCollapse {
                return
            }
            collectionView.reloadData()
        }
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupView() {
        backgroundColor = SwiftGenColors.white.color
        addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self

        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor)
        ])
    }
    
    /// 외부에서 CategoryEntity 리스트를 Fetch하여 reload시키기 위함입니다.
    func reloadData() {
        collectionView.reloadData()
    }
}

extension HorizontalCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        fetchResultController?.fetchedObjects?.count ?? 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RoundButtonCollectionViewCell.reuseIdentifier, for: indexPath) as? RoundButtonCollectionViewCell else { return UICollectionViewCell() }
        guard let item = fetchResultController?.fetchedObjects else {
            return cell
        }
    
        if selectedIndexCell == indexPath {
            cell.changeButtonColor(isSelected: true)
            categoryTitleSubject.onNext(item[indexPath.row].title ?? "")
        }
        cell.updateView(title: item[indexPath.item].title ?? "", cornerRadius: buttonHeight / 2)
        
        return cell
    }
}

extension HorizontalCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? RoundButtonCollectionViewCell else {
            return
        }
        cell.changeButtonColor(isSelected: true)
        
        if selectedIndexCell != indexPath,
           let cell: RoundButtonCollectionViewCell = collectionView.cellForItem(at: selectedIndexCell) as? RoundButtonCollectionViewCell {
            cell.changeButtonColor(isSelected: false)
        }
        
        selectedIndexCell = indexPath
        
        guard let item = fetchResultController?.fetchedObjects else {
            return
        }
        
        categoryTitleSubject.onNext(item[indexPath.row].title ?? "")
    }
}

extension HorizontalCollectionView: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionView.reloadData()
        completionBlock?(controller.fetchedObjects?.count ?? 0)
    }
}

extension HorizontalCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let categories = fetchResultController?.fetchedObjects else {
            return CGSize(width: 0, height: 0)
        }
        
        let item: String = categories[indexPath.row].title ?? ""
        var itemSize: CGSize = item.size(withAttributes: [
            NSAttributedString.Key.font: UIFont.Pretendard.body2
        ])
        itemSize.width += 20
        itemSize.height = isCollapse ? 0 : buttonHeight
        return itemSize
    }
}
