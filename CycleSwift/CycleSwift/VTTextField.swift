//
//  VTTextField.swift
//  VirtualViews
//
//  Created by chuthin on 3/1/19.
//  Copyright © 2019 chuthin. All rights reserved.
//

import Foundation
import UIKit

public struct VTTextField:VirtualView {
    public let id :String
    public let style: String
    public let placeholder:String
    public let text:String
    public let isEnable:Bool
    public let isHidden:Bool
    public let borderStyle: UITextField.BorderStyle
    public let clearButtonMode: UITextField.ViewMode
    public let keyboardType:UIKeyboardType
    public let isReactive: Bool
    
    public init(id:String,style:String = "textfield",placeholder:String = "",text:String = "", borderStyle: UITextField.BorderStyle = .roundedRect,clearButtonMode:UITextField.ViewMode = .always,keyboardType:UIKeyboardType = .default,isReactive:Bool = true,isEnable:Bool = true,isHidden:Bool = false ){
        self.id = id
        self.style = style
        self.text = text
        self.borderStyle = borderStyle
        self.clearButtonMode = clearButtonMode
        self.keyboardType = keyboardType
        self.placeholder = placeholder
        self.isEnable = isEnable
        self.isHidden = isHidden
        self.isReactive = isReactive
    }
    
    public func render(into result:UITextField){
        result.tag = self.id.hash
        result.text = self.text
        result.style = self.style
        result.borderStyle = self.borderStyle
        result.clearButtonMode = self.clearButtonMode
        result.keyboardType = self.keyboardType
        result.placeholder = self.placeholder
        result.isEnabled = isEnable
        result.isHidden = isHidden
        result.reactiveKey = self.isReactive ? self.id : nil
    }
    
    public func render() -> UIView {
        let result = UITextField(frame: .zero )
        result.translatesAutoresizingMaskIntoConstraints = false
        render(into: result)
        return result
    }
    
    public func update(into existing: UIView) -> UIView {
        guard let result = existing as? UITextField else {
            return render()
        }
        self.render(into: result)
        return result
    }
}
