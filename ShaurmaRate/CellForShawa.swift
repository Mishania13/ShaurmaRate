//
//  CellForShawa.swift
//  ShaurmaRate
//
//  Created by Mr. Bear on 26.03.2020.
//  Copyright © 2020 Mr. Bear. All rights reserved.
//

import UIKit
import  Cosmos

class CellForShawa: UITableViewCell {
    
    @IBOutlet weak var imageOfPlace: UIImageView! {
        didSet {
            imageOfPlace?.layer.cornerRadius = imageOfPlace.frame.size.height/2
            imageOfPlace?.clipsToBounds = true
        }
    }
    @IBOutlet weak var shawaName: UILabel!
    @IBOutlet weak var locationLable: UILabel!
    @IBOutlet weak var shawaPrice: UILabel!
    @IBOutlet weak var cosmosView: CosmosView! {
        didSet {
            cosmosView.settings.updateOnTouch = false
        }
    }
    
}
