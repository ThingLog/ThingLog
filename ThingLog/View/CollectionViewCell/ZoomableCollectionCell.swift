//
//  ZoomableCollectionCell.swift
//  ThingLog
//
//  Created by 이지원 on 2022/01/17.
//  Source: https://stevenpcurtis.medium.com/create-instagrams-pinch-to-zoom-using-swift-16084415b186

import UIKit

protocol ZoomableCollectionCellDelegate: AnyObject {
    func zooming(started: Bool)
}

final class ZoomableCollectionCell: UICollectionViewCell, UIGestureRecognizerDelegate {
    // MARK: - View Properties
    let imageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    // MARK: - Properties
    weak var delegate: ZoomableCollectionCellDelegate?
    /// 확대했을 때 오버레이 되는 투명한 뷰
    var overlayView: UIView?
    /// 배경의 최대 알파 값
    let maxOverlayAlpha: CGFloat = 0.8
    /// 배경의 최소 알파 값
    let minOverlayAlpha: CGFloat = 0.4
    /// 핀치의 초기 중심
    var initialCenter: CGPoint?
    /// 윈도우에 추가할 뷰
    lazy var windowImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    /// 소스 이미지 뷰의 원점(윈도우의 좌표 공간에서)
    var startingRect: CGRect = .zero
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// 사용자가 컬렉션 뷰 셀을 집었을 때 호출됨
    @objc
    private func pinch(_ sender: UIPinchGestureRecognizer) {
        if sender.state == .began {
            let currentScale: CGFloat = self.imageView.frame.size.width / self.imageView.bounds.size.width
            let newScale: CGFloat = currentScale * sender.scale
            
            if newScale > 1 {
                startZooming(with: sender)
            }
        } else if sender.state == .changed {
            changeZooming(with: sender)
        } else if sender.state == .ended || sender.state == .failed || sender.state == .cancelled {
            endZooming()
        }
    }
    
    private func startZooming(with sender: UIPinchGestureRecognizer) {
        guard let currentWindow: UIWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
        
        self.delegate?.zooming(started: true)

        overlayView = UIView(frame: CGRect(x: 0,
                                           y: 0,
                                           width: (currentWindow.frame.size.width),
                                           height: (currentWindow.frame.size.height)))
        overlayView?.backgroundColor = .black
        overlayView?.alpha = CGFloat(minOverlayAlpha)
        guard let overlayView = overlayView else { return }
        currentWindow.addSubview(overlayView)
        
        initialCenter = sender.location(in: currentWindow)

        windowImageView.image = imageView.image
        
        let point: CGPoint = self.imageView.convert(imageView.frame.origin, to: nil)
        
        startingRect = CGRect(x: point.x, y: point.y, width: imageView.frame.size.width, height: imageView.frame.size.height)
        
        windowImageView.frame = startingRect
        currentWindow.addSubview(windowImageView)
        imageView.isHidden = true
    }
    
    private func changeZooming(with sender: UIPinchGestureRecognizer) {
        guard let currentWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }),
              let initialCenter = initialCenter else {
                  return
              }
        let windowImageWidth: CGFloat = windowImageView.frame.size.width
        let currentScale: CGFloat = windowImageWidth / startingRect.size.width
        let newScale: CGFloat = currentScale * sender.scale
        
        overlayView?.alpha = minOverlayAlpha + (newScale - 1) < maxOverlayAlpha ? minOverlayAlpha + (newScale - 1) : maxOverlayAlpha
        
        let pinchCenter: CGPoint = CGPoint(x: sender.location(in: currentWindow).x - (currentWindow.bounds.midX),
                                           y: sender.location(in: currentWindow).y - (currentWindow.bounds.midY))
        let centerXDif: CGFloat = initialCenter.x - sender.location(in: currentWindow).x
        let centerYDif: CGFloat = initialCenter.y - sender.location(in: currentWindow).y
        let zoomScale: CGFloat = (newScale * windowImageWidth >= imageView.frame.width) ? newScale : currentScale
        let transform: CGAffineTransform = currentWindow.transform
                                                        .translatedBy(x: pinchCenter.x, y: pinchCenter.y)
                                                        .scaledBy(x: zoomScale, y: zoomScale)
                                                        .translatedBy(x: -centerXDif, y: -centerYDif)
        windowImageView.transform = transform
        sender.scale = 1
    }
    
    private func endZooming() {
        UIView.animate(withDuration: 0.3, animations: {
            self.windowImageView.transform = .identity
        }, completion: { _ in
            self.windowImageView.removeFromSuperview()
            self.overlayView?.removeFromSuperview()
            self.imageView.isHidden = false
            self.delegate?.zooming(started: false)
        })
    }
}

extension ZoomableCollectionCell {
    private func setupView() {
        let pinch: UIPinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(pinch(_:)))
        pinch.delegate = self
        
        imageView.addGestureRecognizer(pinch)
        addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
