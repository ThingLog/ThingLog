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

/// 사진 목록을 보여주기 위한 뷰 컨트롤러
final class PhotosViewController: BaseViewController {
    // MARK: - View Properties
    let collectionView: UICollectionView = {
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 1
        flowLayout.minimumLineSpacing = 1
        flowLayout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 2) / 3,
                                     height: (UIScreen.main.bounds.width - 2) / 3)
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private let titleButton: UIButton = {
        let button: UIButton = UIButton()
        button.setTitle("사진첩 선택", for: .normal)
        button.setTitleColor(SwiftGenColors.primaryBlack.color, for: .normal)
        button.titleLabel?.font = UIFont.Pretendard.button
        button.setImage(SwiftGenIcons.arrowDropDown.image.withTintColor(SwiftGenColors.gray3.color),
                        for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        return button
    }()
    
    private let selectedCountLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.Pretendard.title2
        label.textColor = SwiftGenColors.primaryBlack.color
        label.sizeToFit()
        return label
    }()
    
    private let successButton: UIButton = {
        let button: UIButton = UIButton()
        button.setTitle("확인", for: .normal)
        button.setTitleColor(SwiftGenColors.primaryBlack.color, for: .normal)
        button.setTitleColor(SwiftGenColors.gray4.color, for: .disabled)
        button.titleLabel?.font = UIFont.Pretendard.body1
        button.sizeToFit()
        return button
    }()
    
    /// 크롭뷰컨트롤러를 거치지 않고, 이미지를 1:1비율로 저장하기 위한 보이지 않는 이미지 뷰다.
    private let imageViewForSave: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Properties
    lazy var imagePickerController: UIImagePickerController = {
        let imagePickerController: UIImagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .camera
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        return imagePickerController
    }()
    let imageManager: PHCachingImageManager = PHCachingImageManager.default() as! PHCachingImageManager
    var previousPreheatRect: CGRect = .zero
    let selectedMaxCount: Int = 10
    var coordinator: WriteCoordinatorProtocol?
    var selectedIndexPath: [(index: IndexPath, image: UIImage?)] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.updateSelectedOrder()
                self?.updateSelectedCountLabel()
            }
        }
    }
    
    lazy var assets: PHFetchResult<PHAsset> = fetchAssets(assetCollection: nil) {
        didSet {
            collectionView.reloadData()
            collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        }
    }
    private(set) var thumbnailSize: CGSize = CGSize()
    var cropViewController: CropViewController?
    private(set) var albumsViewController: AlbumsViewController = AlbumsViewController()
    private var isShowAlbumsViewController: Bool = false {
        didSet {
            titleButton.imageView?.transform = isShowAlbumsViewController ? .identity : CGAffineTransform(rotationAngle: .pi)
        }
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        selectedIndexPath = []
        isShowAlbumsViewController = false
        resetCachedAssets()
        
        PHPhotoLibrary.shared().register(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let scale: CGFloat = UIScreen.main.scale
        let cellSize: CGSize = CGSize(width: UIScreen.main.bounds.width / 3, height: UIScreen.main.bounds.width / 3)
        thumbnailSize = CGSize(width: cellSize.width * scale, height: cellSize.height * scale)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateCachedAssets()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        albumsViewController.willMove(toParent: nil)
        albumsViewController.view.removeFromSuperview()
        albumsViewController.removeFromParent()
        
        NotificationCenter.default.removeObserver(self, name: .selectAlbum, object: nil)
    }
    
    deinit {
        imageManager.stopCachingImagesForAllAssets()
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    override func setupNavigationBar() {
        setupBaseNavigationBar()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: SwiftGenIcons.close.image.withTintColor(SwiftGenColors.primaryBlack.color, renderingMode: .alwaysOriginal),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(didTapBackButton))
        
        navigationItem.titleView = titleButton
        
        let rightButtonStackView: UIStackView = {
            let stackView: UIStackView = UIStackView(arrangedSubviews: [selectedCountLabel, successButton])
            stackView.distribution = .equalSpacing
            stackView.spacing = 4
            return stackView
        }()
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButtonStackView)
    }
    
    override func setupView() {
        setupCollectionView()
        setupAlbumsViewController()
        setupImageViewForSave()
    }
    
    override func setupBinding() {
        bindNavigationButton()
        bindNotificationSelectAlbum()
    }
}

