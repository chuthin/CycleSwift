//
//  VirtualView+VTLabel.swift
//  VirtualViews
//
//  Created by chuthin on 3/1/19.
//  Copyright © 2019 chuthin. All rights reserved.
//

import Foundation
import UIKit

public struct VTLabel : VirtualView {
    public let id :String
    public let style: String
    public let text:String
    public let isEnable:Bool
    public let isHidden:Bool
    public let numberOfLines:Int
    public let attributedText:NSAttributedString?
    public let isReactive: Bool
    
    public init(id:String,style:String = "label",text:String = "",isReactive:Bool = false,attributedText:NSAttributedString? = nil,numberOfLines:Int = 0,isEnable:Bool = true,isHidden:Bool = false ){
        self.id = id
        self.style = style
        self.text = text
        self.numberOfLines = numberOfLines
        self.attributedText = attributedText
        self.isHidden = isHidden
        self.isEnable = isEnable
        self.isReactive = isReactive
    }
    
    public func render(into result:UILabel){
        result.tag = self.id.hash
        result.text = self.text
        result.style = self.style
        result.numberOfLines = self.numberOfLines
        result.isEnabled = self.isEnable
        result.isHidden = self.isHidden
        result.reactiveKey = self.isReactive ? self.id : nil
        if let attributedText = self.attributedText {
            result.attributedText = attributedText
        }
        
    }
    
    public func render() -> UIView {
        let result = UILabel(frame: .zero )
        result.translatesAutoresizingMaskIntoConstraints = false
        render(into: result)
        return result
    }
    
    public func update(into existing: UIView) -> UIView {
        guard let result = existing as? UILabel else {
            return render()
        }
        self.render(into: result)
        return result
    }
}
