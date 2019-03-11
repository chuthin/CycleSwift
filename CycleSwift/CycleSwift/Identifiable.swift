//
//  Identifiable.swift
//  VirtualViews
//
//  Created by chuthin on 3/1/19.
//  Copyright © 2019 chuthin. All rights reserved.
//

import Foundation
public protocol Identifiable{
    var identifier: String {get set}
}


extension Identifiable {
    public func withIdentifier(_ identifier:String) -> Self {
        var value = self
        value.identifier = identifier
        return value
    }
}
