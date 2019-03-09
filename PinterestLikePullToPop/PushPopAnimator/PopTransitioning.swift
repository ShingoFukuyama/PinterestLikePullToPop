//
//  PopTransitioning.swift
//  PinterestLikePullToPop
//
//  Created by Shingo Fukuyama
//

import UIKit

class PopTransitioning: NSObject,
    UIViewControllerAnimatedTransitioning
{
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }

    func animateTransition(
        using context: UIViewControllerContextTransitioning) {
        guard
            let fromView = context.view(forKey: .from),
            let toView = context.view(forKey: .to),
            let fromVC = context.viewController(forKey: .from) as? PushPopAnimatableViewController,
            let toVC = context.viewController(forKey: .to) as? PushPopAnimatableViewController,
            let targetView = fromVC.animationTargetView?.ext.asImageView(),
            let targetPositionFrom = fromVC.animationTargetFrame,
            let targetPositionTo = toVC.animationTargetFrame
            else
        {
            return
        }
        let containerView = context.containerView
        containerView.insertSubview(toView, belowSubview: fromView)

        containerView.addSubview(targetView)
        targetView.frame = targetPositionFrom

        fromVC.animationTargetView?.isHidden = true
        toVC.animationTargetView?.isHidden = true

        UIView.animate(
            withDuration: transitionDuration(using: context),
            delay: 0,
            options: [.curveEaseInOut],
            animations: {
                fromView.alpha = 0
                targetView.frame = targetPositionTo
        }, completion: { _ in
            fromVC.animationTargetView?.isHidden = false
            toVC.animationTargetView?.isHidden = false
            targetView.removeFromSuperview()
            context.completeTransition(
                !context.transitionWasCancelled)
        })
    }
}
