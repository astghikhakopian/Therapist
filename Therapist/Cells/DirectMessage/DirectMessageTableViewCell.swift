//
//  DirectMessageTableViewCell.swift
//  PartsPlug
//
//  Created by Astghik Hakopian on 1/15/20.
//  Copyright © 2020 Astghik Hakopian. All rights reserved.
//

import UIKit

class DirectMessageTableViewCell: UITableViewCell {
    
    static let outgoingId = "OutgoingMessageTableViewCell"
    static let incomingId = "IncomingMessageTableViewCell"
    
    // MARK: - Outlets
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
}
