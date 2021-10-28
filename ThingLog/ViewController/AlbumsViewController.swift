//
//  AlbumsViewController.swift
//  ThingLog
//
//  Created by 이지원 on 2021/10/28.
//

import UIKit
import Photos

/// 사용자의 앨범 목록을 보여주기 위한 뷰 컨트롤러
final class AlbumsViewController: UIViewController {
    // MARK: - View Properties
    private let tableView: UITableView = {
        let tableView: UITableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        return tableView
    }()

    // MARK: - Properties
    enum AlbumSectionType: Int {
        case all
        case favorites
        case userCollections
    }

    private var sections: [AlbumSectionType] = [.all, .favorites, .userCollections]
    private var allPhotos: PHFetchResult<PHAsset> = PHFetchResult<PHAsset>()
    private var favorites: PHFetchResult<PHAssetCollection> = PHFetchResult<PHAssetCollection>()
    private var userCollections: PHFetchResult<PHAssetCollection> = PHFetchResult<PHAssetCollection>()
    private var thumbnailSize: CGSize = CGSize()
    private let imageManager: PHCachingImageManager = PHCachingImageManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchAssets()
        setupView()
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
}

// MARK: - Private
extension AlbumsViewController {
    private func setupView() {
        view.backgroundColor = .white

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ImageWithVerticalTwoLabelTableCell.self,
                           forCellReuseIdentifier: ImageWithVerticalTwoLabelTableCell.reuseIdentifier)
    }

    ///
    private func fetchAssets() {
        let allPhotosOptions: PHFetchOptions = PHFetchOptions()
        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        allPhotosOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)

        allPhotos = PHAsset.fetchAssets(with: allPhotosOptions)
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
extension AlbumsViewController: UITableViewDelegate {
}

// MARK: - UITableView DataSource
extension AlbumsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: ImageWithVerticalTwoLabelTableCell = tableView.dequeueReusableCell(withIdentifier: ImageWithVerticalTwoLabelTableCell.reuseIdentifier, for: indexPath) as? ImageWithVerticalTwoLabelTableCell else {
            return UITableViewCell()
        }

        let sectionType: AlbumSectionType = sections[indexPath.section]
        switch sectionType {
        case .all:
            let thumbnail: UIImage? = allPhotos.firstObject?.toImage(targetSize: thumbnailSize)
            cell.configure(image: thumbnail, title: "최근 항목", description: "\(allPhotos.count)")
        case .favorites, .userCollections:
            let collection: PHAssetCollection = sectionType == .favorites ? favorites[indexPath.item] : userCollections[indexPath.item]

            let fetchAssetOptions: PHFetchOptions = PHFetchOptions()
            fetchAssetOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            fetchAssetOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
            let fetchedAssets: PHFetchResult<PHAsset> = PHAsset.fetchAssets(in: collection, options: fetchAssetOptions)

            guard sectionType == .userCollections, let firstAsset = fetchedAssets.firstObject else {
                cell.configure(image: nil, title: "즐겨찾는 항목", description: "0")
                return cell
            }

            let options: PHImageRequestOptions = PHImageRequestOptions()
            options.resizeMode = .exact
            imageManager.requestImage(for: firstAsset,
                                      targetSize: thumbnailSize,
                                      contentMode: .aspectFill,
                                      options: options) { image, _ in
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

            tableView.reloadData()
        }
    }
}
