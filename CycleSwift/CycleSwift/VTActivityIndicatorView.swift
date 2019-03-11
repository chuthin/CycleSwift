//
//  VTActivityIndicatorView.swift
//  VirtualViews
//
//  Created by chuthin on 3/1/19.
//  Copyright © 2019 chuthin. All rights reserved.
//

import Foundation
import UIKit

public struct VTActivityIndicatorView : VirtualView {
    public let id :String
    public let style:String
    public let isHidden:Bool
    public let isAnimating: Bool
    public let isReactive: Bool
    
    public init(id:String,style:String = "activityIndicatorView",isAnimating:Bool =  true,isReactive:Bool = false,isHidden:Bool = false ){
        self.id = id
        self.style = style
        self.isHidden = isHidden
        self.isAnimating = isAnimating
        self.isReactive = isReactive
    }
    
    public func render(into result:UIActivityIndicatorView){
        result.tag = self.id.hash
        result.style = self.style
        result.isHidden = self.isHidden
        self.isAnimating == true ? result.startAnimating() : result.stopAnimating()
        result.reactiveKey = self.isReactive ? self.id : nil
    }
    
    public func render() -> UIView {
        let result = UIActivityIndicatorView(frame: .zero )
        result.translatesAutoresizingMaskIntoConstraints = false
        render(into: result)
        return result
    }
    
    public func update(into existing: UIView) -> UIView {
        guard let result = existing as? UIActivityIndicatorView else {
            return render()
        }
        self.render(into: result)
        return result
    }
}

