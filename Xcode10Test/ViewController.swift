//
//  ViewController.swift
//  Xcode10Test
//
//  Created by atsushi igarashi on 2018/10/21.
//  Copyright © 2018年 atsushi igarashi. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func submit(_ sender: Any) {
        NSLog("submit" )

        // 天気情報APIにアクセスする
//        Alamofire.request("http://weather.livedoor.com/forecast/webservice/json/v1?city=130010").responseJSON {response in
//            print("Request: \(String(describing: response.request))")
//            print("Response: \(String(describing: response.response))")
//            print("Result: \(String(describing: response.result))")
//
//            if let json = response.result.value {
//                print("JSON: \(json)")  // serialized json response
//            }
//
//            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
//                print("Data: \(utf8Text)")  // original server data as UTF8 String
//            }
//        }
        
//        Alamofire.request("https://qiita.com/api/v2/tags?page=1&per_page=20&sort=count").responseJSON {response in
//            print("Request: \(String(describing: response.request))")
//            print("Response: \(String(describing: response.response))")
//            print("Result: \(String(describing: response.result))")
//
//            if let json = response.result.value {
//                print("JSON: \(json)")  // serialized json response
//            }
//
//            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
//                print("Data: \(utf8Text)")  // original server data as UTF8 String
//            }
//        }
        
        
        Alamofire.request("https://qiita.com/api/v2/tags/ios/items?page=1&per_page=15").responseJSON {response in
            print("Request: \(String(describing: response.request))")
            print("Response: \(String(describing: response.response))")
            print("Result: \(String(describing: response.result))")
            
            if let json = response.result.value {
                print("JSON: \(json)")  // serialized json response
            }
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)")  // original server data as UTF8 String
            }
        }

    }
    
    @IBAction func backToTop(segue: UIStoryboardSegue) {
    }
    
    @IBAction func didTapStoryboardBtn(_ sender: Any) {
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main2", bundle: nil)
        let nextView = storyboard.instantiateInitialViewController() as! UINavigationController
        self.present(nextView, animated: true, completion: nil)
    }
    
    @IBAction func didTapDismissBtn(_ sender: Any) {
        dismiss(animated: true, completion: {
            NSLog("Close View: %@", NSStringFromClass(type(of: self)) )
        })
    }
}

