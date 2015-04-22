//
//  File.swift
//  Plane Runner
//
//  Created by Eric Garcia on 4/20/15.
//  Copyright (c) 2015 Garcia Enterprise. All rights reserved.
//

import SpriteKit

struct PhysicsCategory {
    static let All          :UInt32 = UInt32.max
    static let Plane        :UInt32 = 0x1
    static let Collidable   :UInt32 = 0x1 << 1
    static let Boundary     :UInt32 = 0x1 << 2
    static let Ground       :UInt32 = 0x1 << 3
    static let ButtonEnabled:UInt32 = 0x1 << 4
}
