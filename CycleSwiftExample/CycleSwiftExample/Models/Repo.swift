//
//  Repo.swift
//  CycleSwift
//
//  Created by chuthin on 2/23/19.
//  Copyright © 2019 thincv. All rights reserved.
//

import Foundation
import CycleSwift
import ObjectMapper

public struct RepoResponse {
     public let total:Int64?
     public let items:[Repo]?
}

extension RepoResponse: ImmutableMappable {
    public init(map: Map) throws {
        self.items = try? map.value("items")
        self.total = try? map.value("total_count")
    }
}

public struct Repo :Identifiable, Encodable, Decodable {
    public var identifier: String = "GithubCell"
    public let name:String?
    public let user:User?
}

extension Repo: ImmutableMappable {
    public init(map: Map) throws {
        self.name = try? map.value("full_name")
        self.user = try? map.value("owner")
    }
}
