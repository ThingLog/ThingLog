//
//  WriteImageTableCell.swift
//  ThingLog
//
//  Created by 이지원 on 2021/10/18.
//

import Photos
import UIKit

/// 글쓰기 화면에서 이미지 등록 항목을 표시하기 위한 테이블뷰 셀, CollectionView를 가지고 있다.
/// ![이미지](https://www.notion.so/WriteImageTableCell-78b4a7fe55564fa380c554d17bee49e0)
final class WriteImageTableCell: UITableViewCell {
    private lazy var collectionView: UICollectionView = {
        let collectionView: UICollectionView = .init(frame: .zero,
                                                     collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.collectionViewLayout = createLayout()
        collectionView.backgroundColor = SwiftGenColors.white.color
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()

    private let userPermissions: UserPermissionsViewModel = UserPermissionsViewModel()
    private let thumbnailCellSize: CGFloat = 62.0
    private let collectionViewHeight: CGFloat = 64.0
    private let paddingLeadingConstaint: CGFloat = 18.0
    private let paddingTopConstaint: CGFloat = 12.0
    private let paddingBottomConstaint: CGFloat = 20.0
    var coordinator: WriteCoordinator?
    var thumbnailImages: [UIImage] = [] {
        didSet {
            collectionView.reloadData()
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WriteImageTableCell {
    private func setupView() {
        selectionStyle = .none

        contentView.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: paddingLeadingConstaint),
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: paddingTopConstaint),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -paddingBottomConstaint),
            collectionView.heightAnchor.constraint(equalToConstant: thumbnailCellSize)
        ])

        collectionView.register(CameraButtonCollectionCell.self, forCellWithReuseIdentifier: CameraButtonCollectionCell.reuseIdentifier)
        collectionView.register(ThumbnailCell.self, forCellWithReuseIdentifier: ThumbnailCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    private func createLayout() -> UICollectionViewCompositionalLayout {
        let itemSize: NSCollectionLayoutSize = .init(widthDimension: .absolute(thumbnailCellSize),
                                                     heightDimension: .absolute(thumbnailCellSize))
        let item: NSCollectionLayoutItem = .init(layoutSize: itemSize)

        let groupSize: NSCollectionLayoutSize = .init(widthDimension: .estimated(1.0),
                                                      heightDimension: .fractionalHeight(1))
        let group: NSCollectionLayoutGroup = .horizontal(layoutSize: groupSize, subitems: [item])

        let section: NSCollectionLayoutSection = .init(group: group)
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        section.interGroupSpacing = 14
        section.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 10)

        let layout: UICollectionViewCompositionalLayout = .init(section: section)
        return layout
    }

    /// 사용자에게 앨범 사용 접근 권한을 요청한다. 요청을 승인한 경우 PhotosViewController로 이동하고 요청을 거부한 경우 설정으로 이동을 안내하는 Alert을 띄운다.
    private func tappedCameraButton() {
        if #available(iOS 14, *) {
            userPermissions.requestPhotoLibraryAccessWithAccessLevel { isGranted in
                DispatchQueue.main.async { [weak self] in
                    isGranted ? self?.coordinator?.showPhotosViewController() : self?.coordinator?.showMoveSettingAlert()
                }
            }
        } else {
            userPermissions.requestPhotoLibraryAccess { isGranted in
                DispatchQueue.main.async { [weak self] in
                    isGranted ? self?.coordinator?.showPhotosViewController() : self?.coordinator?.showMoveSettingAlert()
                }
            }
        }
    }
}

// MARK: - DataSource
extension WriteImageTableCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // TODO: 1(카메라 버튼 셀) + 추가된 이미지 개수를 반환한다.
        1 + thumbnailImages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            guard let cell: CameraButtonCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: CameraButtonCollectionCell.reuseIdentifier, for: indexPath) as? CameraButtonCollectionCell else {
                return CameraButtonCollectionCell()
            }

            cell.update(count: thumbnailImages.count)

            return cell
        } else {
            guard let cell: ThumbnailCell = collectionView.dequeueReusableCell(withReuseIdentifier: ThumbnailCell.reuseIdentifier, for: indexPath) as? ThumbnailCell else {
                return ThumbnailCell()
            }

            let image: UIImage = thumbnailImages[indexPath.row - 1]
            cell.configure(image: image)

            cell.closeButtonDidTappedCallback = { [weak self] in
                collectionView.deleteItems(at: [indexPath])
                self?.thumbnailImages.remove(at: indexPath.row - 1)
                UIView.performWithoutAnimation {
                    collectionView.reloadSections(IndexSet(integer: indexPath.section))
                }
            }

            return cell
        }
    }
}

// MARK: - Delegate
extension WriteImageTableCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            tappedCameraButton()
        }
    }
}
