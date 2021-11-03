//
//  PostTableCell+setup.swift
//  ThingLog
//
//  Created by 이지원 on 2021/11/02.
//

//
//  PostTableCell+setup.swift
//  ThingLog
//
//  Created by 이지원 on 2021/10/31.
//

import UIKit

// MARK: - PostTableCell Setup
extension PostTableCell {
    func setupHeaderView() {
        let headerViewHeight: CGFloat = 30.0
        let moreMenuButtonTrailingConstant: CGFloat = 18.0

        headerContainerView.addSubview(dateLabel)
        headerContainerView.addSubview(moreMenuButton)

        NSLayoutConstraint.activate([
            headerContainerView.heightAnchor.constraint(equalToConstant: headerViewHeight),
            dateLabel.centerXAnchor.constraint(equalTo: headerContainerView.centerXAnchor),
            dateLabel.topAnchor.constraint(equalTo: headerContainerView.topAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: headerContainerView.bottomAnchor),
            moreMenuButton.topAnchor.constraint(equalTo: headerContainerView.topAnchor),
            moreMenuButton.trailingAnchor.constraint(equalTo: headerContainerView.trailingAnchor, constant: -moreMenuButtonTrailingConstant),
            moreMenuButton.bottomAnchor.constraint(equalTo: headerContainerView.bottomAnchor)
        ])
    }

    func setupSlideImageCollectionView() {
        slideImageCollectionView.dataSource = slideImageViewDataSource
        slideImageCollectionView.register(ContentsCollectionViewCell.self, forCellWithReuseIdentifier: ContentsCollectionViewCell.reuseIdentifier)

        NSLayoutConstraint.activate([
            slideImageCollectionView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            slideImageCollectionView.heightAnchor.constraint(equalTo: slideImageCollectionView.widthAnchor)
        ])
    }

