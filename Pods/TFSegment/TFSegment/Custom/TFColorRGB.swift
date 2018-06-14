//
//  TFColorRGB.swift
//  TFSegment
//
//  Created by jiangyunfeng on 2018/6/12.
//  Copyright © 2018年 jiangyunfeng. All rights reserved.
//

import UIKit
import CoreGraphics

public struct TFColorRGB {
    public var r : CGFloat = 0.0
    public var g : CGFloat = 0.0
    public var b : CGFloat = 0.0
    public init(color: UIColor) {
        let colors = color.cgColor.components
        self.r = colors?[0] ?? 0.0
        self.g = colors?[1] ?? 0.0
        self.b = colors?[2] ?? 0.0
    }
}
