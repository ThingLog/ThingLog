//
//  KeyValueStoragable.swift
//  ThingLog
//
//  Created by hyunsu on 2021/12/11.
//

import Foundation

/// Key와 Value를 쌍으로 데이터를 저장하는 storage를 정의한 protocol이다.
protocol KeyValueStoragable {
    static var shared: KeyValueStoragable { get }

    func bool(forKey key: String) -> Bool
    
    func int(forKey key: String) -> Int64
    
    func string(forKey key: String) -> String?
    
    func array(forKey key: String) -> [Any]?
    
    func set(_ value: Any?, forKey key: String)
    
    func removeObject(forKey key: String)
}