// MARK: - setup
extension PhotosViewController {
    private func setupCollectionView() {
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        collectionView.register(CenterIconCollectionCell.self,
                                forCellWithReuseIdentifier: CenterIconCollectionCell.reuseIdentifier)
        collectionView.register(ContentsCollectionViewCell.self,
                                forCellWithReuseIdentifier: ContentsCollectionViewCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func setupAlbumsViewController() {
        addChild(albumsViewController)
        view.addSubview(albumsViewController.view)
        
        NSLayoutConstraint.activate([
            albumsViewController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            albumsViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            albumsViewController.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            albumsViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        albumsViewController.didMove(toParent: self)
        albumsViewController.view.isHidden = true
    }
    
    private func setupImageViewForSave() {
        imageViewForSave.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
    }
}
// MARK: - Bind
extension PhotosViewController {
    private func bindNavigationButton() {
        successButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                if let image: UIImage = self.cropViewController?.cropImage(),
                   let index: IndexPath = self.cropViewController?.selectedIndexImage.index,
                   let firstIndex: Int = self.selectedIndexPath.firstIndex(where: { $0.index == index }) {
                    self.selectedIndexPath[firstIndex].image = image
                }
                
                NotificationCenter.default.post(name: .passSelectImages,
                                                object: nil,
                                                userInfo: [Notification.Name.passSelectImages: self.convertIndexPathToImages()])
                self.coordinator?.back()
            }.disposed(by: disposeBag)
        
        titleButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                self.isShowAlbumsViewController ? self.dismissAlbumsViewController() : self.showAlbumsViewController()
                self.isShowAlbumsViewController.toggle()
            }.disposed(by: disposeBag)
    }
    
    /// AlbumViewController에서 선택한 앨범을 가져온다. 기존에 선택한 항목들을 초기화하고, AlbumViewController를 숨긴다.
    private func bindNotificationSelectAlbum() {
        NotificationCenter.default.rx.notification(.selectAlbum, object: nil)
            .map { notification -> PHAssetCollection? in
                notification.userInfo?[Notification.Name.selectAlbum] as? PHAssetCollection
            }
            .bind { [weak self] assetCollection in
                guard let self = self else { return }
                self.resetSelectedIndexPath()
                self.assets = self.fetchAssets(assetCollection: assetCollection)
                self.titleButton.sendActions(for: .touchUpInside)
            }.disposed(by: disposeBag)
    }
    
    @objc
    private func didTapBackButton() {
        coordinator?.back()
    }
}

extension PhotosViewController {
    /// `selectedIndexPath`을 초기화한다.
    func resetSelectedIndexPath() {
        selectedIndexPath = []
        collectionView.reloadData()
    }
    
    /// `selectedIndexPath`에 데이터가 변경될 때 기존에 있는 항목의 checkButton 문자열을 업데이트한다.
    func updateSelectedOrder() {
        selectedIndexPath.enumerated().forEach { index, indexPath in
            guard let cell: ContentsCollectionViewCell = collectionView.cellForItem(at: indexPath.index) as? ContentsCollectionViewCell else {
                return
            }
            cell.updateCheckButton(string: "\(index + 1)", backgroundColor: SwiftGenColors.systemGreen.color)
            cell.layoutIfNeeded()
        }
    }
    
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
        
        return PHAsset.fetchAssets(in: assetCollection, options: allPhotosOptions)
    }
    
    /// 네비게이션 우측 상단에 있는 확인 버튼에 선택한 개수를 변경한다. 선택한 항목이 없으면 "확인"으로 변경한다.
    private func updateSelectedCountLabel() {
        if selectedIndexPath.isEmpty {
            selectedCountLabel.text = ""
        } else {
            selectedCountLabel.text = "\(selectedIndexPath.count)"
        }
        successButton.isEnabled = !selectedIndexPath.isEmpty
    }
    
    /// selectedMaxCount < selectedIndexPath.count 인 경우 사용자에게 Alert을 띄운다.
    func showMaxSelectedAlert() {
        let alert: AlertViewController = AlertViewController()
        alert.modalPresentationStyle = .overFullScreen
        
        alert.changeContentsText("이미지는 최대 10개까지 첨부할 수 있어요")
        alert.leftButton.setTitle("확인", for: .normal)
        
        alert.hideTitleLabel()
        alert.hideRightButton()
        alert.hideTextField()
        
        alert.leftButton.rx.tap.bind {
            alert.dismiss(animated: false, completion: nil)
        }.disposed(by: disposeBag)
        
        present(alert, animated: false, completion: nil)
    }
    
    /// `selectedIndexPath`를  오리지널, 썸네일 각각 `UIImage`으로 변환하여 반환한다.
    private func convertIndexPathToImages() -> [(original: UIImage, thumbnail: UIImage)] {
        var selectedOriginalImage: [UIImage] = []
        var selectedThumnailImage: [UIImage] = []
        let thumbnailSize: CGSize = CGSize(width: 100, height: 100)
        
        let options: PHImageRequestOptions = PHImageRequestOptions()
        options.isSynchronous = true
        options.deliveryMode = .highQualityFormat
        
        for indexPath in selectedIndexPath {
            if let image: UIImage = indexPath.image {
                selectedOriginalImage.append(image)
            } else {
                let asset: PHAsset = assets.object(at: indexPath.index.item - 1)
                asset.toImage(targetSize: CGSize(width: asset.pixelWidth,
                                                 height: asset.pixelHeight),
                              options: options) { image in
                    guard let image = image else { return }
                    
                    // 360보다 큰 이미지 사이즈는 targetSize만으로 적용이 안되어, 뷰를 이용하여 contentMode를 적용시켜 이미지를 변환한다.
                    self.imageViewForSave.image = image
                    let renderer: UIGraphicsImageRenderer = UIGraphicsImageRenderer(size: self.imageViewForSave.bounds.size)
                    let scaledImage = renderer.image { ctx in
                        self.imageViewForSave.drawHierarchy(in: self.imageViewForSave.bounds, afterScreenUpdates: true)
                    }
                    selectedOriginalImage.append(scaledImage)
                }
            }
            
            guard let original = selectedOriginalImage.last else {
                continue
            }
            let thumbnail: UIImage = original.resize(to: thumbnailSize)
            selectedThumnailImage.append(thumbnail)
        }
        return zip(selectedOriginalImage, selectedThumnailImage).map { ($0, $1) }
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

// MARK: - ImagePickerController
extension PhotosViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)

        guard let image = info[.editedImage] as? UIImage else {
            print("\(#function): No edited image were found.")
            return
        }

        let indexPath: IndexPath = IndexPath(row: -1, section: -1)
        self.selectedIndexPath.append((indexPath, image))

        NotificationCenter.default.post(name: .passSelectImages,
                                        object: nil,
                                        userInfo: [Notification.Name.passSelectImages: self.convertIndexPathToImages()])
        coordinator?.back()
    }
}
