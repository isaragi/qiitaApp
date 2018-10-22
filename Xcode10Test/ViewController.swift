//
//  ViewController.swift
//  Xcode10Test
//
//  Created by atsushi igarashi on 2018/10/21.
//  Copyright © 2018年 atsushi igarashi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func submit(_ sender: Any) {
        NSLog("submit" )

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

