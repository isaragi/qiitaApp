//
//  ArticleListViewCell.swift
//  Xcode10Test
//
//  Created by atsushi igarashi on 2018/10/24.
//  Copyright © 2018年 atsushi igarashi. All rights reserved.
//

import UIKit
import Alamofire

class ArticleListViewCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func imageRequest() {
    
        Alamofire.request("firstURL").responseImage{ response in
            print(response)
        }
        
        
    }
    

}
