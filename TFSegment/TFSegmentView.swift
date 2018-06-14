//
//  TFSegmentView.swift
//  TFSegment
//
//  Created by jiangyunfeng on 2018/6/12.
//  Copyright © 2018年 jiangyunfeng. All rights reserved.
//

import UIKit

public protocol TFSegmentViewDelegate : NSObjectProtocol {
    /// 点击item回调
    func select(_ index: NSInteger)
}

open class TFSegmentView: UIView {
    
    //MARK: 公开属性
    
    /**背景颜色, 默认白色*/
    public var backColor: UIColor = UIColor.white
    /**Item最大显示数, 默认8*/
    public var maxItemCount: NSInteger = 8
    /**Item宽度, 不设置则平分*/
    public var tabItemWidth: CGFloat = 0.0
    /**Item的title效果*/
    public var titleStyle: TFTitleTransformStyle = .default
    /**选中字体颜色*/
    public var selectedColor: UIColor = UIColor.red {
        didSet {
            selectColorRGB = TFColorRGB.init(color: selectedColor) //
        }
    }
    /**未选中字体颜色*/
    public var unSelectedColor: UIColor = UIColor.black {
        didSet {
            unSelectColorRGB = TFColorRGB.init(color: unSelectedColor) //
        }
    }
    /**默认字体大小*/
    public var titleFont: UIFont = UIFont.systemFont(ofSize: 16)
    /**未选中字体缩小比例，默认是0.8（0~1）*/
    public var selectFontScale: CGFloat = 0.8
    /**下标效果*/
    public var indicatorStyle: TFIndicatorWidthStyle = .default
    /**下标高度，默认是2.0*/
    public var indicatorHeight: CGFloat = 2.0
    /**下标宽度*/
    public var indicatorWidth: CGFloat = 20.0
    /**底部分割线颜色*/
    public var separatorColor: UIColor = UIColor.clear
    /**当前选择项*/
    public var selectedTabIndex: NSInteger = 0 {
        willSet {
            lastSelectedTabIndex = selectedTabIndex
        }
    }
    
    /**代理*/
    public weak var delegate: TFSegmentViewDelegate?

    //MARK: 过程记录
    private var tabItems = [TFItemLabel]() //Item数组
    private var lastSelectedTabIndex: NSInteger = 0 //记录上一次的索引
    private var isNeedRefreshLayout = true //滑动过程中不允许layoutSubviews
    private var isChangeByClick = false //是否是通过点击改变的
    private var leftItemIndex: NSInteger = 0 //记录滑动时左边的itemIndex
    private var rightItemIndex: NSInteger = 0 //记录滑动时右边的itemIndex
    private var leftToRight: Bool = true //从左到右
    private var numOfItemCount: NSInteger = 0 //最终显示Item个数
    private var shiftOffset: CGFloat = 0.0 { //偏移量在一页中的占比(0.0~1.0)
        didSet {
            if isChangeByClick {
                changeIndexWithAnimation()
            }
            print("\(shiftOffset)")
        }
    }
    
    private var selectColorRGB: TFColorRGB = TFColorRGB.init(color: UIColor.red) //
    private var unSelectColorRGB: TFColorRGB = TFColorRGB.init(color: UIColor.black) //
    //MARK: 数据源
    var titleDatas = [String]() //title数组
    
    //MARK: 初始化
    public init(frame: CGRect, titles: [String]) {
        super.init(frame: frame)
        titleDatas = titles
        numOfItemCount = titles.count < maxItemCount ?titles.count : maxItemCount
        
        
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: 懒加载子视图
    ///背景
    lazy var backView: UIView = {
        let bv = UIView()
        bv.backgroundColor = backColor
        return bv
    }()
    
    ///第一层子视图
    lazy var contentView: UIScrollView = {
        let cv = UIScrollView()
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.delegate = self
        cv.clipsToBounds = true
        return cv
    }()
    
    ///底部分割线
    lazy var separatorView: UIView = {
        let sv = UIView()
        sv.backgroundColor = separatorColor
        return sv
    }()
    
    ///下标
    lazy var indicatorView: UIView = {
        let iv = UIView()
        iv.backgroundColor = selectedColor
        return iv
    }()
    
    ///添加子视图
    func addAllSubViews() {
        self.addSubview(backView)
        self.addSubview(contentView)
        var i = 0
        for title in titleDatas {
            let titleItem = TFItemLabel()
            titleItem.font = titleFont
            titleItem.text = title
            titleItem.textColor = ((i == selectedTabIndex) ? selectedColor : unSelectedColor)
            titleItem.textAlignment = .center
            titleItem.isUserInteractionEnabled = true
            
            let tapRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(changeIndexWithClick(tap:)))
            titleItem.addGestureRecognizer(tapRecognizer)
            tabItems.append(titleItem)
            self.contentView.addSubview(titleItem)
            i = i + 1
        }
        self.addSubview(separatorView)
        self.addSubview(indicatorView)
    }
    
