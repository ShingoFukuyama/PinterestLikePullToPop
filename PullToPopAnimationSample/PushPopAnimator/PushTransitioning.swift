//
//  PushTransitioning.swift
//  PinterestLikePullToPop
//
//  Created by Shingo Fukuyama
//

import UIKit

class PushTransitioning: NSObject,
    UIViewControllerAnimatedTransitioning
{
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }

    func animateTransition(
        using transitionContext: UIViewControllerContextTransitioning) {
        guard
            //let fromView = transitionContext.view(forKey: .from),
            let toView = transitionContext.view(forKey: .to),
            let fromVC = transitionContext.viewController(forKey: .from) as? PushPopAnimatableViewController,
            let toVC = transitionContext.viewController(forKey: .to) as? PushPopAnimatableViewController,
            let targetView = fromVC.animationTargetView?.ext.asImageView(),
            let targetPositionFrom = fromVC.animationTargetFrame
            else
        {
            return
        }
        let containerView = transitionContext.containerView
        containerView.addSubview(toView)

        containerView.addSubview(targetView)
        targetView.frame = targetPositionFrom

        let width = UIScreen.main.bounds.width
        let targetPositionTo = CGRect(
            x: 0,
            y: toVC.navigationController?.navigationBar.frame.maxY ?? 0,
            width: width,
            height: width * 0.75)

        toView.alpha = 0
        toVC.animationTargetView?.isHidden = true
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            delay: 0,
            options: [.curveEaseInOut],
            animations: {
                toView.alpha = 1
                targetView.frame = targetPositionTo
        }, completion: { _ in
            toVC.animationTargetView?.isHidden = false
            targetView.removeFromSuperview()
            transitionContext.completeTransition(
                !transitionContext.transitionWasCancelled)
        })
    }
}
