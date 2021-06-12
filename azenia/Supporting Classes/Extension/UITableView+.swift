//
//  UITableView+.swift
//  azenia
//
//  Created by MacBook Pro on 6/11/21.
//

import Foundation
import UIKit
import SnapKit

extension UITableView {
    func textState (show: Bool = true, message: String = "Oops Something Went Wrong! Pull To Refresh!") {
        let messageLabel = UILabel.init()
        messageLabel.tag = 1001
        if show {
            self.addSubview(messageLabel)
        } else {
            for subView in (self.subviews) {
                if (subView.tag == 1001) {
                    subView.removeFromSuperview()
                }
            }
        }
        DispatchQueue.main.async {
            self.layoutIfNeeded()
        }
        if show {
            messageLabel.text = message
            messageLabel.font = UIFont.init(name: "Avenir Heavy", size: 14)
            messageLabel.textColor = .systemGray2
            messageLabel.lineBreakMode = .byWordWrapping
            messageLabel.numberOfLines = 0
            messageLabel.textAlignment = .center
            messageLabel.translatesAutoresizingMaskIntoConstraints = false
            messageLabel.sizeToFit()
            messageLabel.bringSubviewToFront(self)
            messageLabel.snp.makeConstraints { make in
                make.centerX.centerY.equalTo(self)
            }
        }
    }
}
