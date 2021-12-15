//
//  PhotoCardViewController.swift
//  ThingLog
//
//  Created by hyunsu on 2021/11/17.
//
import RxSwift
import UIKit

/// 포토카드를 내보내기 위한 뷰 컨트롤러다.
final class PhotoCardViewController: UIViewController {
    var coordinator: PhotoCardCoordinatorProtocol?
    
    // MARK: - Views
    let emptyViewForTopDateLabel: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let dateLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.Pretendard.caption
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.Pretendard.title1
        label.textColor = .white
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let logoView: UIImageView = {
        let view: UIImageView = UIImageView(image: SwiftGenIcons.cardLogo.image)
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let ratingView: RatingView = {
        let ratingView: RatingView = RatingView()
        ratingView.tintButton(.white)
        ratingView.isUserInteractionEnabled = false 
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        return ratingView
    }()
    
    // MARK: - PhotoFrame
    /// 하단의 옵션,컬렉션뷰를 제외한 상단 뷰  ( PhotoContainerVeiw의 center를 맞추기 위해 필요한 뷰 )
    let containerView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// 포토카드가 출력될 화면
    var photoContainerView: UIView = {
        let view: UIView = UIView()
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var photoFrameView: UIImageView = {
        let view: UIImageView = UIImageView()
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var photoFrameLineView: UIImageView = {
        let view: UIImageView = UIImageView()
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var imageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - OptionView
    let frameOptionView: LabelWithUnderLineVerticalView = {
        let view: LabelWithUnderLineVerticalView = LabelWithUnderLineVerticalView()
        view.changeLabelText("모양")
        view.isUserInteractionEnabled = true
        view.tint(true)
        return view
    }()
    
    let colorOptionView: LabelWithUnderLineVerticalView = {
        let view: LabelWithUnderLineVerticalView = LabelWithUnderLineVerticalView()
        view.isUserInteractionEnabled = true
        view.changeLabelText("색상")
        view.tint(false)
        return view
    }()
    
    let emptyOptionView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var optionStackView: UIStackView = {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [frameOptionView,
                                                                    colorOptionView,
                                                                    emptyOptionView])
        stackView.axis = .horizontal
        stackView.spacing = 25
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - CollectionView
    lazy var colorCollectionView: UICollectionView = {
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: inset.heightForCollectionView, height: inset.heightForCollectionView)
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(ImageViewWithSelectViewCollectionCell.self, forCellWithReuseIdentifier: ImageViewWithSelectViewCollectionCell.reuseIdentifier)
        collectionView.backgroundColor = SwiftGenColors.primaryBackground.color
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isHidden = true
        return collectionView
    }()
    
    lazy var frameCollectionView: UICollectionView = {
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 83, height: 83)
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(ImageViewWithSelectViewCollectionCell.self, forCellWithReuseIdentifier: ImageViewWithSelectViewCollectionCell.reuseIdentifier)
        collectionView.backgroundColor = SwiftGenColors.primaryBackground.color
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isHidden = false
        return collectionView
    }()
    
    // MARK: - Propertis
    var photoCardViewModel: PhotoCardViewModel
    lazy var imageGestureModel: GestureModel = GestureModel(targetView: imageView,
                                                            parentView: photoContainerView)
    lazy var imageSaver: ImageSaver = ImageSaver { [weak self] error in
        guard let self = self else { return }
        let alert: AlertViewController = AlertViewController()
        alert.modalPresentationStyle = .overFullScreen
        alert.hideTitleLabel()
        alert.hideRightButton()
        alert.hideTextField()
        alert.changeContentsText(error == nil ? "사진이 앨범에 저장되었습니다." : "앨범에 접근을 허용해주세요.")
        alert.leftButton.setTitle("확인", for: .normal)
        
        alert.leftButton.rx.tap.bind {
            alert.dismiss(animated: false) {
                if error != nil {
                    self.coordinator?.moveAppSetting()
                } else {
                    DrawerCoreDataRepository(coreDataStack: CoreDataStack.shared).updateRightAward()
                }
            }
        }.disposed(by: self.disposeBag)
        self.present(alert, animated: false, completion: nil)
    }
    
    let inset: PhotoCardInset = PhotoCardInset()

    var disposeBag: DisposeBag = DisposeBag()
    
    // MARK: - Init
    init(postEntity: PostEntity,
         selectImage: UIImage) {
        photoCardViewModel = PhotoCardViewModel(postEntity: postEntity,
                                                selectImage: selectImage)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = SwiftGenColors.primaryBackground.color
        
        setupNavigationBar()
        setupRightNavigationBarItem()
        setupColorCollectionView()
        setupFrameCollectionView()
        setupOptionView()
        setupPhotoView()
        setupLabel()
        setupLogoView()
        setupRatingView()
        setupPhotoData()
        
        subscribeOptionView()
        subscribePhotoCardViewModel()

        // 원래는 사진 이동이 가능했지만, 기획자의 제안에 따라 취소함.
//        imageGestureModel.startObserving()
    }
}
