//
//  CAAnimation+Extension.swift
//  PinterestLikePullToPop
//
//  Created by Shingo Fukuyama
//

import UIKit

extension Extension where T == CAAnimation {
    static func curve(
        from startPoint: CGPoint,
        to endPoint: CGPoint,
        controlPoint: CGPoint) -> CAAnimation {
        let animation = CAKeyframeAnimation(keyPath: "position")
        let path = CGMutablePath()
        path.move(to: startPoint)
        path.addQuadCurve(to: endPoint, control: controlPoint)
        animation.path = path
        return animation
    }

    static func scale(
        to scaleTo: CGFloat) -> CAAnimation {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = scaleTo
        return animation
    }
}
