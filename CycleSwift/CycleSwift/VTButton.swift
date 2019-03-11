//
//  VTButton.swift
//  VirtualViews
//
//  Created by chuthin on 3/1/19.
//  Copyright © 2019 chuthin. All rights reserved.
//

import Foundation
import UIKit

public struct VTButton : VirtualView {
    public let id :String
    public let style: String
    public let title:String
    public let isEnable:Bool
    public let isHidden:Bool
    public let isReactive: Bool
    
    public init(id:String,style:String = "button",title:String,isReactive:Bool = true,isEnable:Bool = true,isHidden:Bool = false ){
        self.id = id
        self.style = style
        self.title = title
        self.isHidden = isHidden
        self.isEnable = isEnable
        self.isReactive = isReactive
    }
    
    public func render(into result:UIButton){
        result.tag = self.id.hash
        result.style = self.style
        result.setTitle(self.title, for: .normal)
        result.isHidden = self.isHidden
        result.isEnabled = self.isEnable
        result.reactiveKey = self.isReactive ? self.id : nil
    }
    
    public func render() -> UIView {
        let result = UIButton(frame: .zero )
        result.translatesAutoresizingMaskIntoConstraints = false
        render(into: result)
        return result
    }
    
    public func update(into existing: UIView) -> UIView {
        guard let result = existing as? UIButton else {
            return render()
        }
        self.render(into: result)
        return result
    }
    
}
