//
//  MessageModel.swift
//  Therapist
//
//  Created by Astghik Hakopian on 5/2/20.
//  Copyright © 2020 Astghik Hakopian. All rights reserved.
//

enum Writer {
    case system
    case user
}

struct MessageModel {
    let username:   String
    let message:    String
    let writer:     Writer
}
