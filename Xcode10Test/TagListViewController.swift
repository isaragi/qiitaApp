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
    
    var tags: [[String: String?]] = []
    private var loadStatus: LoadStatus = LoadStatus.initial;
    let cellId: String = "TagListViewCell"
    private var page: Int = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        getTags()
    }
    
    func getTags() {
        
        if loadStatus == LoadStatus.fetching || loadStatus == LoadStatus.full { return }
        loadStatus = LoadStatus.fetching
        
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)

        let tag = tags[indexPath.row]
        let label = cell.contentView.viewWithTag(2) as! UILabel
        label.text = tag["id"]!
        
        var imageView = cell.contentView.viewWithTag(1) as! UIImageView
        guard let url = tag["icon_url"]! else {
            imageView.image = Image(named: "no-image")
            return cell
        }
        let requestUrl = URL(string: url)!
        
        imageView.af_setImage(
            withURL:requestUrl,
            placeholderImage: UIImage(named: "no-image"),
            filter: nil,
            progress:nil,
            progressQueue: DispatchQueue.main,
            imageTransition: .noTransition,
            runImageTransitionIfCached: false,
            completion: nil
        )
        
        return cell
    }

    // Screenサイズに応じたセルサイズを返す
    // UICollectionViewDelegateFlowLayoutの設定が必要
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // 横方向のスペース調整
        let horizontalSpace:CGFloat = 2
        let cellSize:CGFloat = self.view.bounds.width / 5 - horizontalSpace
        // 正方形で返すためにwidth,heightを同じにする
        return CGSize(width: cellSize, height: cellSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let articleListView = ArticleListViewController()
        let tag = tags[indexPath.row]
        articleListView.requestTag = tag["id"]!!
        articleListView.isNewArticle = false
        self.navigationController?.pushViewController(articleListView, animated: true)
        
    }
    
    @IBAction func backBtnDidTap(_ sender: Any) {
        dismiss(animated: true, completion: {
            NSLog("Close View: %@", NSStringFromClass(type(of: self)) )
            //[presentingViewController] () -> Void in
            //presentingViewController?.viewWillAppear(true)
        })
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
