//
//  CropViewController.swift
//  ThingLog
//
//  Created by hyunsu on 2021/11/23.
//
import RxSwift
import UIKit

/// 이미지를 크롭하는 뷰컨트롤러다. 
class CropViewController: UIViewController {
    var coordinator: Coordinator?
    
    let numberView: CheckView = {
        let button: CheckView = CheckView()
        button.layer.borderWidth = 1
        button.imageView.tintColor = .white
        button.backgroundColor = SwiftGenColors.systemGreen.color
        button.layer.borderColor = UIColor.white.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.label.font = UIFont.Pretendard.body1
        return button
    }()
    
    let zoomButton: UIButton = {
        let button: UIButton = UIButton()
        button.setImage(SwiftGenIcons.zoom.image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let topView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let imageContainerView: UIView = {
        let view: UIView = UIView()
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 0.5
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var imageView: UIImageView = {
        let imageView: UIImageView = UIImageView(image: selectedIndexImage.image)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let scrollView: UIScrollView = {
        let scrollView: UIScrollView = UIScrollView()
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 2.0
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    let bottomView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Properties
    var selectedIndexImage: (index: IndexPath, image: UIImage?)
    var inset: CropInset = CropInset()
    var disposeBag: DisposeBag = DisposeBag()
    
    /// ScreenEdgePanGesture는 여러번 호출될 수 있어서, 한번만 실행되도록 flag변수를 이용함.
    var gestureFlag: Bool = true
    var backCompletion: (() -> Void)?
    
    // MARK: - Init
    init(selectedIndexImage: (index: IndexPath, image: UIImage?)) {
        self.selectedIndexImage = selectedIndexImage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupImageConatinerView()
        setupTopView()
        setupBottomView()
        setupNumberView()
        setupZoomButton()
        setupScreenPanGesture()
    }
    
    // MARK: - Setup
    func setupImageConatinerView() {
        view.addSubview(imageContainerView)
        imageContainerView.addSubviews(scrollView)
        scrollView.addSubviews(imageView)
        scrollView.delegate = self
        
        scrollView.frame = view.frame 
        NSLayoutConstraint.activate([
            imageContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageContainerView.widthAnchor.constraint(equalTo: view.widthAnchor),
            imageContainerView.heightAnchor.constraint(equalTo: view.widthAnchor),
            
            scrollView.topAnchor.constraint(equalTo: imageContainerView.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: imageContainerView.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: imageContainerView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: imageContainerView.trailingAnchor),
            
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: imageContainerView.heightAnchor),
            imageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor)
        ])
    }

    func setupTopView() {
        view.addSubview(topView)
        
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: view.topAnchor),
            topView.bottomAnchor.constraint(equalTo: imageContainerView.topAnchor),
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func setupBottomView() {
        view.addSubview(bottomView)
        
        NSLayoutConstraint.activate([
            bottomView.topAnchor.constraint(equalTo: imageContainerView.bottomAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func setupNumberView() {
        view.addSubview(numberView)
        numberView.layer.cornerRadius = inset.widthForNumberView / 2
        NSLayoutConstraint.activate([
            numberView.topAnchor.constraint(equalTo: view.topAnchor,
                                            constant: inset.topPaddingForNumberView),
            numberView.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                 constant: -inset.topPaddingForNumberView),
            numberView.widthAnchor.constraint(equalToConstant: inset.widthForNumberView),
            numberView.heightAnchor.constraint(equalToConstant: inset.widthForNumberView)
        ])
    }
    
    func setupZoomButton() {
        let width: CGFloat? = imageView.image?.size.width
        let height: CGFloat? = imageView.image?.size.height
        if width == height {
            // 뷰를 아예 추가하지 않는다.
            return
        }
        view.addSubview(zoomButton)
        
        NSLayoutConstraint.activate([
            zoomButton.bottomAnchor.constraint(equalTo: bottomView.topAnchor,
                                               constant: -inset.bottomPaddingForZoomButton),
            zoomButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                constant: inset.bottomPaddingForZoomButton)
        ])
        
        zoomButton.rx.tap.bind { [weak self] in
            let contentMode: UIView.ContentMode? = self?.imageView.contentMode
            if contentMode == .scaleAspectFit {
                self?.imageView.contentMode = .scaleAspectFill
            } else {
                self?.imageView.contentMode = .scaleAspectFit
            }
        }.disposed(by: disposeBag)
    }
    
    /// 왼쪽 가장 끝지점에서 제스쳐를 인식하여, 뒤로가도록 한다.
    func setupScreenPanGesture() {
        let gesture: UIScreenEdgePanGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(back))
        gesture.edges = .left
        self.view.addGestureRecognizer(gesture)
    }
    
    @objc
    func back() {
        DispatchQueue.main.async {
            // ScreenEdgePanGesture는 여러번 호출될 수 있어서, 한번만 실행되도록 flag변수를 이용함.
            if self.gestureFlag {
                self.gestureFlag = false
                self.backCompletion?()
                DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                    self.gestureFlag = true
                }
            }
        }
    }
}

extension CropViewController: UIScrollViewDelegate {
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}

extension CropViewController {
    func cropImage() -> UIImage {
        imageContainerView.layer.borderColor = UIColor.black.cgColor
        let renderer: UIGraphicsImageRenderer = UIGraphicsImageRenderer(size: self.imageContainerView.bounds.size)
        return renderer.image { ctx in
            self.imageContainerView.drawHierarchy(in: self.imageContainerView.bounds, afterScreenUpdates: true)
        }
    }
}
