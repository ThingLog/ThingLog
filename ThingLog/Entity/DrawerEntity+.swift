//
//  DrawerEntity+.swift
//  ThingLog
//
//  Created by hyunsu on 2021/10/30.
//

import Foundation

extension DrawerEntity: Drawerable {
    var imageData: Data? {
        if let name: String = self.imageName {
            return ImageSwiftGen(name: name).image.pngData()
        } else {
            return nil
        }
    }
}
