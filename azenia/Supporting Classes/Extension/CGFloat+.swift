//
//  CGFloat+.swift
//  azenia
//
//  Created by MacBook Pro on 6/11/21.
//

import Foundation
import UIKit

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}