    func setupInteractionView() {
        let interactionViewHeight: CGFloat = 44.0
        let leadingTrailingSpacing: CGFloat = 18.0
        let topBottomSpacing: CGFloat = 10.0
        let betweenSpacing: CGFloat = 12.0

        NSLayoutConstraint.activate([
            interactionContainerView.heightAnchor.constraint(equalToConstant: interactionViewHeight),
            likeButton.leadingAnchor.constraint(equalTo: interactionContainerView.leadingAnchor, constant: leadingTrailingSpacing),
            likeButton.topAnchor.constraint(equalTo: interactionContainerView.topAnchor, constant: topBottomSpacing),
            likeButton.bottomAnchor.constraint(equalTo: interactionContainerView.bottomAnchor, constant: -topBottomSpacing),
            commentButton.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor, constant: betweenSpacing),
            commentButton.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor),
            imageCountLabel.centerXAnchor.constraint(equalTo: interactionContainerView.centerXAnchor),
            imageCountLabel.centerYAnchor.constraint(equalTo: interactionContainerView.centerYAnchor),
            photocardButton.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor),
            photocardButton.trailingAnchor.constraint(equalTo: interactionContainerView.trailingAnchor, constant: -leadingTrailingSpacing)
        ])
    }

    func setupCategoryCollectionView() {
        categoryCollectionView.collectionViewLayout = createLayout()
        categoryCollectionView.dataSource = categoryViewDataSource
        categoryCollectionView.register(LabelWithButtonRoundCollectionCell.self, forCellWithReuseIdentifier: LabelWithButtonRoundCollectionCell.reuseIdentifier)

        categoryCollectionView.heightAnchor.constraint(equalToConstant: 38.0).isActive = true
    }

    private func createLayout() -> UICollectionViewCompositionalLayout {
        let itemSize: NSCollectionLayoutSize = .init(widthDimension: .estimated(1), heightDimension: .estimated(1))
        let item: NSCollectionLayoutItem = .init(layoutSize: itemSize)

        let groupSize: NSCollectionLayoutSize = .init(widthDimension: .estimated(1),
                                                      heightDimension: .fractionalHeight(1))
        let group: NSCollectionLayoutGroup = .horizontal(layoutSize: groupSize, subitems: [item])

        let section: NSCollectionLayoutSection = .init(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 10
        section.contentInsets = .init(top: 8, leading: 10, bottom: 0, trailing: 10)

        let layout: UICollectionViewCompositionalLayout = .init(section: section)

        return layout
    }

    func setupFirstInfoView() {
        let firstInfoViewHeight: CGFloat = 38.0
        let leadingTrailingSpacing: CGFloat = 18.0

        NSLayoutConstraint.activate([
            firstInfoContainerView.heightAnchor.constraint(equalToConstant: firstInfoViewHeight),
            nameLabel.leadingAnchor.constraint(equalTo: firstInfoContainerView.leadingAnchor, constant: leadingTrailingSpacing),
            nameLabel.topAnchor.constraint(equalTo: firstInfoContainerView.topAnchor),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: ratingView.leadingAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: firstInfoContainerView.bottomAnchor),
            ratingView.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            ratingView.trailingAnchor.constraint(equalTo: firstInfoContainerView.trailingAnchor, constant: -leadingTrailingSpacing)
        ])
    }

    func setupSecondInfoView() {
        let secondInfoViewHeight: CGFloat = 38.0
        let leadingTrailingSpacing: CGFloat = 18.0

        NSLayoutConstraint.activate([
            secondInfoContainerView.heightAnchor.constraint(equalToConstant: secondInfoViewHeight),
            placeLabel.leadingAnchor.constraint(equalTo: secondInfoContainerView.leadingAnchor, constant: leadingTrailingSpacing),
            placeLabel.topAnchor.constraint(equalTo: secondInfoContainerView.topAnchor),
            placeLabel.trailingAnchor.constraint(lessThanOrEqualTo: priceLabel.leadingAnchor),
            placeLabel.bottomAnchor.constraint(equalTo: secondInfoContainerView.bottomAnchor),
            priceLabel.centerYAnchor.constraint(equalTo: placeLabel.centerYAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: secondInfoContainerView.trailingAnchor, constant: -leadingTrailingSpacing)
        ])
    }

    func setupContentsContainerView() {
        let topSpacing: CGFloat = 14.0
        let bottomSpacing: CGFloat = 16.0
        let leadingTrailingSpacing: CGFloat = 20.0

        NSLayoutConstraint.activate([
            lineView.heightAnchor.constraint(equalToConstant: 0.5),
            lineView.topAnchor.constraint(equalTo: contentsContainerView.topAnchor, constant: topSpacing),
            lineView.leadingAnchor.constraint(equalTo: contentsContainerView.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: contentsContainerView.trailingAnchor),
            contentTextView.topAnchor.constraint(equalTo: lineView.bottomAnchor, constant: topSpacing),
            contentTextView.leadingAnchor.constraint(equalTo: contentsContainerView.leadingAnchor, constant: leadingTrailingSpacing),
            contentTextView.trailingAnchor.constraint(equalTo: contentsContainerView.trailingAnchor, constant: -leadingTrailingSpacing),
            commentMoreButton.topAnchor.constraint(equalTo: contentTextView.bottomAnchor),
            commentMoreButton.leadingAnchor.constraint(equalTo: contentsContainerView.leadingAnchor, constant: leadingTrailingSpacing),
            commentMoreButton.trailingAnchor.constraint(lessThanOrEqualTo: contentsContainerView.trailingAnchor, constant: -leadingTrailingSpacing),
            commentMoreButton.bottomAnchor.constraint(equalTo: contentsContainerView.bottomAnchor, constant: -bottomSpacing)
        ])
    }

    func setupSpecificActionContainerView() {
        let trashButtonHeight: CGFloat = 54.0
        let boughtButtonHeight: CGFloat = 52.0
        let boughtButtonLeadingTrailingSpacing: CGFloat = 20.0

        NSLayoutConstraint.activate([
            boughtButton.leadingAnchor.constraint(equalTo: specificActionContainerView.leadingAnchor, constant: boughtButtonLeadingTrailingSpacing),
            boughtButton.topAnchor.constraint(equalTo: specificActionContainerView.topAnchor),
            boughtButton.trailingAnchor.constraint(equalTo: specificActionContainerView.trailingAnchor, constant: -boughtButtonLeadingTrailingSpacing),
            boughtButton.bottomAnchor.constraint(equalTo: specificActionContainerView.bottomAnchor),
            boughtButton.heightAnchor.constraint(equalToConstant: boughtButtonHeight),

            trashActionButton.leadingAnchor.constraint(equalTo: specificActionContainerView.leadingAnchor),
            trashActionButton.topAnchor.constraint(equalTo: specificActionContainerView.topAnchor),
            trashActionButton.trailingAnchor.constraint(equalTo: specificActionContainerView.trailingAnchor),
            trashActionButton.bottomAnchor.constraint(equalTo: specificActionContainerView.bottomAnchor),
            trashActionButton.heightAnchor.constraint(equalToConstant: trashButtonHeight)
        ])
        boughtButton.layer.cornerRadius = boughtButtonHeight / 2
    }

    func setupOtherView() {
        let emptySpacing: CGFloat = 40.0

        NSLayoutConstraint.activate([
            emptyView.heightAnchor.constraint(equalToConstant: emptySpacing)
        ])
    }

    func setupContentStackView() {
        NSLayoutConstraint.activate([
            contentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
