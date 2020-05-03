//
//  CommonView.swift
//  Therapist
//
//  Created by Astghik Hakopian on 5/2/20.
//  Copyright © 2020 Astghik Hakopian. All rights reserved.
//


import UIKit

class CommonView: UIView {
    
    // MARK: - @IBInspectable
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            updateCornerRadius()
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            updateBorder()
        }
    }
    
    @IBInspectable var borderColor: UIColor = .clear {
        didSet {
            updateBorder()
        }
    }
    
    
    // MARK: - Private Methods
    
    private func updateCornerRadius() {
        layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
    }
    
    private func updateBorder() {
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderWidth
    }
}

