//
//  AnimatableNavigationController.swift
//  PinterestLikePullToPop
//
//  Created by Shingo Fukuyama
//

import UIKit

class AnimatableNavigationController: UINavigationController {
    let animator = PushPopAnimator()
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = animator
    }
}

enum AnimatableNavigationState {
    static var isPullToPopInteraction: Bool = false
}
