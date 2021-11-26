//
//  CheckView.swift
//  ThingLog
//
//  Created by hyunsu on 2021/11/04.
//

import UIKit
/// 내부에 `ImageView`의 `checkmark.circle`을 가지는 액션이 가능한 뷰다. [이미지](https://www.notion.so/CheckView-f3a180f503b64187998ef72a77367f97)
final class CheckView: UIControl {
    let imageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.image = UIImage(systemName: "checkmark.circle")
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
    
    // 터치 영역 더 크게 한다.
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
            return bounds.insetBy(dx: -10, dy: -10).contains(point)
        }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupView() {
        addSubview(imageView)
        addSubview(label)

        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -2),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 2),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: -2),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 2),
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
