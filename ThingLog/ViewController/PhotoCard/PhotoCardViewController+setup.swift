//
//  PhotoCardViewController+setup.swift
//  ThingLog
//
//  Created by hyunsu on 2021/11/17.
//
import UIKit

extension PhotoCardViewController {
    func setupColorCollectionView() {
        view.addSubview(colorCollectionView)
        colorCollectionView.dataSource = self
        colorCollectionView.delegate = self
        NSLayoutConstraint.activate([
            colorCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            colorCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            colorCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -inset.bottomPaddingForColorCollectionView),
            colorCollectionView.heightAnchor.constraint(equalToConstant: inset.heightForCollectionView + 4)
        ])
    }
    
    func setupFrameCollectionView() {
        view.addSubview(frameCollectionView)
        frameCollectionView.dataSource = self
        frameCollectionView.delegate = self
        NSLayoutConstraint.activate([
            frameCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            frameCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            frameCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -inset.bottomPaddingForFrameCollectionView),
            frameCollectionView.heightAnchor.constraint(equalToConstant: inset.heightForFrameCollectionView)
        ])
    }
    
    func setupOptionView() {
        view.addSubviews(optionStackView)
        NSLayoutConstraint.activate([
            optionStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset.leadingPaddingForOptionView),
            optionStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            optionStackView.heightAnchor.constraint(equalToConstant: inset.heightForOptionStackView),
            optionStackView.bottomAnchor.constraint(equalTo: colorCollectionView.topAnchor, constant: -inset.bottomPaddingForOptionView),
            
            emptyOptionView.widthAnchor.constraint(greaterThanOrEqualToConstant: 10)
        ])
    }
    
    func setupPhotoView() {
        photoContainerView.addSubviews(imageView,
                                       photoFrameView,
                                       photoFrameLineView)
        containerView.addSubviews(photoContainerView)
        view.addSubviews(containerView)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: optionStackView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            photoContainerView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            photoContainerView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            photoContainerView.widthAnchor.constraint(equalTo: view.widthAnchor),
            photoContainerView.heightAnchor.constraint(equalTo: photoContainerView.widthAnchor),
            
            imageView.centerXAnchor.constraint(equalTo: photoContainerView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: photoContainerView.centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.77),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
        
        photoFrameView.setAllConstraintTo(photoContainerView)
        photoFrameLineView.setAllConstraintTo(photoContainerView)
        // TODO: - ⚠️PostEntity 이미지
    }
    
    func setupLabel() {
        photoContainerView.addSubviews(emptyViewForTopDateLabel, nameLabel, dateLabel)
        
        NSLayoutConstraint.activate([
            emptyViewForTopDateLabel.heightAnchor.constraint(equalTo: photoContainerView.heightAnchor, multiplier: 0.035),
            emptyViewForTopDateLabel.widthAnchor.constraint(equalToConstant: 10),
            emptyViewForTopDateLabel.centerXAnchor.constraint(equalTo: photoContainerView.centerXAnchor),
            emptyViewForTopDateLabel.topAnchor.constraint(equalTo: photoContainerView.topAnchor),
            dateLabel.topAnchor.constraint(equalTo: emptyViewForTopDateLabel.bottomAnchor),
            dateLabel.centerXAnchor.constraint(equalTo: photoContainerView.centerXAnchor),
            nameLabel.centerXAnchor.constraint(equalTo: photoContainerView.centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 2)
        ])
        // TODO: - ⚠️ PostEntity 물건이름, 날짜
        dateLabel.text = "2021년 08월 27일"
        nameLabel.text = "전기 자전거"
    }
    
    func setupLogoView() {
        photoContainerView.addSubviews(logoView)
        
        NSLayoutConstraint.activate([
            logoView.bottomAnchor.constraint(equalTo: photoContainerView.bottomAnchor,
                                             constant: -inset.bottomPaddingForLogoView),
            logoView.trailingAnchor.constraint(equalTo: photoContainerView.trailingAnchor,
                                               constant: -inset.trailingPaddingForLogoView),
            logoView.heightAnchor.constraint(equalToConstant: inset.heightForLogoView),
            logoView.widthAnchor.constraint(equalTo: logoView.heightAnchor)
        ])
    }
    
    func setupRatingView() {
        photoContainerView.addSubviews(ratingView)
        ratingView.currentRating = 3 // TODO: - ⚠️ PostEntity로.
        NSLayoutConstraint.activate([
            ratingView.bottomAnchor.constraint(equalTo: photoContainerView.bottomAnchor,
                                               constant: -inset.bottomPaddingForRatingView),
            ratingView.centerXAnchor.constraint(equalTo: photoContainerView.centerXAnchor),
            ratingView.heightAnchor.constraint(equalToConstant: inset.heightForRatingView)
        ])
    }
    
    func setupNavigationBar() {
        setupBaseNavigationBar()
        let logoView: LogoView = LogoView("포토카드", font: UIFont.Pretendard.headline4)
        logoView.textAlignment = .center
        navigationItem.titleView = logoView
        
        let backButton: UIButton = UIButton()
        backButton.setImage(SwiftGenIcons.close.image.withRenderingMode(.alwaysTemplate), for: .normal)
        backButton.tintColor = SwiftGenColors.primaryBlack.color
        backButton.rx.tap
            .bind { [weak self] in
                self?.coordinator?.back()
            }
            .disposed(by: disposeBag)
        let backBarButton: UIBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backBarButton
    }
    
    func setupRightNavigationBarItem() {
        let editButton: UIButton = UIButton()
        editButton.setTitle("완료", for: .normal)
        editButton.titleLabel?.font = UIFont.Pretendard.body1
        editButton.setTitleColor(SwiftGenColors.primaryBlack.color, for: .normal)
        editButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                let renderer: UIGraphicsImageRenderer = UIGraphicsImageRenderer(size: self.photoContainerView.bounds.size)
                let image: UIImage = renderer.image { ctx in
                    self.photoContainerView.drawHierarchy(in: self.photoContainerView.bounds, afterScreenUpdates: true)
                }
                // TODO: - ⚠️ 2배 사이즈 키울 필요성을 못 느끼겠다.
                //                guard let newImage = image.resizedImage(Size: CGSize(width: self.photoContainerView.bounds.size.width * 2, height: self.photoContainerView.bounds.size.height * 2)) else { return }
                self.imageSaver.saveToPhotoAlbum(image: image)
            }
            .disposed(by: disposeBag)
        
        let editBarButton: UIBarButtonItem = UIBarButtonItem(customView: editButton)
        let fixedSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        fixedSpace.width = 17
        navigationItem.rightBarButtonItems = [fixedSpace, editBarButton]
    }
}