    override open func layoutSubviews() {
        if(isNeedRefreshLayout) {
            //tab layout
            if 0 == tabItemWidth {
                tabItemWidth = self.bounds.width/CGFloat(numOfItemCount)
            }
            
            self.contentView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
            self.contentView.contentSize = CGSize.init(width: tabItemWidth * CGFloat(numOfItemCount), height: 0)
            
            var i = 0
            for item in tabItems {
                item.frame = CGRect(x: 0, y: 0, width: tabItemWidth, height: self.bounds.height)
                i = i + 1
            }
            
            separatorView.frame = CGRect(x: 0, y: self.bounds.height-0.5, width: tabItemWidth * CGFloat(numOfItemCount), height: 0.5)
            self.layoutIndicatorViewWithStyle()
        }
    }
}

//MARK: 视图变化
extension TFSegmentView {
    /**根据不同风格对下标layout*/
    func layoutIndicatorViewWithStyle() {
        switch indicatorStyle {
        case .default:
            self.layoutIndicatorView()
        case .followText:
            self.layoutIndicatorView()
        case .stretch:
            self.layoutIndicatorView()
        default:
            self.layoutIndicatorView()
        }
    }
    
    func layoutIndicatorView() {
        let indicatorWidth: CGFloat = self.getIndicatorWidth(title: titleDatas[selectedTabIndex])
        let selecedTabItem = tabItems[selectedTabIndex]
        self.indicatorView.frame = CGRect.init(x: selecedTabItem.center.x - indicatorWidth / 2.0, y: self.bounds.height-indicatorHeight, width: indicatorWidth, height: indicatorHeight)
    }
    
    func changeIndexWithAnimation() {
        //调整title
        changeTitleIndexWithAnimation()
        
        //调整indicator
        changeIndicatorIndexWithAnimation()
    }
    
    //调整title
    func changeTitleIndexWithAnimation() {
        
        switch (titleStyle) {
        case .default:
            self.changeTitleWithDefault()
        case .gradual:
            self.changeTitleWithGradual()
        case .fill:
            self.changeTitleWithFill()
        default:
            break
        }
    }
    //调整indicator
    func changeIndicatorIndexWithAnimation() {
        switch (indicatorStyle) {
        case .default:
            self.changeIndicatorWithDefault()
        case .followText:
            self.changeIndicatorWithFollowText()
        case .stretch:
            self.changeIndicatorWithStretch()
        default:
            break
        }
    }
    
    //MARK: Item字体动画
    func changeTitleWithDefault() {
        if(shiftOffset > 0.5) {
            let selctTabItem = tabItems[rightItemIndex]
            let currentTabItem = tabItems[leftItemIndex]
            currentTabItem.textColor = unSelectedColor
            selctTabItem.textColor = selectedColor
        } else {
            let selctTabItem = tabItems[leftItemIndex]
            let currentTabItem = tabItems[rightItemIndex]
            currentTabItem.textColor = unSelectedColor
            selctTabItem.textColor = selectedColor
        }
    }
    func changeTitleWithGradual() {
        if leftItemIndex != rightItemIndex {
            
            let rightScale: CGFloat = shiftOffset
            let leftScale: CGFloat = 1.0 - rightScale
            
            //颜色渐变
            let difR = selectColorRGB.r-unSelectColorRGB.r
            let difG = selectColorRGB.g-unSelectColorRGB.g
            let difB = selectColorRGB.b-unSelectColorRGB.b
            
            let leftItemColor = UIColor.init(red: unSelectColorRGB.r+leftScale*difR, green: unSelectColorRGB.g+leftScale*difG, blue: unSelectColorRGB.b+leftScale*difB, alpha: 1.0)

            let rightItemColor = UIColor.init(red: unSelectColorRGB.r+rightScale*difR, green: unSelectColorRGB.g+rightScale*difG, blue: unSelectColorRGB.b+rightScale*difB, alpha: 1.0)
            
            let leftTabItem = tabItems[leftItemIndex]
            let rightTabItem = tabItems[rightItemIndex]
            leftTabItem.textColor = leftItemColor
            rightTabItem.textColor = rightItemColor
            
            //字体渐变
            leftTabItem.transform = CGAffineTransform(scaleX: selectFontScale+(1-selectFontScale)*leftScale, y: selectFontScale+(1-selectFontScale)*leftScale)
            rightTabItem.transform = CGAffineTransform(scaleX: selectFontScale+(1-selectFontScale)*rightScale, y: selectFontScale+(1-selectFontScale)*rightScale)
        }
    }
    func changeTitleWithFill() {
        if 0 == shiftOffset {
            return //起点和终点不处理，终点时左右index已更新，会绘画错误（你可以注释看看）
        }
        
        let leftTabItem = tabItems[leftItemIndex]
        let rightTabItem = tabItems[rightItemIndex]
        
        leftTabItem.textColor = selectedColor
        rightTabItem.textColor = unSelectedColor
        leftTabItem.fillColor = unSelectedColor
        rightTabItem.fillColor = selectedColor
        leftTabItem.process = shiftOffset
        rightTabItem.process = shiftOffset
    }
    
