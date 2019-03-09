//
//  CGRect+Extension.swift
//  PinterestLikePullToPop
//
//  Created by Shingo Fukuyama
//

import CoreGraphics

extension CGRect: ExtensionCompatible { }
extension Extension where T == CGRect {
    var center: CGPoint {
        return CGPoint(x: base.midX, y: base.midY)
    }
}
