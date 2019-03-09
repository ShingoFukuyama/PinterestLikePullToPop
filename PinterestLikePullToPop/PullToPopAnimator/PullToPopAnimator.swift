//
//  PullToPopAnimator.swift
//  PinterestLikePullToPop
//
//  Created by Shingo Fukuyama
//

import UIKit

/// ## UIGestureRecognizerDelegate:
/// Requires one method
/// ```
/// gestureRecognizer(_:shouldRecognizeSimultaneouslyWith:)
/// ```
/// And make the function to return true value
/// to work this class's pan gesture and target scrollView's
/// pan gesture simultaniously
///
/// ## PushPopAnimator
///
/// ## PullToPopAnimatable
///
typealias PullToPoppableScrollViewController
    = UIViewController
    & UIGestureRecognizerDelegate
    & PushPopAnimatable
    & PullToPopAnimatable

class PullToPopAnimator {
    var isInteracting: Bool = false

    /// View for interacting target image.
    fileprivate var interactionImageView: UIImageView?

    fileprivate var window: UIWindow? {
        return delegate?.view.window
    }

    fileprivate weak var scrollView: UIScrollView?

    fileprivate weak var targetView: UIView?

    fileprivate var delegate: PullToPoppableScrollViewController?

    fileprivate let destinationFrame: CGRect

    fileprivate var navigationController: UINavigationController? {
        return delegate?.navigationController
    }

    /// View for presenting previous view while interacting.
    fileprivate let previousScreenView: UIView

    /// View for haze previousScreenView.
    fileprivate var interactionHazeView: UIView?

    /// View for interactive fade animation.
    fileprivate var interactionBackgroundView: UIView?

    /// View for positioning `interactiveImageView`.
    fileprivate var interactionImageBaseView: UIView?

    /// Keep value of contentOffset.y when interaction gesture began.
    /// It is for preventing non-continuous animation.
    fileprivate var interactionBeginningOffsetY: CGFloat = 0

    /// Keep gesture value of `translation.x` when interaction started.
    /// It is for preventing non-continuous animation.
    fileprivate var interactionBeginningTranslationX: CGFloat = 0

    /// Designated initializer
    ///
    /// - Parameters:
    ///   - targetView: A view for moving around with your finger.
    ///   - scrollView: UIScrollView or a subclass of UIScrollView.
    ///   - destinationFrame: A frame in which the targetView fits.
    ///   - previousScreenView: A snapshot of the previous screen.
    ///   - delegate: UIViewController conformes to PullToPoppableScrollViewController.
    init(
        targetView: UIView,
        scrollView: UIScrollView,
        destinationFrame: CGRect,
        previousScreenView: UIView,
        delegate: PullToPoppableScrollViewController) {
        self.targetView = targetView
        self.scrollView = scrollView
        self.destinationFrame = destinationFrame
        self.previousScreenView = previousScreenView
        self.delegate = delegate

        let panGestureRecognizer = UIPanGestureRecognizer(
            target: self,
            action: #selector(didPan(gesture:)))
        panGestureRecognizer.delegate = delegate as? UIGestureRecognizerDelegate
        scrollView.addGestureRecognizer(panGestureRecognizer)
    }
}

extension PullToPopAnimator {
    @objc fileprivate func didPan(gesture: UIPanGestureRecognizer) {
        guard let scrollView = gesture.view as? UIScrollView else {
            return
        }
        switch gesture.state {
        case .began:
            startInteraction(scrollView: scrollView)
        case .changed:
            changeInteraction(
                scrollView: scrollView,
                velocity: gesture.velocity(in: nil),
                translation: gesture.translation(in: nil))
        case .ended:
            guard isInteracting else {
                return
            }
            let velocity = gesture.velocity(in: nil)
            let translation = gesture.translation(in: nil)
            let offsetY = interactionBeginningOffsetY - translation.y
            let gapY = -scrollView.ext.calculatedInsetTop - offsetY
            if gapY > (scrollView.frame.height / 3.0)
                || velocity.y > 50 {
                finishInteraction(scrollView: scrollView, velocity: velocity)
            } else {
                cancelInteraction(scrollView: scrollView)
            }
        case .failed, .cancelled:
            cancelInteraction(scrollView: scrollView)
        case .possible:
            break
        }
    }

    private func startInteraction(scrollView: UIScrollView) {
        interactionBeginningOffsetY = scrollView.contentOffset.y
    }

