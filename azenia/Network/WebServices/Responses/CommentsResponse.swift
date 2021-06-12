//
//  CommentsResponse.swift
//  azenia
//
//  Created by MacBook Pro on 6/11/21.
//

import Foundation


// MARK: - Comments JSON Respresentation
class CommentsResponse: BaseModel {
    var postId: Int?
    var id: Int?
    var name: String?
    var email: String?
    var body: String?
}
