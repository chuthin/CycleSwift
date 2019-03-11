//
//  VTView.swift
//  VirtualViews
//
//  Created by chuthin on 3/1/19.
//  Copyright © 2019 chuthin. All rights reserved.
//

import Foundation
import UIKit

public struct VTView: VirtualView {
    public let id :String
    public let style: String
    public let isHidden:Bool
    public let subviews:[VirtualView]
    public let constraints:[String:String]
    public let formatOptions:[String:String]
    public let metrics: [String: Float]
    public let isReactive: Bool
    
    public static var empty:VTView {
        return VTView(id: "")
    }
    
    public init(id:String,style:String = "view",subviews:[VirtualView]=[],constraints:[String:String] = [:],formatOptions:[String:String]=[:], metrics: [String: Float] = [:],isReactive:Bool = false,isHidden:Bool = false ){
        self.id = id
        self.style = style
        self.subviews = subviews
        self.constraints = constraints
        self.formatOptions = formatOptions
        self.metrics = metrics
        self.isHidden = isHidden
        self.isReactive = isReactive
    }
    
    public func render(into result:UIView){
        result.tag = self.id.hash
        result.style = self.style
        result.isHidden = self.isHidden
        result.reactiveKey = self.isReactive ? self.id : nil
        
    }
    
    public func update(into existing: UIView) -> UIView {
        let result = existing
        if result.subviews.count != self.subviews.count  {
            return render()
        }
        
        for (index, existingSubview) in result.subviews.enumerated() {
            let sub = self.subviews[index]
            let new = sub.update(into: existingSubview)
            if new !== existingSubview {
                existingSubview.removeFromSuperview()
                result.insertSubview(new, at: Int(index))
            }
        }
        render(into: result)
        return result
    }
    
    public func updateRoot(into existing: UIView) -> UIView {
        let result = existing
        if result.subviews.count != self.subviews.count  {
            return renderRoot()
        }
        
        for (index, existingSubview) in result.subviews.enumerated() {
            let sub = self.subviews[index]
            let new = sub.update(into: existingSubview)
            if new !== existingSubview {
                existingSubview.removeFromSuperview()
                result.insertSubview(new, at: Int(index))
            }
        }
        render(into: result)
        return result
    }
    
    public func renderRoot() -> UIView {
        let views = self.subviews.map { (key:$0.id,view:$0.render())  }
        var viewsConstraint:[String: UIView] = [:]
        for v in views {
            viewsConstraint[v.key] = v.view
        }
        let result = UIView()
        //result.translatesAutoresizingMaskIntoConstraints = false
        viewsConstraint[self.id] = result
        for view in views {
            view.view.translatesAutoresizingMaskIntoConstraints = false
            result.addSubview(view.view)
        }
        
        render(into: result)
        var constraints = [NSLayoutConstraint]()
        for constraint in self.constraints {
            if let foKeys = self.formatOptions[constraint.key],let id = UIView.formatOptions[foKeys]
            {
                let options = NSLayoutConstraint.FormatOptions(rawValue: id)
                print(formatOptions)
                constraints += NSLayoutConstraint.constraints(withVisualFormat: constraint.value, options: options, metrics: self.metrics, views: viewsConstraint)
            }
            else
            {
                constraints += NSLayoutConstraint.constraints(withVisualFormat: constraint.value, metrics: self.metrics, views: viewsConstraint)
            }
        }
        result.addConstraints(constraints)
        return result
    }
    
    public func render() -> UIView {
        let views = self.subviews.map { (key:$0.id,view:$0.render())  }
        var viewsConstraint:[String: UIView] = [:]
        for v in views {
            viewsConstraint[v.key] = v.view
        }
        let result = UIView()
        result.translatesAutoresizingMaskIntoConstraints = false
        viewsConstraint[self.id] = result
        for view in views {
            view.view.translatesAutoresizingMaskIntoConstraints = false
            result.addSubview(view.view)
        }
        
        render(into: result)
        var constraints = [NSLayoutConstraint]()
        for constraint in self.constraints {
            if let foKeys = self.formatOptions[constraint.key],let id = UIView.formatOptions[foKeys]
            {
                let options = NSLayoutConstraint.FormatOptions(rawValue: id)
                print(formatOptions)
                constraints += NSLayoutConstraint.constraints(withVisualFormat: constraint.value, options: options, metrics: self.metrics, views: viewsConstraint)
            }
            else
            {
                constraints += NSLayoutConstraint.constraints(withVisualFormat: constraint.value, metrics: self.metrics, views: viewsConstraint)
            }
        }
        result.addConstraints(constraints)
        return result
    }
    
    public func applyContraints(_ view:UIView){
        if(self.subviews.count == view.subviews.count)
        {
            var constraints = [NSLayoutConstraint]()
            var viewsConstraint:[String: UIView] = [:]
            for i in 0...self.subviews.count - 1 {
                viewsConstraint[self.subviews[i].id] = view.subviews[i]
            }
            for constraint in self.constraints {
                if let foKeys = self.formatOptions[constraint.key],let id = UIView.formatOptions[foKeys]
                {
                    let options = NSLayoutConstraint.FormatOptions(rawValue: id)
                    constraints += NSLayoutConstraint.constraints(withVisualFormat: constraint.value, options: options, metrics: self.metrics, views: viewsConstraint)
                }
                else
                {
                    constraints += NSLayoutConstraint.constraints(withVisualFormat: constraint.value, metrics: self.metrics, views: viewsConstraint)
                }
            }
            view.addConstraints(constraints)
        }
    }
}

extension UIViewController {
    public func renderRootView(_ vtView:VTView) -> [String:Any] {
        let newView = vtView.updateRoot(into: self.view)
        if newView !== self.view {
            self.view = newView
            return getReactive(newView)
        }
        return [:]
    }
    
    public func getReactive(_ view:UIView) ->  [String:Any]{
        var reactives:[String:Any] = [:]
        if let reactiveKey = view.reactiveKey {
            if view is UIButton {
                 reactives[reactiveKey] = (view as! UIButton).rx
            }
            else if view is UITextField {
                reactives[reactiveKey] = (view as! UITextField).rx
            }
            else if view is UITableView {
                reactives[reactiveKey] = (view as! UITableView).rx
            }
            else if view is UICollectionView {
                reactives[reactiveKey] = (view as! UICollectionView).rx
            }
            else if view is UISwitch {
                reactives[reactiveKey] = (view as! UISwitch).rx
            }
            else if view is UISlider {
                reactives[reactiveKey] = (view as! UISlider).rx
            }
            else
            {
                reactives[reactiveKey] = view.rx
            }
            
        }
        
        for subView in view.subviews {
            let subReactives = getReactive(subView)
            for subRecative in subReactives {
                reactives[subRecative.key] = subRecative.value
            }
        }
        
        return reactives
    }
}

extension UIView {
    public static  let formatOptions:[String:UInt] = [
        "alignAllBottom":NSLayoutConstraint.FormatOptions.alignAllBottom.rawValue,
        "alignAllCenterY":NSLayoutConstraint.FormatOptions.alignAllCenterY.rawValue,
        "alignAllCenterX":NSLayoutConstraint.FormatOptions.alignAllCenterX.rawValue
    ]
    
    public func select(by id:String) -> UIView?{
        return self.subviews.filter{ $0.tag == id.hash}.first
    }
    
    public func pushSubview(_ view: UIView){
        if let stackView = self as? UIStackView {
            stackView.addArrangedSubview(view)
        }
        else {
            self.addSubview(view)
        }
    }
}
