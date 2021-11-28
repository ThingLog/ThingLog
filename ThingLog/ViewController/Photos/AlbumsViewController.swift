//
//  AlbumsViewController.swift
//  ThingLog
//
//  Created by 이지원 on 2021/10/28.
//

import Photos
import UIKit

/// 사용자의 앨범 목록을 보여주기 위한 뷰 컨트롤러
final class AlbumsViewController: BaseViewController {
    // MARK: - View Properties
    private let collectionView: UICollectionView = {
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 80)
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        flowLayout.minimumLineSpacing = 20
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()

    // MARK: - Properties
    /// 최근 항목, 즐겨찾는 항목, 사용자 앨범이 각기 다른 타입의 데이터를 보여줘야 하기 때문에 섹션을 이용해 구분한다.
    enum AlbumSectionType: Int {
        case all
        case favorites
        case userCollections
    }

    private var sections: [AlbumSectionType] = [.all, .favorites, .userCollections]
    private var allPhotos: PHFetchResult<PHAsset> = PHFetchResult<PHAsset>()
    private var favorites: PHFetchResult<PHAssetCollection> = PHFetchResult<PHAssetCollection>()
    private var userCollections: PHFetchResult<PHAssetCollection> = PHFetchResult<PHAssetCollection>()
    private let defaultFetchOptions: PHFetchOptions = {
        let options: PHFetchOptions = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        options.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
        return options
    }()
    private let defaultImageRequestOptions: PHImageRequestOptions = {
        let options: PHImageRequestOptions = PHImageRequestOptions()
        options.resizeMode = .exact
        return options
    }()
    private var thumbnailSize: CGSize = CGSize()

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchAssets()
        PHPhotoLibrary.shared().register(self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let scale: CGFloat = UIScreen.main.scale
        let cellSize: CGSize = CGSize(width: UIScreen.main.bounds.width / 3, height: UIScreen.main.bounds.width / 3)
        thumbnailSize = CGSize(width: cellSize.width * scale, height: cellSize.height * scale)
    }

    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }

    override func setupView() {
        setupCollectionView()
    }
}

// MARK: - Private
extension AlbumsViewController {
    private func setupCollectionView() {
        view.backgroundColor = SwiftGenColors.primaryBackground.color

        view.addSubview(collectionView)

        let leadingTrailingSpacing: CGFloat = 16.0
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: leadingTrailingSpacing),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -leadingTrailingSpacing),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ImageWithVerticalTwoLabelCollectionCell.self,
                                forCellWithReuseIdentifier: ImageWithVerticalTwoLabelCollectionCell.reuseIdentifier)
    }

    /// allPhotos, favorites, userCollections 데이터를 fetch 한다.
    private func fetchAssets() {
        allPhotos = PHAsset.fetchAssets(with: defaultFetchOptions)
        favorites = PHAssetCollection.fetchAssetCollections(
            with: .smartAlbum,
            subtype: .smartAlbumFavorites,
            options: nil)
        userCollections = PHAssetCollection.fetchAssetCollections(
            with: .album,
            subtype: .albumRegular,
            options: nil)
    }
}

// MARK: - UITableView Delegate
extension AlbumsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sectionType: AlbumSectionType = sections[indexPath.section]
        switch sectionType {
        case .all:
            NotificationCenter.default.post(name: .selectAlbum, object: nil)
        case .favorites:
            NotificationCenter.default.post(name: .selectAlbum, object: nil, userInfo: [Notification.Name.selectAlbum: favorites[indexPath.item]])
        case .userCollections:
            NotificationCenter.default.post(name: .selectAlbum, object: nil,
                                            userInfo: [Notification.Name.selectAlbum: userCollections[indexPath.item]])
        }
    }
}

// MARK: - UITableView DataSource
extension AlbumsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch AlbumSectionType.init(rawValue: section) {
        case .all:
            return 1
        case .userCollections:
            return userCollections.count
        case .favorites:
            return 1
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: ImageWithVerticalTwoLabelCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageWithVerticalTwoLabelCollectionCell.reuseIdentifier, for: indexPath) as? ImageWithVerticalTwoLabelCollectionCell else {
            return UICollectionViewCell()
        }

        let sectionType: AlbumSectionType = sections[indexPath.section]
        switch sectionType {
        case .all:
            guard let firstAsset: PHAsset = allPhotos.firstObject else {
                cell.configure(image: nil,
                               title: "최근 항목",
                               description: "0")
                return cell
            }

            firstAsset.toImage(targetSize: thumbnailSize, options: defaultImageRequestOptions) { [weak self] image in
                cell.configure(image: image,
                               title: "최근 항목",
                               description: "\(self?.allPhotos.count ?? 0)")
            }
        case .favorites, .userCollections:
            let collection: PHAssetCollection = sectionType == .favorites ? favorites[indexPath.item] : userCollections[indexPath.item]

            let fetchedAssets: PHFetchResult<PHAsset> = PHAsset.fetchAssets(in: collection, options: defaultFetchOptions)

            guard let firstAsset: PHAsset = fetchedAssets.firstObject else {
                if sectionType == .favorites {
                    cell.configure(image: nil, title: collection.localizedTitle ?? "즐겨찾는 항목", description: "0")
                    return cell
                }
                return cell
            }

            firstAsset.toImage(targetSize: thumbnailSize, options: defaultImageRequestOptions) { image in
                cell.configure(image: image,
                               title: collection.localizedTitle ?? "",
                               description: "\(fetchedAssets.count)")
            }
        }

        return cell
    }
}

// MARK: - PhotoLibrary 변화 감지
extension AlbumsViewController: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        DispatchQueue.main.sync {
            if let changeDetails: PHFetchResultChangeDetails<PHAsset> = changeInstance.changeDetails(for: allPhotos) {
                allPhotos = changeDetails.fetchResultAfterChanges
            }

            if let changeDetails: PHFetchResultChangeDetails<PHAssetCollection> = changeInstance.changeDetails(for: favorites) {
                favorites = changeDetails.fetchResultAfterChanges
            }

            if let changeDetails: PHFetchResultChangeDetails<PHAssetCollection> = changeInstance.changeDetails(for: userCollections) {
                userCollections = changeDetails.fetchResultAfterChanges
            }

            collectionView.reloadData()
        }
    }
}
