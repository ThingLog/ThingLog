//
//  PostTableCell.swift
//  ThingLog
//
//  Created by 이지원 on 2021/11/02.
//

import UIKit

import RxCocoa
import RxSwift

/// 게시물을 표시하는데 사용하는 뷰
/// [이미지](https://www.notion.so/PostTableCell-667e8e6eb38c4dd4b6bdf45ac6b4614d)
final class PostTableCell: UITableViewCell {
    // MARK: - View Properties
    /// 날짜, 기타 메뉴(수정, 삭제)를 포함한 뷰
    let headerContainerView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()

    let dateLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        let date: Date = Date()
        label.text = "\(date.toString(.year))년 \(date.toString(.month))월 \(date.toString(.day))일"
        label.font = UIFont.Pretendard.body2
        label.textColor = SwiftGenColors.black.color
        return label
    }()

    let moreMenuButton: UIButton = {
        let button: UIButton = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(SwiftGenIcons.moreButton.image, for: .normal)
        button.sizeToFit()
        return button
    }()

    /// 게시물의 이미지를 보여주는 컬렉션 뷰
    let slideImageCollectionView: UICollectionView = {
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
        flowLayout.sectionInset = .zero
        flowLayout.minimumLineSpacing = .zero
        flowLayout.minimumInteritemSpacing = .zero
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .clear
        return collectionView
    }()

    /// 좋아요, 댓글, 이미지 위치, 포토카드를 포함한 뷰
    lazy var interactionContainerView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = .clear
        view.addSubviews(likeButton, commentButton, imageCountLabel, photocardButton)
        return view
    }()

    let likeButton: UIButton = {
        let button: UIButton = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(SwiftGenIcons.likeStorke.image, for: .normal)
        button.setImage(SwiftGenIcons.likeFill.image, for: .selected)
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.sizeToFit()
        return button
    }()

    let commentButton: UIButton = {
        let button: UIButton = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(SwiftGenIcons.comments.image, for: .normal)
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.sizeToFit()
        return button
    }()

    let imageCountLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.Pretendard.body2
        label.textColor = SwiftGenColors.black.color
        label.text = "1/10"
        return label
    }()

    let photocardButton: UIButton = {
        let button: UIButton = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(SwiftGenIcons.photoCard.image, for: .normal)
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.sizeToFit()
        return button
    }()

    /// 게시물의 카테고리를 표시하는 컬렉션 뷰
    let categoryCollectionView: UICollectionView = {
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()

    /// 물건 이름, 별점을 포함한 뷰
    lazy var firstInfoContainerView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = .clear
        view.addSubviews(nameLabel, ratingView)
        return view
    }()

    /// 물건 이름, 가로로 스크롤할 수 있다.
    let nameLabel: HorizontalScrollLabel = {
        let label: HorizontalScrollLabel = HorizontalScrollLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "화분"
        return label
    }()

    let ratingView: RatingView = {
        let ratingView: RatingView = RatingView(buttonSpacing: 4.0)
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        ratingView.isUserInteractionEnabled = false
        ratingView.currentRating = 3
        return ratingView
    }()

    /// 장소, 가격을 포함한 뷰
    lazy var secondInfoContainerView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = .clear
        view.addSubviews(placeLabel, priceLabel)
        return view
    }()

    /// 판매처/구매처, 가로로 스크롤할 수 있다.
    let placeLabel: HorizontalScrollLabel = {
        let label: HorizontalScrollLabel = HorizontalScrollLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "제품 구매한 곳이 열 다섯 글자 이상이라면 이렇게 슬라이드 ㄱㄴ"
        return label
    }()

    let priceLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.Pretendard.title1
        label.textColor = SwiftGenColors.black.color
        label.text = "999,999,999 원"
        return label
    }()

    /// 본문, 댓글 n개 모두 보기를 포함한 뷰
    lazy var contentsContainerView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = .clear
        view.addSubviews(lineView, contentTextView, commentMoreButton)
        return view
    }()

    let lineView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = SwiftGenColors.gray4.color
        return view
    }()

    let contentTextView: UITextView = {
        let textView: UITextView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.Pretendard.body1
        textView.textColor = SwiftGenColors.black.color
        textView.backgroundColor = .clear
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.text = """
        Complaint that PorchCam can't pick up voices/speech when there's a loud fan running or other background noise (like a storm, etc.)
        Complaint that PorchCam can't pick up voices/speech when there's a loud fan running or other background noise (like a storm, etc.)Complaint that PorchCam can't pick up voices/speech when there's a loud fan running or other background noise (like a storm,
        """
        textView.sizeToFit()
        return textView
    }()

    let commentMoreButton: UIButton = {
        let button: UIButton = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("댓글 n개 모두 보기", for: .normal)
        button.setTitleColor(SwiftGenColors.gray2.color, for: .normal)
        button.titleLabel?.font = UIFont.Pretendard.title2
        return button
    }()

    /// 특별한 상황(사고싶다, 휴지통)에서 쓰이는 샀어요 버튼, 삭제/복구 버튼을 포함한 뷰
    lazy var specificActionContainerView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = .clear
        view.addSubviews(boughtButton, trashActionButton)
        return view
    }()

    let boughtButton: RoundCenterTextButton = {
        let button: RoundCenterTextButton = RoundCenterTextButton(cornerRadius: 0.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("샀어요 !", for: .normal)
        return button
    }()

    let trashActionButton: LeftRightButtonView = {
        let button: LeftRightButtonView = LeftRightButtonView(bottomLineIsHidden: false)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.leftButton.setTitle("삭제", for: .normal)
        button.rightButton.setTitle("복구", for: .normal)
        return button
    }()

    let emptyView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()

    /// 게시물을 표시하기 위한 모든 뷰를 포함한 스택 뷰
    lazy var stackView: UIStackView = {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [headerContainerView, slideImageCollectionView, interactionContainerView, categoryCollectionView, firstInfoContainerView, secondInfoContainerView, contentsContainerView, specificActionContainerView, emptyView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 0
        return stackView
    }()

    // MARK: - Properties
    let categoryViewDataSource: PostCategoryViewDataSouce = PostCategoryViewDataSouce()
    let slideImageViewDataSource: PostSlideImageViewDataSource = PostSlideImageViewDataSource()
    var disposeBag: DisposeBag = DisposeBag()
    /// TODO: 이후 뷰모델을 통해 어떤 화면인지 받을 예정, 테스트를 위한 프로퍼티
    var isTrash: Bool = true {
        didSet { updateSpecificActionView() }
    }
    /// TODO: 이후 뷰모델을 통해 어떤 화면인지 받을 예정, 테스트를 위한 프로퍼티
    var isBought: Bool = true {
        didSet { updateSpecificActionView() }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView() {
        backgroundColor = .clear
        contentView.addSubview(stackView)
        setupHeaderView()
        setupSlideImageCollectionView()
        setupInteractionView()
        setupCategoryCollectionView()
        setupFirstInfoView()
        setupSecondInfoView()
        setupContentsContainerView()
        setupSpecificActionContainerView()
        setupOtherView()

        setupStackView()
    }

    /// 특별한 상황에서 쓰이는 버튼(사고싶다, 휴지통 게시물인 경우)을 숨김/표시 처리한다.
    /// 이후 뷰모델에서 어떤 화면인지 넘겨받으면 리팩토링할 예정
    func updateSpecificActionView() {
        if isBought && isTrash {
            specificActionContainerView.isHidden = true
            return
        }
        
        specificActionContainerView.isHidden = false
        boughtButton.isHidden = !isBought
        trashActionButton.isHidden = !isTrash
    }
}
