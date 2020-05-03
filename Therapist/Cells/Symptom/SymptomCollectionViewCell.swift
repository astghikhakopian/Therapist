//
//  FilterCollectionViewCell.swift
//  PartsPlug
//
//  Created by Astghik Hakopian on 3/13/20.
//  Copyright © 2020 Astghik Hakopian. All rights reserved.
//

import UIKit

protocol SymptomCollectionViewCellDelegate {
    func removeButtonTouchUp(cell: SymptomCollectionViewCell)
}

class SymptomCollectionViewCell: UICollectionViewCell {
    
    static let id = "SymptomCollectionViewCell"
    
    // MARK: - Outlets
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
    // MARK: - Public Properties
    
    var delegate: SymptomCollectionViewCellDelegate?
    
    
    // MARK: - Actions
    
    @IBAction func removeButtonTouchUp() {
        delegate?.removeButtonTouchUp(cell: self)
    }
}