    //MARK: 下标动画
    func changeIndicatorWithDefault() {
        //计算indicator此时的centerx
        let nowIndicatorCenterX = tabItemWidth * (shiftOffset + CGFloat(leftItemIndex))
        self.indicatorView.frame = CGRect.init(x: nowIndicatorCenterX - indicatorWidth/2.0, y: self.indicatorView.frame.origin.y, width: indicatorWidth, height: indicatorHeight)

    }
    func changeIndicatorWithFollowText() {
        //计算indicator此时的centerx
        let nowIndicatorCenterX = tabItemWidth * (shiftOffset + CGFloat(leftItemIndex))
        //计算此时body的偏移量在一页中的占比
        var relativeLocation = shiftOffset
        //记录左右对应的indicator宽度
        let leftIndicatorWidth = getIndicatorWidth(title: titleDatas[leftItemIndex])
        let rightIndicatorWidth = getIndicatorWidth(title: titleDatas[rightItemIndex])
        
        
        //左右边界的时候，占比清0
        if(leftItemIndex == rightItemIndex) {
            relativeLocation = 0
        }
        //基于从左到右方向（无需考虑滑动方向），计算当前中心轴所处位置的长度
        let nowIndicatorWidth: CGFloat = leftIndicatorWidth + (rightIndicatorWidth - leftIndicatorWidth) * relativeLocation
        
        self.indicatorView.frame = CGRect(x: nowIndicatorCenterX - nowIndicatorWidth/2.0, y: self.indicatorView.frame.origin.y, width: nowIndicatorWidth, height: indicatorHeight)
    }
    func changeIndicatorWithStretch() {
        if(indicatorWidth <= 0) {
            return
        }
        //计算此时body的偏移量在一页中的占比
        var relativeLocation = shiftOffset
        //左右边界的时候，占比清0
        if(leftItemIndex == rightItemIndex) {
            relativeLocation = 0
        }
        
        let leftTabItem = tabItems[leftItemIndex]
        let rightTabItem = tabItems[rightItemIndex]
        
        //当前的frame
        var nowFrame = self.indicatorView.frame

        
        //重新计算frame
        if(relativeLocation <= 0.5) {
            let width = indicatorWidth + tabItemWidth * (relativeLocation / 0.5)
            nowFrame.size.width = width
        } else {
            let width = indicatorWidth + tabItemWidth * ((1 - relativeLocation) / 0.5)
            nowFrame.size.width = width
            if leftToRight {
                 nowFrame.origin.x = rightTabItem.center.x + indicatorWidth/2 - width
            } else {
                nowFrame.origin.x = leftTabItem.center.x + indicatorWidth/2 - width
            }
        }
        
        self.indicatorView.frame = nowFrame
    }
}

//MARK: 响应事件
extension TFSegmentView {
    /**Item点击*/
    @objc func changeIndexWithClick(tap: UITapGestureRecognizer) {
        let nextIndex: NSInteger = tabItems.index(of: tap.view as! TFItemLabel) ?? 0
        if(nextIndex != selectedTabIndex) {
            isChangeByClick = true
            changeSelectedItemToNextItem(nextIndex: nextIndex)
            contentView.isUserInteractionEnabled = false //防止快速切换
            if let del = delegate {
                del.select(nextIndex)
            }
        }
    }
    
