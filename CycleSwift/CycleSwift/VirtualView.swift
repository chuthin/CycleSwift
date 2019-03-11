//
//  VirtualView.swift
//  VirtualViews
//
//  Created by chuthin on 2/28/19.
//  Copyright © 2019 chuthin. All rights reserved.
//

import Foundation
import UIKit
import Stylist
public typealias UIViewContentMode = UIView.ContentMode

public protocol VirtualView {
    var id:String {get}
    var style:String {get}
    var isHidden:Bool {get}
    var isReactive:Bool{get}
    func update(into existing: UIView) -> UIView
    func render() -> UIView
}

extension Optional where Wrapped == String {
    public var isEmpty: Bool {
        return map { $0.isEmpty } ?? true
    }
    
    public var isNotEmpty: Bool {
        return !isEmpty
    }
}

public extension UIView {
    public func findById(_ id:String) -> UIView? {
        return self.viewWithTag(id.hash)
    }
}

public extension UIView {
    private static let REACTIVE_KEY = "VirtualView.ReactiveActionKey"
    public var reactiveKey: String? {
        get {
            return getAssociatedValue(key: UIView.REACTIVE_KEY,
                                      object: self,
                                      initialValue: nil)
        }
        set {
            set(associatedValue: newValue, key: UIView.REACTIVE_KEY, object: self)
        }
    }
    
}
