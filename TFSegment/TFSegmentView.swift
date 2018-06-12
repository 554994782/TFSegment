//
//  TFSegmentView.swift
//  TFSegment
//
//  Created by jiangyunfeng on 2018/6/12.
//  Copyright © 2018年 jiangyunfeng. All rights reserved.
//

import UIKit

enum TFTitleTransformStyle: Int {
    case `default` = 0 //正常
    case gradual //颜色渐变
    case fill //颜色填充
}

enum TFIndicatorWidthStyle: Int {
    case `default` = 0 //自定义宽度
    case followText //随文本长度变化
    case tretch //拉伸
}

open class TFSegmentView: UIView {
    
    //MARK: 公开属性
    public var selectedColor: UIColor = UIColor.red //选中字体颜色
    public var unSelectedColor: UIColor = UIColor.black //未选中字体颜色
    public var selectFont: UIFont = UIFont.systemFont(ofSize: 15) //默认字体大小
    public var selectFontScale: CGFloat = 0.8 //未选中字体缩小比例，默认是0.8（0~1）
    public var indicatorHeight: CGFloat = 2.0 //下标高度，默认是2.0
    
    //MARK: 私有属性
    private var indicatorWidth: CGFloat = 0.0 //下标宽度
    private var tabItemWidth: CGFloat = 0.0 //Item宽度

    //MARK: 记录
    private var tabItems = [TFItemLabel]() //Item数组
    private var lastSelectedTabIndex = 0 //记录上一次的索引
    private var isNeedRefreshLayout = true //滑动过程中不允许layoutSubviews
    private var isChangeByClick = false //是否是通过点击改变的
    private var leftItemIndex = 0 //记录滑动时左边的itemIndex
    private var rightItemIndex = 0 //记录滑动时右边的itemIndex
    
    //MARK: 数据源
    var titleDatas = [String]() //title数组
    
    
    public init(frame: CGRect, titles: [String]) {
        super.init(frame: frame)
        self.titleDatas = titles
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
