//
//  CartItemsTableViewCell.swift
//  Cidaas_Example
//
//  Created by ganesh on 07/10/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import Cosmos

class CartItemsTableViewCell: UITableViewCell {

    @IBOutlet var cartImage: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var color: UILabel!
    @IBOutlet var prize: UILabel!
    @IBOutlet var body: UILabel!
    @IBOutlet var rating: CosmosView!
    @IBOutlet var favourites: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