    func changeSelectedItemToNextItem(nextIndex: NSInteger) {
        if abs(selectedTabIndex-nextIndex) > 1 {//间隔超过一格时，无动画效果
            let currentTabItem = tabItems[selectedTabIndex]
            let nextTabItem = tabItems[nextIndex]
            currentTabItem.textColor = unSelectedColor
            nextTabItem.textColor = selectedColor
            changeIndex(nextIndex: nextIndex)
            switch (indicatorStyle) {
            case .default, .stretch:
                self.changeIndicatorWithDefault()
            case .followText:
                self.changeIndicatorWithFollowText()
            }
        } else {//动画效果
            leftToRight = nextIndex > selectedTabIndex
            leftItemIndex = leftToRight ? selectedTabIndex : nextIndex
            rightItemIndex = leftToRight ? nextIndex : selectedTabIndex
            shiftOffset = leftToRight ? 0.0 : 1.0
            let toFloat: CGFloat = leftToRight ? 1.0 : 0.0
            selectedTabIndex = nextIndex
            UIView.animate(withDuration: 0.25, animations: {
                self.shiftOffset = toFloat
            }) { (finish) in
                //重置
                self.finishChangeAnimate()
            }
//            let timer = Timer.block_scheduledTimer(timeInterval: 0.1, repeats: true) { (ttimer) in
//
//            }
            
        }
        
    }
    
    func changeIndex(nextIndex: NSInteger) {
        leftItemIndex = nextIndex > selectedTabIndex ? selectedTabIndex : nextIndex
        rightItemIndex = nextIndex > selectedTabIndex ? nextIndex : selectedTabIndex
        selectedTabIndex = nextIndex
    }
    
}

//MARK: 工具
extension TFSegmentView {
    /**根据对应文本计算下标线宽度*/
    func getIndicatorWidth(title: String) -> CGFloat {
        if(indicatorStyle == .default || indicatorStyle == .stretch) {
            return indicatorWidth
        } else {
            if(title.count <= 2) {
                return 40.0
            } else {
                let width = CGFloat(title.count) * titleFont.pointSize + 12.0
                return width
            }
        }
    }
    
    func finishChangeAnimate() {
        shiftOffset = 0.0
        isNeedRefreshLayout = true
        isChangeByClick = false
        contentView.isUserInteractionEnabled = true
    }
}

extension TFSegmentView: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //滚动过程中不允许layout
        isNeedRefreshLayout = false
        if scrollView == contentView {
        } else {
            //未初始化时不处理
            if scrollView.contentSize.width <= 0 {
                return
            }

            //获取当前左右item index(点击方式已获知左右index，无需根据contentoffset计算)
            if(!isChangeByClick) {
                if(scrollView.contentOffset.x <= 0) { //左边界
                    leftItemIndex = 0
                    rightItemIndex = 0
                    
                } else if(scrollView.contentOffset.x >= (scrollView.contentSize.width-scrollView.bounds.width)) { //右边界
                    leftItemIndex = numOfItemCount-1
                    rightItemIndex = numOfItemCount-1
                    
                } else {
                    leftItemIndex = (NSInteger)(scrollView.contentOffset.x / scrollView.bounds.width)
                    rightItemIndex = leftItemIndex + 1
                    if rightItemIndex > selectedTabIndex {
                        leftToRight = true
                    }
                    if leftItemIndex < selectedTabIndex {
                        leftToRight = false
                    }
                }
                let conX = scrollView.contentOffset.x
                let rem = conX.truncatingRemainder(dividingBy: scrollView.bounds.width)
                if 0 == rem {
                    selectedTabIndex = NSInteger(scrollView.contentOffset.x / scrollView.bounds.width)
                }
                shiftOffset = rem / scrollView.bounds.width
                
            }
        }
        
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        finishChangeAnimate()
        if scrollView == contentView {
        } else {
            selectedTabIndex = (NSInteger)(scrollView.contentOffset.x / scrollView.bounds.width + CGFloat(0.5))
        }
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        finishChangeAnimate()
        if scrollView == contentView {
        } else {
            selectedTabIndex = (NSInteger)(scrollView.contentOffset.x / scrollView.bounds.width + CGFloat(0.5))
        }
    }
}

