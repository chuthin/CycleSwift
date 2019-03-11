//
//  User.swift
//  CycleSwift
//
//  Created by chuthin on 2/22/19.
//  Copyright © 2019 thincv. All rights reserved.
//

import Foundation
import ObjectMapper
import CycleSwift
public struct User :Identifiable, Encodable,Decodable {
    public var identifier: String = "GithubCell"
    public let avatar:String
    public let name:String
    public let url:String
    
    public init(name:String,avatar:String,url:String = ""){
        self.name = name
        self.avatar = avatar
        self.url = url
    }
}

extension User: ImmutableMappable {
    public init(map: Map) throws {
        self.name = try map.value("login") ?? ""
        self.avatar = try map.value("avatar_url") ?? ""
        self.url = try map.value("url") ?? ""
    }
}
