//
//  WriteCategoryTableCell.swift
//  ThingLog
//
//  Created by 이지원 on 2021/10/13.
//

import UIKit

/// 글쓰기 화면에서 카테고리 항목을 나타내는 셀
/// 카테고리가 선택되어 있다면 CollectionView를 통해 선택된 카테고리 항목을 보여주고, 선택되어 있지 않다면 Label을 보여준다.
final class WriteCategoryTableCell: UITableViewCell {
    private let categoryLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "카테고리"
        label.font = UIFont.Pretendard.body1
        label.textColor = SwiftGenColors.black.color
        return label
    }()

    private let indicatorButton: UIButton = {
        let button: UIButton = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(SwiftGenAssets.chevronRight.image, for: .normal)
        button.sizeToFit()
        return button
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView: UICollectionView = .init(frame: .zero,
                                                     collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isHidden = true
        collectionView.backgroundColor = SwiftGenColors.white.color
        return collectionView
    }()

    // MARK: - Properties
    var indicatorButtonDidTappedCallback: (() -> Void)?
    private(set) var isSelectedCategory: Bool = false {
        didSet {
            categoryLabel.isHidden.toggle()
            collectionView.isHidden.toggle()
        }
    }
    // TODO: 카테고리 화면에서 선택한 데이터로 대체
    private let categories: [String] = ["사무용품", "가전제품", "문구", "화장품", "주방", "뭐 이런 게 다 있는 지 모르겠어요"]

    private let paddingLeading: CGFloat = 26.0
    private let paddingTrailing: CGFloat = 28.0
    private let paddingTopBottom: CGFloat = 20.0

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupCollectionView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        selectionStyle = .none

        contentView.addSubview(categoryLabel)
        contentView.addSubview(indicatorButton)

        NSLayoutConstraint.activate([
            categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: paddingLeading),
            categoryLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: paddingTopBottom),
            categoryLabel.trailingAnchor.constraint(equalTo: indicatorButton.leadingAnchor),
            categoryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -paddingTopBottom),
            indicatorButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: paddingTopBottom),
            indicatorButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -paddingTrailing),
            indicatorButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -paddingTopBottom)
        ])

        indicatorButton.addTarget(self, action: #selector(tappedIndicatorButton), for: .touchUpInside)
    }

    private func setupCollectionView() {
        contentView.addSubview(collectionView)

        collectionView.register(LabelWithButtonRoundCollectionCell.self, forCellWithReuseIdentifier: LabelWithButtonRoundCollectionCell.reuseIdentifier)

        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: paddingLeading),
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: paddingTopBottom),
            collectionView.trailingAnchor.constraint(equalTo: indicatorButton.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -paddingTopBottom)
        ])

        collectionView.dataSource = self
    }

    private func createLayout() -> UICollectionViewCompositionalLayout {
        let itemSize: NSCollectionLayoutSize = .init(widthDimension: .estimated(44), heightDimension: .estimated(26))
        let item: NSCollectionLayoutItem = .init(layoutSize: itemSize)

        let group: NSCollectionLayoutGroup = .horizontal(layoutSize: itemSize, subitems: [item])

        let section: NSCollectionLayoutSection = .init(group: group)
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        section.interGroupSpacing = 10

        let layout: UICollectionViewCompositionalLayout = .init(section: section)
        return layout
    }

    @objc
    private func tappedIndicatorButton() {
        indicatorButtonDidTappedCallback?()
        isSelectedCategory.toggle()
    }
}

extension WriteCategoryTableCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categories.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: LabelWithButtonRoundCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: LabelWithButtonRoundCollectionCell.reuseIdentifier, for: indexPath) as? LabelWithButtonRoundCollectionCell else {
            return LabelWithButtonRoundCollectionCell()
        }

        cell.configure(text: categories[indexPath.row])
        cell.removeButtonDidTappedCallback = {
            print("touch up \(indexPath.row)")
        }

        return cell
    }
}
