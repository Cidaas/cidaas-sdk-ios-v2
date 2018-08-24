//
//  DeduplicationTableViewCell.swift
//  SDKCheck
//
//  Created by ganesh on 18/08/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import UIKit

class DeduplicationTableViewCell: UITableViewCell {

    @IBOutlet var name: UILabel!
    @IBOutlet var email: UILabel!
    @IBOutlet var imageview: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageview.layer.cornerRadius = (imageview?.frame.size.width ?? 0.0) / 2
        imageview.clipsToBounds = true
        imageview.layer.borderWidth = 3.0
        imageview.layer.borderColor = UIColor.white.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
