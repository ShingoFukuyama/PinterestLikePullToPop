//
//  PushPopAnimator.swift
//  PinterestLikePullToPop
//
//  Created by Shingo Fukuyama
//

import UIKit

class PushPopAnimator: NSObject { }

extension PushPopAnimator: UINavigationControllerDelegate {
    func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationController.Operation,
        from fromVC: UIViewController,
        to toVC: UIViewController)
        -> UIViewControllerAnimatedTransitioning?
    {
        switch operation {
        case .push:
            guard fromVC is PushPopAnimatableViewController,
                toVC is DetailViewController else {
                    break
            }
            return PushTransitioning() as UIViewControllerAnimatedTransitioning
        case .pop:
            guard fromVC is DetailViewController,
                toVC is PushPopAnimatableViewController else {
                    break
            }
            if AnimatableNavigationState.isPullToPopInteraction {
                AnimatableNavigationState.isPullToPopInteraction = false
                return PullToPopTransitioning() as UIViewControllerAnimatedTransitioning
            } else {
                return PopTransitioning() as UIViewControllerAnimatedTransitioning
            }
        case .none:
            break
        }
        return nil
    }
}
