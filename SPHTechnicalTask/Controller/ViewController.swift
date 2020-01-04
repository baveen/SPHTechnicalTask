//
//  ViewController.swift
//  SPHTechnicalTask
//
//  Created by Baveendran Nagendran on 1/4/20.
//  Copyright © 2020 rbtechsolutions. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        UsageViewModel().getDataUsage(offset: 20) { (response, error) in
            if let data = response {
                print(data)
            } else {
                print(error ?? "")
            }
        }
    }


}

