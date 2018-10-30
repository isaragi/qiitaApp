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
    
    private let tableView = UITableView()
    private var articles: [[String: String?]] = []
    private var page: Int = 1
    private var loadStatus: LoadStatus = LoadStatus.initial;
    private static let cellId: String = "ArticleListViewCell"
    private static let webViewId: String = "ArticleWebViewController"
    var isNewArticle: Bool = true
    var requestTag: String = "iOS"
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        title = isNewArticle ? "新着" : requestTag
        self.tableView.frame = view.frame
        view.addSubview(tableView)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.estimatedRowHeight = 118
        self.tableView.rowHeight = UITableView.automaticDimension
        getArticles()
        self.tableView.register(UINib(nibName: "ArticleListViewCell", bundle: nil), forCellReuseIdentifier: ArticleListViewController.cellId)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.onOrientationChange(notification:)),name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    @objc func onOrientationChange(notification: NSNotification) {
        
        self.tableView.frame.size = CGSize(width: view.frame.width, height: view.frame.height)
        self.tableView.setNeedsDisplay()
        self.tableView.reloadData()
    }
    
    func getArticles() {
        
        if self.loadStatus == LoadStatus.fetching || self.loadStatus == LoadStatus.full { return }
        self.loadStatus = LoadStatus.fetching
        
        var url = "https://qiita.com/api/v2/"
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
                self.tableView.reloadData()
        }
    }
    
    // タグの連結文字列を整形
    func getTag(json :JSON) -> String {
        
        var tags = ""
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
        
        return self.articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ArticleListViewController.cellId) as! ArticleListViewCell
        let article = self.articles[indexPath.row]
        if self.articles.count == 0 { return cell }
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

        let article = self.articles[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let webView = storyboard.instantiateViewController(withIdentifier: ArticleListViewController.webViewId) as! ArticleWebViewController
        webView.urlString = article["url"]!!
        self.present(webView, animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
