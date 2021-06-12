//
//  UsersRequest.swift
//  azenia
//
//  Created by MacBook Pro on 6/11/21.
//

import Foundation
import Alamofire

class UsersRequest: BaseRequest {
    /// API call that fetchs all comments
    /// - Parameters:
    ///   - success: success completion handler
    ///   - failure: failure completion handler
    static func getUsers(success: @escaping  HttpSuccess, failure: @escaping  HttpFailure) {
        /// pass any paramters here
        /// - Example:
        ///         request.param = param
        let request = UsersRequest.init()
        APIManager.shared.getRequest(urlPath: EndPoints.users, headers: nil, request: request, encoding: JSONEncoding.default, success: { data in
            if let response = [UsersResponse].deserialize(from: data as? NSArray) {
                success(response)
            }
        }, failure: { error in
            failure(error)
        })
    }
}
