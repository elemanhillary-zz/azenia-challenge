//
//  PostsRequest.swift
//  azenia
//
//  Created by MacBook Pro on 6/11/21.
//

import Foundation
import Alamofire

class PostsRequest: BaseRequest {
    /// API call that fetchs all comments
    /// - Parameters:
    ///   - success: success completion handler
    ///   - failure: failure completion handler
    static func getPosts(success: @escaping  HttpSuccess, failure: @escaping  HttpFailure) {
        /// pass any paramters here
        /// - Example:
        ///         request.param = param
        let request = PostsRequest.init()
        APIManager.shared.getRequest(urlPath: EndPoints.posts, headers: nil, request: request, encoding: JSONEncoding.default, success: { data in
            if let response = [PostsResponse].deserialize(from: data as? NSArray) {
                success(response)
            }
        }, failure: { error in
            failure(error)
        })
    }
}
