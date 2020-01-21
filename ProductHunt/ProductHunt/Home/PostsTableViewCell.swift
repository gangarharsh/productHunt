//
//  PostsTableViewCell.swift
//  ProductHunt
//
//  Created by Harsh Gangar on 22/01/20.
//  Copyright © 2020 Harsh Gangar. All rights reserved.
//

import UIKit

class PostsTableViewCell: UITableViewCell {

    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var labelCreative: UILabel!
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView?.image = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
