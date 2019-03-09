//
//  VisibleGestureWindow.swift
//  PinterestLikePullToPop
//
//  Created by Shingo Fukuyama
//

import UIKit

class VisibleGestureWindow: UIWindow {
    private let touchView: UIWindow = {
        let diameter: CGFloat = 60
        let view = UIWindow(frame: CGRect(
            x: 0,
            y: 0,
            width: diameter,
            height: diameter))
        view.layer.cornerRadius = diameter * 0.5
        view.backgroundColor = #colorLiteral(red: 0, green: 0.1270900369, blue: 0.8537346125, alpha: 0.5)
        view.isHidden = true
        view.isUserInteractionEnabled = false
        return view
    }()

    override func addSubview(_ view: UIView) {
        super.addSubview(view)
        // keep top level
        super.addSubview(touchView)
    }

    override func sendEvent(_ event: UIEvent) {
        if let touches = event.allTouches {
            for touch in touches {
                let center = touch.location(in: nil)
                switch touch.phase {
                case .began:
                    addSubview(touchView)
                    touchView.isHidden = false
                    touchView.center = center
                case .moved:
                    touchView.center = center
                case .ended, .cancelled:
                    touchView.center = center
                    touchView.isHidden = true
                    touchView.removeFromSuperview()
                case .stationary:
                    break
                }
            }
        }
        super.sendEvent(event)
    }
}
