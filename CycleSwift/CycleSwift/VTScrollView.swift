//
//  VTScrollView.swift
//  VirtualViews
//
//  Created by chuthin on 3/1/19.
//  Copyright © 2019 chuthin. All rights reserved.
//

import Foundation
import UIKit

public struct VTScrollView:VirtualView {
    public let id :String
    public let style: String
    public let contentView:VTView
    public let isHidden:Bool
    public let isReactive: Bool
    
    public init(id:String,style:String = "scrollView",contentView:VTView,isReactive:Bool = false,isHidden:Bool = false ){
        self.id = id
        self.style = style
        self.contentView = contentView
        self.isHidden = isHidden
        self.isReactive = isReactive
    }
    
    public func render(into result:UIScrollView){
        result.tag = self.id.hash
        result.style = self.style
        result.isHidden = self.isHidden
        result.reactiveKey = self.isReactive ? self.id : nil
    }
    
    public func update(into existing: UIView) -> UIView {
        guard let result = existing as? UIScrollView, result.subviews.count == 1 else {
            return render()
        }
        
        let existingSubview = result.subviews.first!
        let new = self.contentView.update(into: existingSubview)
        if new !== existingSubview {
            existingSubview.removeFromSuperview()
            result.addSubview(new)
        }
        return result
    }
    
    public func render() -> UIView {
        let subview = self.contentView.render()
        let result = UIScrollView(frame: .zero)
        result.translatesAutoresizingMaskIntoConstraints = false
        result.addSubview(subview)
        var constraints = [NSLayoutConstraint]()
        var viewsConstraint:[String: UIView] = [:]
        viewsConstraint[self.id] = result
        viewsConstraint[self.contentView.id] = subview
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[\(self.contentView.id)(0@250)]|", metrics:[:], views: viewsConstraint)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[\(self.contentView.id)]|", metrics:[:], views: viewsConstraint)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:[\(self.contentView.id)(==\(self.id))]", metrics:[:], views: viewsConstraint)
        result.addConstraints(constraints)
        return result
    }
}
