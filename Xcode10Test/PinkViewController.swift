//
//  PinkViewController.swift
//  Xcode10Test
//
//  Created by atsushi igarashi on 2018/10/21.
//  Copyright © 2018年 atsushi igarashi. All rights reserved.
//

import UIKit

class PinkViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func backBtnDidTap(_ sender: Any) {
        dismiss(animated: true, completion: {
            NSLog("Close View: %@", NSStringFromClass(type(of: self)) )
            //[presentingViewController] () -> Void in
            //presentingViewController?.viewWillAppear(true)
        })
    }
    
}
