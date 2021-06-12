//
//  ApiManager.swift
//  azenia
//
//  Created by MacBook Pro on 6/11/21.
//

import Foundation
import Alamofire

// MARK: - Completion Handlers Aliases
typealias HttpSuccess = (_ data:Any) -> Void
typealias HttpFailure = (_ error:Error) -> Void

class APIManager {
    // MARK: - Variables
    static let shared = APIManager()
    
    let NetWorkDomain: String = "com.swap.swap"
    
    // MARK: - Network Reachability
    static let reachabilityManager = { () -> NetworkReachabilityManager in
        let manager = NetworkReachabilityManager.init()
        return manager!
    }()
    
    // MARK: - Session Manager
    static let sessionManager = { () -> Session in
        var manager = Session.default
        return manager
    }()
    
    // MARK: - Funcationalities
    /// Returns succes if data dictionary count is above zero otherwise returns error
    /// - Parameters:
    ///   - data: Dictonary of key string and value of any data type
    ///   - success: completion handler on returns when success
    ///   - failure: completion handler on returns when failure
    func processData(data: Any, success: @escaping HttpSuccess, failure: @escaping HttpFailure) {
        if ((data as AnyObject).count > 0) {
            success(data)
        } else {
            let message: String = Messages.anErrorOccured
            let error = NSError.init(domain: NetWorkDomain, code: NetworkError.HttpRequestFailed.rawValue, userInfo: [NSLocalizedDescriptionKey: message])
            failure(error)
        }
    }
    
    
    /// Handles all `GET` API requests
    /// - Parameters:
    ///   - urlPath: API endpoint
    ///   - headers: HTTP Headers
    ///   - request: HTTP Body Request
    ///   - encoding: HTTP Encoding
    ///   - success: Success Completion Handler
    ///   - failure: Failure Completion Handler
    func getRequest(urlPath: String, headers: HTTPHeaders?, request: BaseRequest, encoding: ParameterEncoding, success: @escaping HttpSuccess, failure: @escaping HttpFailure) {
        let baseUrl = SetBaseurl.shared.baseURL + urlPath
        APIManager.sessionManager.request(baseUrl, method: HTTPMethod.get, parameters: nil, encoding: encoding)
            .validate(statusCode: 200..<500)
            .validate()
            .validate(contentType: ["application/json"])
            .responseJSON(completionHandler: { response in

                switch response.result {
                case .success:
                    if let data:[String:Any] = response.value as? [String:Any] {
                        self.processData(data: data, success: success, failure: failure)
                    } else {
                        let data:[Any] = response.value as! [Any]
                        self.processData(data: data, success: success, failure: failure)
                    }
                    break
                case .failure(let error):
                    let err:NSError = error as NSError
                    if(NetworkReachabilityManager.init()?.status == .notReachable) {
                        failure(err)
                        return;
                    } else {
                        failure(err)
                    }
                    break
                }
            }
        )
    }
}
