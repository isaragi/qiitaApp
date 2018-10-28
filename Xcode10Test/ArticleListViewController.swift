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

    struct LoadStatus {
        var initial:String  = "initial"
        var fetching:String = "fetching"
        var loadmore:String = "loadmore"
        var full:String     = "full"
        var error:String    = "error"
    }
    
    let table = UITableView()
    var articles: [[String: String?]] = []
    let cellHeiht: CGFloat = 91.0
    private var page: Int = 1
    private var loadStatus: String = LoadStatus().initial;
    let cellId:String = "ArticleListViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "新着"
        table.frame = view.frame
        view.addSubview(table)
        table.dataSource = self
        table.delegate = self
        getArticles()
        table.register(UINib(nibName: "ArticleListViewCell", bundle: nil), forCellReuseIdentifier: cellId)
    }
    
    func getArticles() {
        
        guard loadStatus != LoadStatus().fetching && loadStatus != LoadStatus().full else { return }
        loadStatus = LoadStatus().fetching
        
        Alamofire.request("https://qiita.com/api/v2/items?page=\(page)&per_page=20")
            .responseJSON { response in
                //print(response.result.value)
                guard let object = response.result.value else {
                    self.loadStatus = LoadStatus().error
                    return
                }
                
                let json = JSON(object)
                json.forEach { (_, json) in
                    //print(json["title"].string!)
                    //print(json["user"]["id"].string!)
                    let article: [String: String?] = [
                        "title": json["title"].string,
                        "userId": json["user"]["id"].string
                    ]
                    self.articles.append(article)
                }
                
                if self.articles.count == 0 {
                    self.loadStatus = LoadStatus().full
                    return
                }
                
                if self.page == 100 {
                    self.loadStatus = LoadStatus().full
                    return
                }
                
                print(self.articles)
                self.page += 1
                self.table.reloadData()
                self.loadStatus = LoadStatus().loadmore
        }
    }
    
    /*
     * UITableViewDataSource
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = table.dequeueReusableCell(withIdentifier: cellId) as! ArticleListViewCell
        
        //let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let article = articles[indexPath.row] // 行数番目の記事を取得
        cell.titleLabel.text = article["title"]!
        cell.userNameLabel.text = article["userId"]!
        
        //cell.textLabel?.text = article["title"]! // 記事のタイトルをtextLabelにセット
        //cell.detailTextLabel?.text = article["userId"]! // 投稿者のユーザーIDをdetailTextLabelにセット
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeiht
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
            //viewModel.fetchArticles()
            getArticles()
        }
    }
    
}
