//
//  UIView+Extension.swift
//  PinterestLikePullToPop
//
//  Created by Shingo Fukuyama
//

import UIKit

extension Extension where T: UIView {
    /// Description
    var absoluteFrame: CGRect {
        guard let superview = base.superview else {
            return base.bounds
        }
        return superview.convert(base.frame, to: nil)
    }

    /// Add subviews at once
    /// e.g. view.addSubviews(viewA, viewB, viewC, viewD)
    /// - Parameter subviews: subviews to be added.
    func addSubviews(_ subviews: UIView...) {
        subviews.forEach(base.addSubview)
    }

    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: base.bounds)
        return renderer.image { rendererContext in
            base.layer.render(in: rendererContext.cgContext)
        }
    }

    func asImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = self.asImage()
        imageView.frame = base.frame
        return imageView
    }

    func addEdgeConstraints(
        top: CGFloat = 0,
        left: CGFloat = 0,
        bottom: CGFloat = 0,
        right: CGFloat = 0)
    {
        guard let superview = base.superview else {
            return
        }
        base.translatesAutoresizingMaskIntoConstraints = false
        [NSLayoutConstraint]([
            base.topAnchor.constraint(equalTo: superview.topAnchor, constant: top),
            base.leftAnchor.constraint(equalTo: superview.leftAnchor, constant: left),
            base.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: bottom),
            base.rightAnchor.constraint(equalTo: superview.rightAnchor, constant: right)
            ]).forEach { $0.isActive = true }
    }

    func animateWithCurve(
        duration: TimeInterval,
        timing: CAMediaTimingFunctionName,
        from startPoint: CGPoint,
        to endPoint: CGPoint,
        controlPoint: CGPoint,
        completion: (() -> Void)?) {

        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.duration = duration
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        animation.timingFunction = CAMediaTimingFunction(name: timing)

        let path = CGMutablePath()
        path.move(to: startPoint)
        path.addQuadCurve(to: endPoint, control: controlPoint)
        animation.path = path

        CATransaction.begin()
        CATransaction.setCompletionBlock {
            completion?()
        }
        base.layer.add(animation, forKey: "curve_animation")
        CATransaction.commit()
    }
}
