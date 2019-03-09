//
//  PullToPopTransitioning.swift
//  PinterestLikePullToPop
//
//  Created by Shingo Fukuyama
//

import UIKit

/// Almost does no animation
/// but it still needs to pop a view controller
/// without any troubles
class PullToPopTransitioning: NSObject,
    UIViewControllerAnimatedTransitioning
{
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.1
    }

    func animateTransition(
        using transitionContext: UIViewControllerContextTransitioning) {
        generateAnimator(using: transitionContext)?.startAnimation()
    }

    private func generateAnimator(
        using context: UIViewControllerContextTransitioning)
        -> UIViewImplicitlyAnimating?
    {
        guard
            let fromView = context.view(forKey: .from),
            let toView = context.view(forKey: .to)
            else
        {
            return nil
        }
        let containerView = context.containerView
        containerView.insertSubview(toView, belowSubview: fromView)
        let duration = transitionDuration(using: context)
        let animator = UIViewPropertyAnimator(duration: duration, curve: .easeIn)
        animator.addAnimations { }
        animator.addCompletion { position in
            switch position {
            case .end: // transition completed
                context.completeTransition(!context.transitionWasCancelled)
            case .start, // transition canceled
            .current:
                break
            }
        }
        return animator
    }
}
