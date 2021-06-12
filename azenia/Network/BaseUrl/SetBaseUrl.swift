//
//  SetBaseUrl.swift
//  azenia
//
//  Created by MacBook Pro on 6/11/21.
//

import Foundation

// MARK: - sets base url based on development environment
class SetBaseurl: NSObject {
    /// singleton
    static let shared = SetBaseurl()
    /// 
    var baseURL: String = ""
    //
    fileprivate override init() {
        self.buildEnvironment = .production
        super.init()
    }
    /// Setup build environment for application.
    var buildEnvironment: DevelopmentEnvironment {
        didSet {
            /// no default case since we only have one case
            switch buildEnvironment {
            case .production:
                baseURL = "http://jsonplaceholder.typicode.com"
            }
        }
    }
}

// MARK: - development environments
enum DevelopmentEnvironment: String {
    /// prod
    case production = "Production"
}
