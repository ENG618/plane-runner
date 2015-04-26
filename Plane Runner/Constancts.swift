//
//  Constancts.swift
//  Plane Runner
//
//  Created by Eric Garcia on 4/26/15.
//  Copyright (c) 2015 Garcia Enterprise. All rights reserved.
//

import UIKit

struct ZLevel {
    static let Background   : CGFloat = -2.0
    static let Clouds       : CGFloat = -1.0
    static let Rocks        : CGFloat = 1.0
    static let Ground       : CGFloat = 0.0
    static let Plane        : CGFloat = 5.0
    static let HUD          : CGFloat = 10.0
}

struct PhysicsCategory {
    static let All          :UInt32 = UInt32.max
    static let Plane        :UInt32 = 0x1
    static let Collidable   :UInt32 = 0x1 << 1
    static let Boundary     :UInt32 = 0x1 << 2
    static let Ground       :UInt32 = 0x1 << 3
    static let ButtonEnabled:UInt32 = 0x1 << 4
    static let Distance     :UInt32 = 0x1 << 5
}
