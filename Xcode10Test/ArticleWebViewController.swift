//
//  ArticleWebViewController.swift
//  Xcode10Test
//
//  Created by atsushi igarashi on 2018/10/28.
//  Copyright © 2018年 atsushi igarashi. All rights reserved.
//

import UIKit
import WebKit

class ArticleWebViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    var urlString :String = String()
    var progressView = UIProgressView()
    
    override func viewDidLoad() {

        super.viewDidLoad()
        self.webView.allowsBackForwardNavigationGestures = true
        self.webView.addObserver(self, forKeyPath: "loading", options: .new, context: nil)
        self.webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        self.webView.addObserver(self, forKeyPath: "title", options: .new, context: nil)
        
        progressView = UIProgressView(frame: CGRect(x: 0, y: self.navigationBar.frame.size.height - 2, width: self.view.frame.size.width, height: 10))
        progressView.progressViewStyle = .bar
        progressView.progressTintColor = UIColor.green;
        self.navigationBar.addSubview(progressView)
        let url = URL(string: urlString)
        let urlRequest = URLRequest(url: url!)
        self.webView.load(urlRequest)
    }
    

    deinit {
        self.webView.removeObserver(self, forKeyPath: "loading")
        self.webView.removeObserver(self, forKeyPath: "estimatedProgress")
        self.webView.removeObserver(self, forKeyPath: "title")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "estimatedProgress" {
            //estimatedProgressが変更されたときに、setProgressを使ってプログレスバーの値を変更する。
            self.progressView.setProgress(Float(self.webView.estimatedProgress), animated: true)
        } else if keyPath == "loading" {
            UIApplication.shared.isNetworkActivityIndicatorVisible = self.webView.isLoading
            if self.webView.isLoading {
                self.progressView.setProgress(0.08, animated: true)
            } else {
                //読み込みが終わったら0に
                self.progressView.setProgress(0.0, animated: false)
            }
        } else if keyPath == "title" {
            if let title = change?[NSKeyValueChangeKey.newKey] as? NSString {
                self.navigationBar.topItem?.title = title as String
            }
            
        }
    }

    @IBAction func closeBtnDidTap(_ sender: Any) {
        dismiss(animated: true, completion: {
            NSLog("Close View: %@", NSStringFromClass(type(of: self)) )
        })
    }
}
