//
//  WriteCategoryTableCell.swift
//  ThingLog
//
//  Created by 이지원 on 2021/10/13.
//

import UIKit

import RxSwift

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
    var categories: [Category] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.updateViewByCategories()
            }
        }
    }
    private let paddingLeading: CGFloat = 26.0
    private let paddingTrailing: CGFloat = 28.0
    private let paddingTopBottom: CGFloat = 20.0
    private let indicatorButtonSize: CGFloat = 40.0
    private let indicatorButtonTopBottom: CGFloat = 8.0
    private var disposeBag: DisposeBag = DisposeBag()

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupCollectionView()
        bindCategories()
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
            indicatorButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: indicatorButtonTopBottom),
            indicatorButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -paddingTrailing),
            indicatorButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -indicatorButtonTopBottom)
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
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -indicatorButtonTopBottom)
        ])

        collectionView.dataSource = self
    }

    /// 카테고리 선택 화면에서 전달 받은 데이터를 저장한다.
    private func bindCategories() {
        NotificationCenter.default.rx.notification(.passToSelectedCategory, object: nil)
            .map { notification -> [Category] in
                notification.userInfo?[Notification.Name.passToSelectedCategory] as? [Category] ?? []
            }
            .bind { [weak self] categories in
                self?.categories = categories
            }.disposed(by: disposeBag)
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
    }

    /// categories 의 값에 따라 뷰를 업데이트한다.
    ///
    /// categories 값이 비어있는 경우 categoryLabel을 보여주고, collecionView를 숨긴다.
    /// categories 값이 있는 경우 categoryLabel을 숨기고 collectionView를 보여주고, collectionView.reloadData()를 호출한다.
    private func updateViewByCategories() {
        if categories.isEmpty {
            categoryLabel.isHidden = false
            collectionView.isHidden = true
        } else {
            categoryLabel.isHidden = true
            collectionView.isHidden = false
            collectionView.reloadData()
        }
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

        cell.configure(text: categories[indexPath.row].title)
        cell.removeButtonDidTappedCallback = {
            print("touch up \(indexPath.row)")
        }

        return cell
    }
}
