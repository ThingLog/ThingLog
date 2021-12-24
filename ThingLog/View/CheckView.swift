//
//  CheckView.swift
//  ThingLog
//
//  Created by hyunsu on 2021/11/04.
//

import UIKit
/// 내부에 `ImageView`의 `checkmark.circle`을 가지는 액션이 가능한 뷰다. [이미지](https://www.notion.so/CheckView-f3a180f503b64187998ef72a77367f97)
final class CheckView: UIControl {
    let containerView: UIImageView = {
        let imageView: UIImageView = UIImageView(image: SwiftGenIcons.checkBoxS.image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    let imageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.image = UIImage(systemName: "checkmark")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true
        return imageView
    }()
    
    let label: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.Pretendard.overline
        label.textColor = .white
        return label
    }()

    var isSelect: Bool = false {
        didSet {
            containerView.image = isSelect ? SwiftGenIcons.checkBoxS.image : SwiftGenIcons.checkBoxSSelected.image
        }
    }
    
    // 터치 영역 더 크게 한다.
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        bounds.insetBy(dx: -10, dy: -10).contains(point)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func setupView() {
        let checkSpacing: CGFloat = 6.5

        containerView.addSubviews(imageView, label)
        addSubview(containerView)

        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),

            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: checkSpacing),
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: checkSpacing),
            imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -(checkSpacing + 1)),
            imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -checkSpacing),

            label.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: imageView.centerYAnchor, constant: -1)
        ])
    }
}
