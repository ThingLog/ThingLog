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
        label.textColor = SwiftGenColors.primaryBlack.color
        return label
    }()

    private let indicatorButton: UIButton = {
        let button: UIButton = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(SwiftGenIcons.shortArrowRM.image.withTintColor(SwiftGenColors.primaryBlack.color), for: .normal)
        button.sizeToFit()
        return button
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView: UICollectionView = .init(frame: .zero,
                                                     collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isHidden = true
        collectionView.backgroundColor = .clear
        return collectionView
    }()

    private let trailingGradientView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()

    // MARK: - Properties
    var indicatorButtonDidTappedCallback: (() -> Void)?
    private let paddingLeading: CGFloat = 26.0
    private let paddingTrailing: CGFloat = 28.0
    private let paddingTopBottom: CGFloat = 20.0
    private let indicatorButtonSize: CGFloat = 40.0
    private let indicatorButtonTopBottom: CGFloat = 8.0
    private let trailingGradientViewWidth: CGFloat = 20.0
    private var categories: [Category] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.updateViewByCategories()
            }
        }
    }

    // MARK: - Rx
    var categorySubject: BehaviorSubject<[Category]> = BehaviorSubject<[Category]>(value: [])
    private var disposeBag: DisposeBag = DisposeBag()

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        bindCategorySubject()
    }

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupCollectionView()
        bindCategorySubject()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        trailingGradientView.frame = contentView.bounds
        trailingGradientView.frame.size.width = trailingGradientViewWidth
        trailingGradientView.setGradient(startColor: SwiftGenColors.primaryBackground.color,
                                         endColor: .white.withAlphaComponent(0),
                                         startPoint: CGPoint(x: 1.0, y: 1.0),
                                         endPoint: CGPoint(x: 0.0, y: 1.0))
    }

    // MARK: - Setup
    private func setupView() {
        selectionStyle = .none
        contentView.backgroundColor = SwiftGenColors.primaryBackground.color
        contentView.addSubviews(categoryLabel, indicatorButton, collectionView, trailingGradientView)

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
        collectionView.register(LabelWithButtonRoundCollectionCell.self, forCellWithReuseIdentifier: LabelWithButtonRoundCollectionCell.reuseIdentifier)

        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: paddingLeading),
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: paddingTopBottom),
            collectionView.trailingAnchor.constraint(equalTo: indicatorButton.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -indicatorButtonTopBottom),
            trailingGradientView.topAnchor.constraint(equalTo: contentView.topAnchor),
            trailingGradientView.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
            trailingGradientView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            trailingGradientView.widthAnchor.constraint(equalToConstant: trailingGradientViewWidth)
        ])

        collectionView.dataSource = self
    }

    /// 카테고리 선택 화면에서 전달 받은 데이터를 저장한다.
    private func bindCategorySubject() {
        categorySubject
            .bind { [weak self] categories in
                self?.categories = categories
                self?.collectionView.reloadData()
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
        categoryLabel.isHidden = !categories.isEmpty
        collectionView.isHidden = categories.isEmpty
        collectionView.reloadData()
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
        // 선택한 카테고리를 삭제하려고 할 때 NotificationCenter를 통해 WriteViewModel에게 알린다.
        cell.removeButtonDidTappedCallback = { [weak self] in
            guard var updateValue: [Category] = try? self?.categorySubject.value() else {
                return
            }

            collectionView.deleteItems(at: [indexPath])
            updateValue.remove(at: indexPath.item)
            self?.categorySubject.onNext(updateValue)
        }

        return cell
    }
}
