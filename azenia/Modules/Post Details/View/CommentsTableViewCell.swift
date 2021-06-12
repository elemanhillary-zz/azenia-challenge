//
//  CommentsTableViewCell.swift
//  azenia
//
//  Created by MacBook Pro on 6/11/21.
//

import UIKit

class CommentsTableViewCell: UITableViewCell {
    @IBOutlet weak var commentAuthor: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
