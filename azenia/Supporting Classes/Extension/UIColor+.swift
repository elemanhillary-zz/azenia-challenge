//
//  UIColor+.swift
//  azenia
//
//  Created by MacBook Pro on 6/11/21.
//

import Foundation
import UIKit

extension UIColor {
    static func random() -> UIColor {
        return UIColor(
           red:   .random(),
           green: .random(),
           blue:  .random(),
           alpha: 1.0
        )
    }
}
