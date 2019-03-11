//
//  Network.swift
//  Cycle.Swift
//
//  Created by chuthin on 2/25/19.
//  Copyright © 2019 chuthin. All rights reserved.
//

import Foundation

public struct Request:Initializable {
    public var url:String
    public var tag:String
    public init() {
        url = ""
        tag = ""
    }
    public init(url:String,tag:String)
    {
        self.url = url
        self.tag = tag
    }
}

public struct Response:Initializable {
    public var response:String
    public var tag:String
    
    public init() {
        response = ""
        tag = ""
    }
    
    public init(response:String,tag:String)
    {
        self.response = response
        self.tag = tag
    }
}