    private func changeInteraction(
        scrollView: UIScrollView,
        velocity: CGPoint,
        translation: CGPoint) {
        guard let window = window,
            let targetView = targetView else {
                return
        }
        let offsetY = interactionBeginningOffsetY - translation.y
        let gapY = -scrollView.ext.calculatedInsetTop - offsetY

        if gapY > 0 {
            // Below the threshold
            if !isInteracting,
                velocity.y > 0 {
                // Start interaction
                isInteracting = true
                interactionBeginningTranslationX = translation.x
                // Snapshot with modifieng scroll view.
                scrollView.ext.resetScrollPosition()
                let backgroundView = window.ext.asImageView()
                // Create a base of target image.
                let imageBaseView = UIView(frame: backgroundView.bounds)
                imageBaseView.backgroundColor = .clear
                // Copy and display target image.
                let imageView = targetView.ext.asImageView()
                // Create haze
                let hazeView = UIView(frame: window.bounds)
                hazeView.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
                window.ext.addSubviews(
                    previousScreenView,
                    hazeView,
                    backgroundView,
                    imageBaseView)
                imageBaseView.addSubview(imageView)
                imageView.frame = targetView.ext.absoluteFrame
                // Adjust current views
                delegate?.view.isHidden = true
                //navigationItem.title = previousViewController?.navigationItem.title ?? ""
                delegate?.navigationItem.hidesBackButton = true
                interactionBackgroundView = backgroundView
                interactionImageBaseView = imageBaseView
                interactionImageView = imageView
                interactionHazeView = hazeView
                self.delegate?.interactionDidBegin()
            }
            if isInteracting {
                // Value changed.
                let translationX = translation.x - interactionBeginningTranslationX
                let percent: CGFloat = gapY / scrollView.frame.height
                let scale: CGFloat = 1.0 - percent
                let transform = CGAffineTransform(scaleX: scale, y: scale)
                    .concatenating(.init(translationX: translationX, y: gapY))

                let backTransform = CGAffineTransform(translationX: -translationX / 24, y: -gapY / 24).concatenating(.init(scaleX: 1.0 + percent/20, y: 1.0 + percent/20))

                UIView.animate(withDuration: 0.1, animations: {
                    self.interactionHazeView?.alpha = 1.0 - percent * 2.0
                    self.interactionBackgroundView?.alpha = 1.0 - percent * 8.0
                    self.interactionBackgroundView?.transform = transform
                    self.interactionImageBaseView?.transform = transform

                    self.previousScreenView.transform = backTransform
                    self.delegate?.interactionDidChange(percent: percent)
                }, completion: { _ in

                })
            }
        } else {
            // Above or same as the threshold.
            if isInteracting {
                // Only translation x is effective.
                let translationX = translation.x - interactionBeginningTranslationX
                let transform = CGAffineTransform(scaleX: 1, y: 1)
                    .concatenating(.init(translationX: translationX, y: 0))
                interactionBackgroundView?.transform = transform
                interactionImageBaseView?.transform = transform
            }
        }
    }

    private func finishInteraction(scrollView: UIScrollView, velocity: CGPoint) {
        guard let window = window,
            let imageView = interactionImageView else {
                return
        }
        let duration: TimeInterval = 0.4
        let velocityFactor = CGFloat(duration / 2) // Half of duration
        // Move onto window from its base view.
        let targetImageFrame = imageView.ext.absoluteFrame
        window.addSubview(imageView)
        imageView.frame = targetImageFrame

        let hideBackgroundDuration: TimeInterval = duration
        UIView.animate(
            withDuration: hideBackgroundDuration,
            delay: 0,
            options: [.curveEaseOut],
            animations: {
                self.interactionBackgroundView?.alpha = 0
                self.interactionHazeView?.alpha = 0
                self.previousScreenView.transform = .identity
        }, completion: { _ in
            self.removeInteractionViews()
        })

        let currentPoint = imageView.center
        let inertiaPoint: CGPoint = CGPoint(
            x: imageView.center.x + velocity.x * velocityFactor,
            y: imageView.center.y + velocity.y * velocityFactor)
        let destination: CGRect = destinationFrame

        // Utilize `velocity` to simulate animation with inertia.
        let animationGroup = CAAnimationGroup()
        let curve = CAAnimation.ext.curve(
            from: currentPoint,
            to: destination.ext.center,
            controlPoint: inertiaPoint)
        let scale = CAAnimation.ext.scale(
            to: destination.width / imageView.frame.width)
        animationGroup.animations = [curve, scale]
        animationGroup.duration = duration
        animationGroup.timingFunction = CAMediaTimingFunction(name: .easeOut)
        animationGroup.fillMode = .forwards
        animationGroup.isRemovedOnCompletion = false
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            scrollView.ext.resetScrollPosition()
            self.previousScreenView.removeFromSuperview()
            self.interactionImageView?.removeFromSuperview()
            self.interactionImageView = nil
            self.delegate?.navigationItem.title = ""
            // Switch pop transitioning
            AnimatableNavigationState.isPullToPopInteraction = true
            self.navigationController?.popViewController(animated: true)
            self.isInteracting = false
            self.delegate?.interactionDidFinish()
        }
        imageView.layer.add(animationGroup, forKey: "pull_to_popping")
        CATransaction.commit()
    }

    private func cancelInteraction(scrollView: UIScrollView) {
        guard let backgroundView = interactionBackgroundView,
            let imageBaseView = interactionImageBaseView else {
                return
        }
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            options: .curveEaseOut,
            animations: {
                backgroundView.alpha = 1.0
                backgroundView.transform = .identity
                imageBaseView.transform = .identity
                self.previousScreenView.transform = .identity
            }, completion: { [weak self] _ in
                guard let self = self else { return }
                self.delegate?.navigationItem.hidesBackButton = false
                self.removeInteractionViews()
                scrollView.ext.resetScrollPosition()
                self.delegate?.view.isHidden = false
                self.previousScreenView.removeFromSuperview()
                self.isInteracting = false
                self.delegate?.interactionDidCancel()
        })
    }

    private func removeInteractionViews() {
        interactionHazeView?.removeFromSuperview()
        interactionHazeView = nil
        interactionBackgroundView?.removeFromSuperview()
        interactionBackgroundView = nil
        interactionImageBaseView?.removeFromSuperview()
        interactionImageBaseView = nil
    }

}

private extension Extension where T: UIScrollView {
    var calculatedInsetTop: CGFloat {
        return base.contentInset.top + base.safeAreaInsets.top
    }

    func resetScrollPosition() {
        let defaultPosition = CGPoint(x: 0, y: -calculatedInsetTop)
        base.setContentOffset(defaultPosition, animated: false)
    }
}
