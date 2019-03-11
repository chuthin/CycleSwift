//
//  Initializable.swift
//  VirtualViews
//
//  Created by chuthin on 3/1/19.
//  Copyright © 2019 chuthin. All rights reserved.
//

import Foundation
public protocol Initializable  {
    init()
}
extension Initializable  {
    public static var empty:Self {
        return Self()
    }
}
