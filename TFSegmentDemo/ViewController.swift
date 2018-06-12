//
//  ViewController.swift
//  TFSegmentDemo
//
//  Created by jiangyunfeng on 2018/6/12.
//  Copyright © 2018年 jiangyunfeng. All rights reserved.
//

import UIKit
import TFSegment

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let k = TFItemLabel.init(frame: CGRect.init(x: 200, y: 200, width: 100, height: 200))
        k.text = "1234567890"
        k.defaultColor = UIColor.blue
        k.fillColor = UIColor.red
        view.addSubview(k)
        k.process = 0.3
        // Do any additional setup after loading the view, typically from a nib.

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

