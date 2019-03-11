//
//  VTStackView.swift
//  VirtualViews
//
//  Created by chuthin on 3/1/19.
//  Copyright © 2019 chuthin. All rights reserved.
//

import Foundation
import UIKit

public struct VTStackView:VirtualView {
    public let id :String
    public let style: String
    public let isHidden:Bool
    public let subviews:[VirtualView]
    public let axis: NSLayoutConstraint.Axis
    public let isReactive: Bool
    
    public init(id:String,style:String = "stackView",axis: NSLayoutConstraint.Axis = NSLayoutConstraint.Axis.vertical,subviews:[VirtualView]=[],isReactive:Bool = false,isHidden:Bool = false ){
        self.id = id
        self.style = style
        self.subviews = subviews
        self.axis = axis
        self.isHidden = isHidden
        self.isReactive = isReactive
    }
    
    public func render(into result:UIStackView){
        result.tag = self.id.hash
        result.style = self.style
        result.axis = self.axis
        result.isHidden = self.isHidden
        result.reactiveKey = self.isReactive ? self.id : nil
    }
    
    public func update(into existing: UIView) -> UIView {
        guard let result = existing as? UIStackView, result.arrangedSubviews.count == self.subviews.count else {
            return render()
        }
        
        for (index, existingSubview) in result.arrangedSubviews.enumerated() {
            let sub = self.subviews[index]
            let new = sub.update(into: existingSubview)
            if new !== existingSubview {
                result.removeArrangedSubview(existingSubview)
                result.insertArrangedSubview(new, at: Int(index))
            }
        }
        render(into: result)
        return result
    }
    
    public func render() -> UIView {
        let views = self.subviews.map { $0.render() }
        let result = UIStackView(arrangedSubviews: views)
        return result
    }
    
}
