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
        self.title = "示例代码"
        self.view.backgroundColor = UIColor.orange
//        view.addSubview(segmentView1)
//        view.addSubview(segmentView2)
        view.addSubview(segmentView3)
//        view.addSubview(segmentView4)
        view.addSubview(scrollView)
        scrollviewAddSubViews()
        // Do any additional setup after loading the view, typically from a nib.

    }
    
    ///第1层子视图
    lazy var segmentView1: TFSegmentView = {
        let sv = TFSegmentView(frame: CGRect.init(x: 0, y: 60, width: UIScreen.main.bounds.width, height: 60), titles: titleArray)
        sv.delegate = self
        sv.delegateScrollView = scrollView
        sv.titleStyle = .default //文字颜色直接变
        sv.indicatorStyle = .default //下标无拉伸变化
        sv.selectFontScale = 1.0//文字缩放比例，文字不缩放
        return sv
    }()
    
    ///第2层子视图
    lazy var segmentView2: TFSegmentView = {
        let sv = TFSegmentView(frame: CGRect.init(x: 0, y: 60, width: UIScreen.main.bounds.width, height: 60), titles: titleArray)
        sv.delegate = self
        sv.delegateScrollView = scrollView
        sv.titleStyle = .gradual//title颜色渐变
        sv.indicatorStyle = .followText//下标随文本长度变化
        return sv
    }()
    
    ///第3层子视图
    lazy var segmentView3: TFSegmentView = {
        let sv = TFSegmentView(frame: CGRect.init(x: 0, y: 60, width: UIScreen.main.bounds.width, height: 60), titles: titleArray)
        sv.delegate = self
        sv.delegateScrollView = scrollView
        sv.titleStyle = .fill//title颜色进度填充
        sv.indicatorStyle = .stretch//下标拉伸变化
        return sv
    }()
    
    ///第4层子视图
    lazy var segmentView4: TFSegmentView = {
        let sv = TFSegmentView(frame: CGRect.init(x: 0, y: 60, width: UIScreen.main.bounds.width, height: 60), titles: titleArray)
        sv.delegate = self
        sv.delegateScrollView = scrollView
        sv.titleStyle = .fill//title颜色进度填充
        sv.indicatorStyle = .followTextStretch//下标随文本长度变化 且 拉伸变化
        return sv
    }()
    
    ///
    lazy var scrollView: UIScrollView = {
        let sv = UIScrollView.init(frame: CGRect.init(x: 0, y: 122, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-122))
        sv.delegate = self
        sv.contentSize = CGSize.init(width: UIScreen.main.bounds.width * CGFloat(titleArray.count), height: UIScreen.main.bounds.height-122)
        sv.isPagingEnabled = true
        return sv
    }()
    
    func scrollviewAddSubViews() {
        var i = 0
        for stitle in titleArray {
            let label = UILabel.init(frame: CGRect.init(x: CGFloat(i) * UIScreen.main.bounds.width, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-122))
            label.text = stitle
            label.textColor = UIColor.orange
            label.font = UIFont.boldSystemFont(ofSize: 50)
            label.textAlignment = .center
            let num = CGFloat(arc4random() % 256)
            print("num  \(num)")
            label.backgroundColor = UIColor(red: num/255.0, green: num/255.0, blue: num/255.0, alpha: 1.0)
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
        segmentView1.scrollViewDidScroll(scrollView)
        segmentView2.scrollViewDidScroll(scrollView)
        segmentView3.scrollViewDidScroll(scrollView)
        segmentView4.scrollViewDidScroll(scrollView)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        segmentView1.scrollViewDidEndDecelerating(scrollView)
        segmentView2.scrollViewDidEndDecelerating(scrollView)
        segmentView3.scrollViewDidEndDecelerating(scrollView)
        segmentView4.scrollViewDidEndDecelerating(scrollView)
    }
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        segmentView1.scrollViewDidEndScrollingAnimation(scrollView)
        segmentView2.scrollViewDidEndScrollingAnimation(scrollView)
        segmentView3.scrollViewDidEndScrollingAnimation(scrollView)
        segmentView4.scrollViewDidEndScrollingAnimation(scrollView)
    }
}
