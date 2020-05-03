//
//  CommonButton.swift
//  Therapist
//
//  Created by Astghik Hakopian on 5/1/20.
//  Copyright © 2020 Astghik Hakopian. All rights reserved.
//

import UIKit

class CommonButton: UIButton {
    
    // MARK: - @IBInspectable
    
    @IBInspectable var cornerRadius: CGFloat = 20 {
        didSet {
            setRouned()
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 1 {
        didSet {
            updateBorder()
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.black {
        didSet {
            updateBorder()
        }
    }
    
    @IBInspectable var isRounded: Bool = false {
        didSet {
            if isRounded {
                roundButton()
            }
        }
    }
    
    
    // MARK: - Private Methods
    
    func setRouned() {
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
    }
    
    private func updateBorder() {
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderWidth
    }
    
    private func roundButton() {
        layer.cornerRadius = frame.height / 2
    }
}
