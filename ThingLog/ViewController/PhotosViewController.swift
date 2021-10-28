//
//  PhotosViewController.swift
//  ThingLog
//
//  Created by 이지원 on 2021/10/27.
//

import Photos
import UIKit

import RxCocoa
import RxSwift

final class PhotosViewController: UIViewController {
    // MARK: - View Properties
    private let collectionView: UICollectionView = {
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 1
        flowLayout.minimumLineSpacing = 1
        flowLayout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 2) / 3,
                                     height: (UIScreen.main.bounds.width - 2) / 3)
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private let titleButton: UIButton = {
        let button: UIButton = UIButton()
        button.setTitle("사진첩 선택", for: .normal)
        button.setTitleColor(SwiftGenColors.black.color, for: .normal)
        button.titleLabel?.font = UIFont.Pretendard.button
        button.setImage(SwiftGenAssets.arrowDropDown.image, for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        return button
    }()

    private let successButton: UIButton = {
        let button: UIButton = UIButton()
        button.setTitle("확인", for: .normal)
        button.setTitleColor(SwiftGenColors.black.color, for: .normal)
        button.titleLabel?.font = UIFont.Pretendard.body1
        return button
    }()

    // MARK: - Properties
    var coordinator: WriteCoordinator?
    private var isShowAlbumsViewController: Bool = false {
        didSet {
            isShowAlbumsViewController ? titleButton.setImage(SwiftGenAssets.arrowDropUp.image, for: .normal) : titleButton.setImage(SwiftGenAssets.arrowDropDown.image, for: .normal)
        }
    }
    private lazy var assets: PHFetchResult<PHAsset> = fetchAssets(assetCollection: nil) {
        didSet {
            collectionView.reloadData()
        }
    }
    private var selectedIndexPath: [IndexPath] = []
    private var thumbnailSize: CGSize = CGSize()
    private let imageManager: PHCachingImageManager = PHCachingImageManager()
    private let disposeBag: DisposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = SwiftGenColors.white.color

        isShowAlbumsViewController = false
        setupNavigationBar()
        setupView()
        bindNavigationButton()
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

extension PhotosViewController {
    private func setupNavigationBar() {
        setupBaseNavigationBar()

        navigationItem.leftBarButtonItem = UIBarButtonItem(image: SwiftGenAssets.closeBig.image.withRenderingMode(.alwaysOriginal),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(didTapBackButton))

        navigationItem.titleView = titleButton
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: successButton)
    }

    private func setupView() {
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        collectionView.register(ContentsCollectionViewCell.self, forCellWithReuseIdentifier: ContentsCollectionViewCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    private func bindNavigationButton() {
        successButton.rx.tap
            .bind { [weak self] in
                // TODO: 선택한 이미지 전달
                self?.coordinator?.back()
            }.disposed(by: disposeBag)

        titleButton.rx.tap
            .bind { [weak self] in
                self?.isShowAlbumsViewController.toggle()
            }.disposed(by: disposeBag)
    }

    @objc
    private func didTapBackButton() {
        coordinator?.back()
    }

    @objc
    /// 사용자의 앨범으로부터 이미지를 가져온다.
    /// - Parameter assetCollection: 특정 앨범을 가져오고 싶은 경우 사용한다.
    /// - Returns: 모든 이미지를 반환한다. (assetCollection이 있는 경우, 해당 앨범의 모든 이미지를 반환한다.)
    private func fetchAssets(assetCollection: PHAssetCollection?) -> PHFetchResult<PHAsset> {
        let allPhotosOptions: PHFetchOptions = PHFetchOptions()
        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        allPhotosOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)

        guard let assetCollection = assetCollection else {
            return PHAsset.fetchAssets(with: allPhotosOptions)
        }

        return PHAsset.fetchAssets(in: assetCollection, options: nil)
    }
}

// MARK: - UIColelctionView Delegate
extension PhotosViewController: UICollectionViewDelegate {
}

// MARK: - UICollectionView DataSource
extension PhotosViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        assets.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentsCollectionViewCell.reuseIdentifier, for: indexPath) as? ContentsCollectionViewCell else {
            fatalError("Unable to dequeue PhotoCollectionViewCell")
        }

        // Camera Cell
        if indexPath.row == 0 {
            cell.update(image: SwiftGenAssets.camera.image)
            return cell
        }

        let asset: PHAsset = assets.object(at: indexPath.item)

        let options: PHImageRequestOptions = PHImageRequestOptions()
        options.resizeMode = .exact
        cell.representedAssetIdentifier = asset.localIdentifier
        imageManager.requestImage(for: asset, targetSize: thumbnailSize, contentMode: .aspectFill, options: options) { image, _ in
            if cell.representedAssetIdentifier == asset.localIdentifier {
                cell.update(image: image)
            }
        }

        cell.setupImageViewWithCheckButton()

        return cell
    }
}

extension PhotosViewController: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        guard let change = changeInstance.changeDetails(for: assets) else {
            return
        }

        DispatchQueue.main.async { [weak self] in
            self?.assets = change.fetchResultAfterChanges
            self?.collectionView.reloadData()
        }
    }
}
