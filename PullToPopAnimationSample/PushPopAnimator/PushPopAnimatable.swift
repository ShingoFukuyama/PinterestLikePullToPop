//
//  PushPopAnimatable.swift
//  PinterestLikePullToPop
//
//  Created by Shingo Fukuyama
//

import UIKit

protocol PushPopAnimatable where Self: UIViewController {
    var animationTargetView: UIView? { get }
    var animationTargetFrame: CGRect? { get }
}

typealias PushPopAnimatableViewController = UIViewController & PushPopAnimatable
