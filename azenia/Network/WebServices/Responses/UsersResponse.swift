//
//  UsersResponse.swift
//  azenia
//
//  Created by MacBook Pro on 6/11/21.
//

import Foundation

// MARK: - Users JSON Respresentation
class UsersResponse: BaseModel {
    var id: Int?
    var name: String?
    var username: String?
    var email: String?
    var address: Address?
    var phone: String?
    var website: String?
    var company: Company?
}

// MARK: - Address JSON Respresentation
class Address: BaseModel {
    var street: String?
    var suite: String?
    var city: String?
    var zipcode: String?
    var geo: Geo?
}

// MARK: - Geo JSON Respresentation
class Geo: BaseModel {
    var lat: String?
    var lng: String?
}

// MARK: - Company JSON Respresentation
class Company: BaseModel {
    var name: String?
    var catchPhrase: String?
    var bs: String?
}
