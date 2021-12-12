//
//  CloudKeyValueStorage.swift
//  ThingLog
//
//  Created by hyunsu on 2021/12/11.
//

import Foundation

final class CloudKeyValueStorage: KeyValueStoragable {
    private init() { }
    
    static var shared: KeyValueStoragable = CloudKeyValueStorage()

    func bool(forKey key: String) -> Bool {
        NSUbiquitousKeyValueStore.default.bool(forKey: key)
    }
    
    func int(forKey key: String) -> Int64 {
        NSUbiquitousKeyValueStore.default.longLong(forKey: key)
    }
    
    func string(forKey key: String) -> String? {
        NSUbiquitousKeyValueStore.default.string(forKey: key)
    }
    
    func array(forKey key: String) -> [Any]? {
        NSUbiquitousKeyValueStore.default.array(forKey: key)
    }
    
    func set(_ value: Any?, forKey key: String) {
        NSUbiquitousKeyValueStore.default.set(value, forKey: key)
        sync()
    }
    
    func removeObject(forKey key: String) {
        NSUbiquitousKeyValueStore.default.removeObject(forKey: key)
        sync()
    }
    
    private func sync() {
        NSUbiquitousKeyValueStore.default.synchronize()
    }
}
