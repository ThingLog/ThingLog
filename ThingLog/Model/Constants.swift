//
//  Constants.swift
//  ThingLog
//
//  Created by 이지원 on 2022/01/24.
//

import Foundation

enum Constants {
    enum System {
        static let appVersion: String? = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        static let bundleIdentifier: String? = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String
        static let buildNumber: String? = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
        
        static func latestVersion() -> String? {
            let appleID: String = "1586982199"
            guard let url: URL = URL(string: "http://itunes.apple.com/lookup?id=\(appleID)"),
                  let data: Data = try? Data(contentsOf: url),
                  let json: [String: Any] = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
                  let results: [[String: Any]] = json["results"] as? [[String: Any]],
                  let appStoreVersion: String = results[0]["version"] as? String else {
                      return nil
                  }
            return appStoreVersion
        }
    }
}
