//
//  PullToPopAnimatable.swift
//  PinterestLikePullToPop
//
//  Created by Shingo Fukuyama
//

import UIKit

protocol PullToPopAnimatable
    where Self: UIGestureRecognizerDelegate & PushPopAnimatable
{
    var pullToPopAnimator: PullToPopAnimator? { get }
    func interactionDidBegin()
    func interactionDidChange(percent: CGFloat)
    func interactionDidFinish()
    func interactionDidCancel()
}

extension PullToPopAnimatable {
    func interactionDidBegin() { }
    func interactionDidChange(percent: CGFloat) { }
    func interactionDidFinish() { }
    func interactionDidCancel() { }
}
