//
//  PostTableViewCell.swift
//  azenia
//
//  Created by MacBook Pro on 6/11/21.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var authorImage: UIButton!
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var authorName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
