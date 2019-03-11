//
//  VTImageView.swift
//  VirtualViews
//
//  Created by chuthin on 3/1/19.
//  Copyright © 2019 chuthin. All rights reserved.
//

import Foundation
import UIKit

public struct VTImageView:VirtualView {
    public let id :String
    public let style: String
    public let isHidden:Bool
    public let name:String?
    public let url:String?
    public let image:UIImage?
    public let contentMode:UIViewContentMode
    public let isReactive: Bool
    
    public init(id:String,style:String = "imageview",name:String? = nil,url:String? = nil,image:UIImage? = nil,contentMode:UIViewContentMode = UIViewContentMode.scaleToFill,isReactive:Bool = false,isHidden:Bool = false ) {
        self.id = id
        self.style = style
        self.name = name
        self.url = url
        self.image = image
        self.contentMode = contentMode
        self.isHidden = isHidden
        self.isReactive = isReactive
    }
    
    public func render(into result:UIImageView){
        result.tag = self.id.hashValue
        result.style = self.style
        result.contentMode = self.contentMode
        result.isHidden = self.isHidden
        result.reactiveKey = self.isReactive ? self.id : nil
        
        if(self.image != nil)
        {
            result.image = image
        }
        else if let name = self.name {
            result.image = UIImage(named: name)
        }
        else if let url = URL(string: self.url ?? ""),let data = try? Data(contentsOf: url) {
            result.image = UIImage(data: data)
        }
    }
    
    public func update(into existing: UIView) -> UIView {
        guard let result = existing as? UIImageView else {
            return render()
        }
        self.render(into: result)
        return result
    }
    
    public func render() -> UIView {
        let result = UIImageView(frame: .zero )
        result.translatesAutoresizingMaskIntoConstraints = false
        render(into: result)
        return result
    }
    
}
