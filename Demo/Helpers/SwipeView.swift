//
//  SwipeView.swift
//  Demo
//
//  Created by TOxIC on 10/04/2021.
//

import Foundation
import UIKit

class SwipeView: UIView {
    
    
    var originalPoint: CGPoint!
    var maxSwipe: CGFloat! = 100 {
        didSet(newValue) {
            maxSwipe = newValue
        }
    }
    
    @IBInspectable var swipeBufffer: CGFloat = 2.0
    @IBInspectable var highVelocity: CGFloat = 300.0
    
    private let originalXCenter: CGFloat = UIScreen.main.bounds.width / 2
    private var panGesture: UIPanGestureRecognizer!
    
    public var isPanGestureEnabled: Bool {
        get { return panGesture.isEnabled }
        set(newValue) {
            panGesture.isEnabled = newValue
        }
    }
    
    
    func setupGesture() {
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(swipe(_:)))
        panGesture.delegate = self
        addGestureRecognizer(panGesture)
    }
    
    @objc func swipe(_ sender:UIPanGestureRecognizer) {
        let translation = sender.translation(in: self)
        let newXPosition = center.x + translation.x
        let velocity = sender.velocity(in: self)
        
        switch(sender.state) {
        
        case .changed:
            let shouldSwipeRight = translation.x > 0 && newXPosition < originalXCenter
            let shouldSwipeLeft = translation.x < 0 && newXPosition > originalXCenter - maxSwipe
            guard shouldSwipeRight || shouldSwipeLeft else { break }
            center.x = newXPosition
        case .ended:
            if -velocity.x > highVelocity {
                center.x = originalXCenter - maxSwipe
                break
            }
            guard center.x > originalXCenter - maxSwipe - swipeBufffer, center.x < originalXCenter - maxSwipe + swipeBufffer, velocity.x < highVelocity  else {
                center.x = originalXCenter
                break
            }
        default:
            break
        }
        panGesture.setTranslation(.zero, in: self)
    }
    
}

extension SwipeView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
