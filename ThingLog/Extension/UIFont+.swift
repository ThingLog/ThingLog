//
//  UIFont+.swift
//  ThingLog
//
//  Created by 이지원 on 2021/09/24.
//

import UIKit

protocol FontTextStyle {
    static var headline1: UIFont { get }
    static var headline2: UIFont { get }
    static var headline3: UIFont { get }
    static var headline4: UIFont { get }
    static var title1: UIFont { get }
    static var title2: UIFont { get }
    static var title3: UIFont { get }
    static var body1: UIFont { get }
    static var body2: UIFont { get }
    static var body3: UIFont { get }
    static var button: UIFont { get }
    static var caption: UIFont { get }
    static var overline: UIFont { get }
}

extension UIFont {
    enum Pretendard: FontTextStyle {
        static var headline1: UIFont { SwiftGenFonts.Pretendard.bold.font(size: 34.0) }
        static var headline2: UIFont { SwiftGenFonts.Pretendard.bold.font(size: 24.0) }
        static var headline3: UIFont { SwiftGenFonts.Pretendard.bold.font(size: 20.0) }
        static var headline4: UIFont { SwiftGenFonts.Pretendard.bold.font(size: 18.0) }
        static var title1: UIFont { SwiftGenFonts.Pretendard.bold.font(size: 16.0) }
        static var title2: UIFont { SwiftGenFonts.Pretendard.bold.font(size: 14.0) }
        static var title3: UIFont { SwiftGenFonts.Pretendard.semiBold.font(size: 12.0) }
        static var body1: UIFont { SwiftGenFonts.Pretendard.regular.font(size: 16.0) }
        static var body2: UIFont { SwiftGenFonts.Pretendard.regular.font(size: 14.0) }
        static var body3: UIFont { SwiftGenFonts.Pretendard.regular.font(size: 12.0) }
        static var button: UIFont { SwiftGenFonts.Pretendard.bold.font(size: 16.0) }
        static var caption: UIFont { SwiftGenFonts.Pretendard.regular.font(size: 12.0) }
        static var overline: UIFont { SwiftGenFonts.Pretendard.regular.font(size: 11.0) }
    }
}
