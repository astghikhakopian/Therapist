//
//  KeyboardConstraintDelegate.swift
//  Therapist
//
//  Created by Astghik Hakopian on 5/2/20.
//  Copyright © 2020 Astghik Hakopian. All rights reserved.
//

import Foundation
import UIKit

protocol KeyboardMovingDelegate {
    var changingConstraint: NSLayoutConstraint? { get set }
    
    func keyboardNotificationHandlingAction(notification: NSNotification)
    func forceHideKeyboard()
    
    func addKeyboardNotificationObserver()
}

extension KeyboardMovingDelegate where Self: UIViewController {
    
    func keyboardNotificationHandlingAction(notification: NSNotification) {
        if let userInfo = notification.userInfo, let changingConstraint = changingConstraint {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let endFrameY = endFrame?.origin.y ?? 0
            let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            if endFrameY >= UIScreen.main.bounds.size.height {
                changingConstraint.constant = 0
                
            } else {
                if var height = endFrame?.size.height {
                    if #available(iOS 11.0, *) {
                        height -= view.safeAreaInsets.bottom
                    }
                    changingConstraint.constant = height
                } else {
                    changingConstraint.constant = 0
                }
            }
            UIView.animate(withDuration: duration, delay: TimeInterval(0), options: animationCurve, animations: {
                self.view.layoutIfNeeded() }, completion: nil)
        } else {
            changingConstraint?.constant = 0
        }
    }
    
    func forceHideKeyboard() {
        changingConstraint?.constant = 0
    }
    
    func addKeyboardNotificationObserver() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillChangeFrameNotification, object: nil, queue: nil) { [weak self] (notification) in
            self?.keyboardNotificationHandlingAction(notification: notification as NSNotification)
        }
    }
}

