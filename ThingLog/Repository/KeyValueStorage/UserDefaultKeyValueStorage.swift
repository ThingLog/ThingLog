//
//  UserDefaultKeyValueStorage.swift
//  ThingLog
//
//  Created by hyunsu on 2021/12/11.
//

import Foundation

final class UserDefaultKeyValueStorage: KeyValueStoragable {
    private init() { }
    
    static var shared: KeyValueStoragable = UserDefaultKeyValueStorage()
    
    func bool(forKey key: String) -> Bool {
        UserDefaults.standard.bool(forKey: key)
    }
    
    func int(forKey key: String) -> Int64 {
        Int64(UserDefaults.standard.integer(forKey: key))
    }
    
    func string(forKey key: String) -> String? {
        UserDefaults.standard.string(forKey: key)
    }
    
    func array(forKey key: String) -> [Any]? {
        UserDefaults.standard.array(forKey: key)
    }
    
    func set(_ value: Any?, forKey key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    func removeObject(forKey key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
}

