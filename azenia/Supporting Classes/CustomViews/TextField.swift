//
//  TextField.swift
//  azenia
//
//  Created by MacBook Pro on 6/11/21.
//

import Foundation
import UIKit

@IBDesignable
class TextField: UITextField {
    @IBInspectable var insetX: CGFloat = 6 {
       didSet {
         layoutIfNeeded()
       }
    }
    @IBInspectable var insetY: CGFloat = 6 {
       didSet {
         layoutIfNeeded()
       }
    }

    // placeholder position
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: insetX , dy: insetY)
    }

    // text position
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: insetX , dy: insetY)
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        let rightBounds = CGRect(x: bounds.size.width-29, y: bounds.size.height * 0.25, width: 20, height: 20)
        return rightBounds
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        let rightBounds = CGRect(x: 10, y: bounds.size.height * 0.25, width: 20, height: 20)
        return rightBounds
    }
}
