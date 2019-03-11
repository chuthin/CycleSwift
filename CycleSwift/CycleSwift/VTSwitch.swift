//
//  VTSwitch.swift
//  VirtualViews
//
//  Created by chuthin on 3/1/19.
//  Copyright © 2019 chuthin. All rights reserved.
//

import Foundation
import UIKit

public struct VTSwitch : VirtualView {
    public let id :String
    public let style:String
    public let isEnable:Bool
    public let isHidden:Bool
    public let isOn:Bool
    public let isReactive:Bool
    
    public init(id:String,style:String = "switch",isOn:Bool =  true,isReactive:Bool = true,isEnable:Bool = true,isHidden:Bool = false ){
        self.id = id
        self.style = style
        self.isHidden = isHidden
        self.isEnable = isEnable
        self.isOn = isOn
        self.isReactive = isReactive
    }
    
    public func render(into result:UISwitch){
        result.tag = self.id.hash
        result.style = self.style
        result.isHidden = self.isHidden
        result.isEnabled = self.isEnable
        result.isOn = self.isOn
        result.reactiveKey = self.isReactive ? self.id : nil
    }
    
    public func render() -> UIView {
        let result = UISwitch(frame: .zero )
        result.translatesAutoresizingMaskIntoConstraints = false
        render(into: result)
        return result
    }
    
    public func update(into existing: UIView) -> UIView {
        guard let result = existing as? UISwitch else {
            return render()
        }
        self.render(into: result)
        return result
    }
}
