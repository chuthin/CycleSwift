//
//  VTSlider.swift
//  VirtualViews
//
//  Created by chuthin on 3/1/19.
//  Copyright © 2019 chuthin. All rights reserved.
//

import Foundation
import UIKit

public struct VTSlider : VirtualView {
    public let id :String
    public let style:String
    public let isEnable:Bool
    public let isHidden:Bool
    public let maximumValue:Float
    public let minimumValue:Float
    public let value:Float
    public let isReactive: Bool
    
    public init(id:String,style:String = "slider",value:Float = 1.0, minimumValue:Float = 0.0,maximumValue:Float = 1.0,isReactive:Bool = true ,isEnable:Bool = true,isHidden:Bool = false ){
        self.id = id
        self.style = style
        self.isHidden = isHidden
        self.isEnable = isEnable
        self.minimumValue = minimumValue
        self.maximumValue = maximumValue
        self.value = value
        self.isReactive = isReactive
    }
    
    public func render(into result:UISlider){
        result.tag = self.id.hash
        result.style = self.style
        result.isHidden = self.isHidden
        result.isEnabled = self.isEnable
        result.maximumValue = self.maximumValue
        result.minimumValue = self.minimumValue
        result.value = self.value
        result.reactiveKey = self.isReactive ? self.id : nil
    }
    
    public func render() -> UIView {
        let result = UISlider(frame: .zero )
        result.translatesAutoresizingMaskIntoConstraints = false
        render(into: result)
        return result
    }
    
    public func update(into existing: UIView) -> UIView {
        guard let result = existing as? UISlider else {
            return render()
        }
        self.render(into: result)
        return result
    }
    
}
