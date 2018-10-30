//
//  ArticleListViewController.swift
//  Xcode10Test
//
//  Created by atsushi igarashi on 2018/10/23.
//  Copyright © 2018年 atsushi igarashi. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ArticleListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private enum LoadStatus {
        case initial
        case fetching
        case loadmore
        case full
        case error
    }
    
    let table = UITableView()
    var articles: [[String: String?]] = []
    private var page: Int = 1
    private var loadStatus: LoadStatus = LoadStatus.initial;
    let cellId: String = "ArticleListViewCell"
    let webViewId: String = "ArticleWebViewController"
    var isNewArticle: Bool = true
    var requestTag: String = "iOS"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = isNewArticle ? "新着" : requestTag
        table.frame = view.frame
        view.addSubview(table)
        table.dataSource = self
        table.delegate = self
        table.estimatedRowHeight = 118
        table.rowHeight = UITableView.automaticDimension
        getArticles()
        table.register(UINib(nibName: "ArticleListViewCell", bundle: nil), forCellReuseIdentifier: cellId)
    }
    
    func getArticles() {
        
        if loadStatus == LoadStatus.fetching || loadStatus == LoadStatus.full { return }
        loadStatus = LoadStatus.fetching
        
        var url:String = "https://qiita.com/api/v2/"
        url += isNewArticle ? "items?page=\(page)&per_page=20" : "tags/\(requestTag)/items?page=\(page)&per_page=20"
        
        // 新着記事読み込み
        Alamofire.request(url)
            .responseJSON { response in
                //print(response.result.value)
                guard let object = response.result.value else {
                    self.loadStatus = LoadStatus.error
                    return
                }
                
                let json = JSON(object)
                json.forEach { (_, json) in
                    //print(json["title"].string!)
                    //print(json["user"]["id"].string!)
                    let tags = self.getTag(json: json)
                    
                    let article: [String: String?] = [
                        "title": json["title"].string,
                        "userId": json["user"]["id"].string,
                        "url": json["url"].string,
                        "profile_image_url": json["user"]["profile_image_url"].string,
                        "likes_count": json["likes_count"].int?.description,
                        "tags": tags
                    ]
                    self.articles.append(article)
                }
                
                if self.articles.count == 0 {
                    self.loadStatus = LoadStatus.full
                    return
                }
                
                if self.page == 100 {
                    self.loadStatus = LoadStatus.full
                    return
                }
                
                print(self.articles)
                self.loadStatus = LoadStatus.loadmore
                self.page += 1
                self.table.reloadData()
        }
    }
    
    func getTag(json :JSON) -> String {
        
        var tags: String = ""
        let arrayTags = json["tags"].arrayValue.map({$0["name"].stringValue})
        
        for tag in arrayTags {
            tags.append(tag + ",")
        }
        if tags != "" {
            tags = String(tags.prefix(tags.count - 1))
        }
        return tags
    }
    
    /*
     * UITableViewDataSource
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = table.dequeueReusableCell(withIdentifier: cellId) as! ArticleListViewCell
        let article = articles[indexPath.row]
        if articles.count == 0 { return cell }
        cell.configureCell(article: article)
        return cell
    }
    
    /*
     * UITableViewDelegate
     */
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let currentOffsetY = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.height
        let distanceToBottom = maximumOffset - currentOffsetY
        //print("currentOffsetY: \(currentOffsetY)")
        //print("maximumOffset: \(maximumOffset)")
        //print("distanceToBottom: \(distanceToBottom)")
        
        if distanceToBottom < 250 {
            getArticles()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let article = articles[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let webView = storyboard.instantiateViewController(withIdentifier: webViewId) as! ArticleWebViewController
        webView.urlString = article["url"]!!
        self.present(webView, animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
