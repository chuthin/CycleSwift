//
//  CellDataSource.swift
//  VirtualViews
//
//  Created by chuthin on 3/1/19.
//  Copyright © 2019 chuthin. All rights reserved.
//

import UIKit

public typealias CellAction = (action:String,index:IndexPath)

public protocol CellDataSource {
    var data:Identifiable? {get set}
    var actionDelegate:CellActionDelegate? {get set}
    func setDataContext(indexPath:IndexPath,data:Identifiable)
}

public protocol CellActionDelegate : class {
    func action(action:String,index:IndexPath)
}
