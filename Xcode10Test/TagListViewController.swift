//
//  TagListViewController.swift
//  Xcode10Test
//
//  Created by atsushi igarashi on 2018/10/30.
//  Copyright © 2018年 atsushi igarashi. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AlamofireImage

class TagListViewController: UIViewController ,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    private enum LoadStatus {
        case initial
        case fetching
        case loadmore
        case full
        case error
    }
    
    private var tags: [[String: String?]] = []
    private var page: Int = 1
    private var loadStatus: LoadStatus = LoadStatus.initial;
    private static let cellId: String = "TagListViewCell"

    override func viewDidLoad() {
        
        super.viewDidLoad()
        getTags()
    }
    
    func getTags() {
        
        if self.loadStatus == LoadStatus.fetching || self.loadStatus == LoadStatus.full { return }
        self.loadStatus = LoadStatus.fetching
        
        // タグ読み込み
        Alamofire.request("https://qiita.com/api/v2/tags?page=\(page)&per_page=50&sort=count")
            .responseJSON { response in
                //print(response.result.value)
                guard let object = response.result.value else {
                    self.loadStatus = LoadStatus.error
                    return
                }
                
                let json = JSON(object)
                json.forEach { (_, json) in
                    
                    let tag: [String: String?] = [
                        "icon_url": json["icon_url"].string,
                        "id": json["id"].string,
                    ]
                    self.tags.append(tag)
                }
                
                if self.tags.count == 0 {
                    self.loadStatus = LoadStatus.full
                    return
                }
                
                if self.page == 100 {
                    self.loadStatus = LoadStatus.full
                    return
                }
                
                print(self.tags)
                self.loadStatus = LoadStatus.loadmore
                self.page += 1
                let collectionView = self.view.viewWithTag(3) as! UICollectionView
                collectionView.reloadData()
        }
    }
    
    /*
     * UICollectionViewDataSource
     */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.tags.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell: TagListCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: TagListViewController.cellId, for: indexPath) as! TagListCollectionViewCell
        let tag = self.tags[indexPath.row]
        cell = cell.configureCell(tag: tag)
        
        return cell
    }

    /*
     * UICollectionViewDelegateFlowLayout
     */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let horizontalSpace:CGFloat = 2
        let cellSize:CGFloat = self.view.bounds.width / 5 - horizontalSpace

        return CGSize(width: cellSize, height: cellSize)
    }
    
    /*
     * UICollectionViewDelegate
     */
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let articleListView = ArticleListViewController()
        let tag = self.tags[indexPath.row]
        articleListView.requestTag = tag["id"]!!
        articleListView.isNewArticle = false
        self.navigationController?.pushViewController(articleListView, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let currentOffsetY = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.height
        let distanceToBottom = maximumOffset - currentOffsetY
        //print("currentOffsetY: \(currentOffsetY)")
        //print("maximumOffset: \(maximumOffset)")
        //print("distanceToBottom: \(distanceToBottom)")
        
        if distanceToBottom < 250 {
            getTags()
        }
    }
}
