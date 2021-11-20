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
        collectionView.register(ButtonRoundCollectionCell.self, forCellWithReuseIdentifier: ButtonRoundCollectionCell.reuseIdentifier)
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
    
    // 이전의 선택한 셀을 찾기 위한 프로퍼티입니다.
    private var selectedIndexPath: IndexPath = IndexPath(row: 0, section: 0)
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
        setupBackgroundColor()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupBackgroundColor() {
        collectionView.backgroundColor = SwiftGenColors.primaryBackground.color
        backgroundColor = SwiftGenColors.primaryBackground.color
    }
    
    private func setupView() {
        
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ButtonRoundCollectionCell.reuseIdentifier, for: indexPath) as? ButtonRoundCollectionCell else { return UICollectionViewCell() }
        guard let item = fetchResultController?.fetchedObjects else {
            return cell
        }
        
        if selectedIndexPath == indexPath {
            changeButtonColor(isSelected: true, cell: cell)
            categoryTitleSubject.onNext(item[indexPath.row].title ?? "")
        } else {
            changeButtonColor(isSelected: false, cell: cell)
        }
        
        cell.updateView(title: item[indexPath.item].title ?? "", cornerRadius: buttonHeight / 2)
        
        return cell
    }
    
    /// ButtonRoundCollectionCell의 색을 강조하거나 강조하지 않는다.
    private func changeButtonColor(isSelected: Bool, cell: ButtonRoundCollectionCell) {
        cell.changeColor(borderColor: SwiftGenColors.primaryBlack.color,
                         backgroundColor: isSelected ? SwiftGenColors.primaryBlack.color : SwiftGenColors.primaryBackground.color,
                         textColor: isSelected ? SwiftGenColors.white.color : SwiftGenColors.primaryBlack.color)
    }
}

extension HorizontalCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.reloadData()
        
        selectedIndexPath = indexPath
        
        guard let item = fetchResultController?.fetchedObjects else {
            return
        }
        
        categoryTitleSubject.onNext(item[indexPath.row].title ?? "")
    }
}

extension HorizontalCollectionView: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        selectedIndexPath.item = 0 
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
