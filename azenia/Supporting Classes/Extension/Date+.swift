//
//  Date+.swift
//  azenia
//
//  Created by MacBook Pro on 6/11/21.
//

import Foundation

extension Date {
    var dateToString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        return dateFormatter.string(from: self)
    }
}
