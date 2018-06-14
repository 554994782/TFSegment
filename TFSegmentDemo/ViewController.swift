//
//  ViewController.swift
//  TFSegmentDemo
//
//  Created by jiangyunfeng on 2018/6/12.
//  Copyright © 2018年 jiangyunfeng. All rights reserved.
//

import UIKit
import Foundation
import TFSegment

class ViewController: UIViewController {

    var titleArray: [String] = ["北京", "天津西", "上海", "澳大利亚", "新加坡", "深圳"]
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(segmentView)
        view.addSubview(scrollView)
        scrollviewAddSubViews()
        // Do any additional setup after loading the view, typically from a nib.

    }
    
    ///第一层子视图
    lazy var segmentView: TFSegmentView = {
        let sv = TFSegmentView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 80), titles: titleArray)
        sv.delegate = self
        sv.delegateScrollView = scrollView
        sv.titleStyle = .fill
        sv.indicatorStyle = .stretch
        return sv
    }()
    
    ///
    lazy var scrollView: UIScrollView = {
        let sv = UIScrollView.init(frame: CGRect.init(x: 0, y: 80, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-80))
        sv.delegate = self
        sv.contentSize = CGSize.init(width: UIScreen.main.bounds.width * CGFloat(titleArray.count), height: UIScreen.main.bounds.height-80)
        sv.isPagingEnabled = true
        return sv
    }()
    
    func scrollviewAddSubViews() {
        var i = 0
        for stitle in titleArray {
            let label = UILabel.init(frame: CGRect.init(x: CGFloat(i) * UIScreen.main.bounds.width, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-80))
            label.text = stitle
            label.textColor = UIColor.orange
            label.font = UIFont.boldSystemFont(ofSize: 50)
            label.textAlignment = .center
            i = i + 1
            scrollView.addSubview(label)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: TFSegmentViewDelegate {
    func select(_ index: NSInteger, animated: Bool) {
        print("\(index)")
        
        
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        segmentView.scrollViewDidScroll(scrollView)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        segmentView.scrollViewDidEndDecelerating(scrollView)
    }
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        segmentView.scrollViewDidEndScrollingAnimation(scrollView)
    }
}
