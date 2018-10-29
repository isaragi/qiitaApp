//
//  ArticleListViewCell.swift
//  Xcode10Test
//
//  Created by atsushi igarashi on 2018/10/24.
//  Copyright © 2018年 atsushi igarashi. All rights reserved.
//

import UIKit
import AlamofireImage

class ArticleListViewCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tags: UILabel!
    @IBOutlet weak var likesCountLabel: UILabel!
    
    let article: [String: String?] = [:]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(article: [String: String?]) {
        
        self.titleLabel.text = article["title"]!
        let countString : String? = article["likes_count"]!
        self.likesCountLabel.text = (countString != nil) ? countString : "0"
        self.userNameLabel.text = "by " + article["userId"]!!
        self.tags.text = article["tags"]!
//        cell.tags.text = "Python  機械学習  AI  AIAcademy  ディープラーンング"
        let url = article["profile_image_url"]!
        let requestUrl = URL(string: url!)!
        
        self.userImageView!.af_setImage(
            withURL:requestUrl,
            placeholderImage: UIImage(named: "no-image"),
            filter: nil,
            progress:nil,
            progressQueue: DispatchQueue.main,
            imageTransition: .noTransition,
            runImageTransitionIfCached: false,
            completion: nil)
    }
    

}
