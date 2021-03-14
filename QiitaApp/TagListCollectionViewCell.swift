//
//  TagListCollectionViewCell.swift
//  Xcode10Test
//
//  Created by atsushi igarashi on 2018/10/31.
//  Copyright © 2018年 atsushi igarashi. All rights reserved.
//

import UIKit
import AlamofireImage

class TagListCollectionViewCell: UICollectionViewCell {
    
    private let article: [String: String?] = [:]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(tag: [String: String?]) -> TagListCollectionViewCell {
        
        
        let label = self.contentView.viewWithTag(2) as! UILabel
        label.text = tag["id"]!
        
        let imageView = self.contentView.viewWithTag(1) as! UIImageView
        guard let url = tag["icon_url"]! else {
            imageView.image = Image(named: "no-image")
            return self
        }
        
        let requestUrl = URL(string: url)!
        imageView.af_setImage(
            withURL:requestUrl,
            placeholderImage: UIImage(named: "no-image"),
            filter: nil,
            progress:nil,
            progressQueue: DispatchQueue.main,
            imageTransition: .crossDissolve(0.5),
            runImageTransitionIfCached: false,
            completion: nil
        )
        
        return self
    }
}
