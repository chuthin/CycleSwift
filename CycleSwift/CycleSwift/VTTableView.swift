//
//  VTTableView.swift
//  VirtualViews
//
//  Created by chuthin on 3/1/19.
//  Copyright © 2019 chuthin. All rights reserved.
//

import Foundation
import UIKit
public struct VTTableView : VirtualView {
    public let id :String
    public let style:String
    public let isHidden:Bool
    public let itemsSource:[Identifiable]
    public let cells:[VTCell]
    public let isReactive: Bool
    
    public init(id:String,isHidden:Bool = false,itemsSource:[Identifiable] = [],cells:[VTCell] = [],isReactive: Bool = true) {
        self.id = id
        self.style = ""
        self.isHidden = isHidden
        self.itemsSource = itemsSource
        self.cells = cells
        self.isReactive = isReactive
    }
    
    public func render(into result:UITableView){
        result.tag = self.id.hash
        result.isHidden = self.isHidden
        result.setItemsSource(self.itemsSource)
        result.reactiveKey = self.isReactive ? self.id : nil
    }
    
    public func render() -> UIView {
        let result = UITableView(frame: .zero )
        result.translatesAutoresizingMaskIntoConstraints = false
        result.estimatedRowHeight = 10
        if result.dataSource == nil {
            for cell in self.cells {
                switch cell {
                case let .cellNib(identifier):
                    let nib =  UINib(nibName: identifier, bundle: nil)
                    result.register(nib, forCellReuseIdentifier: identifier)
                case let .cellClass(name):
                    if name == "UITableViewCell"
                    {
                        if let  type = NSClassFromString(name) as? UITableViewCell.Type {
                            result.register(type, forCellReuseIdentifier: name)
                        }
                    }
                    else
                    {
                        if let bundleName = Bundle.main.infoDictionary?["CFBundleName"], let type = NSClassFromString("\(bundleName).\(name)") as? UITableViewCell.Type {
                            result.register(type, forCellReuseIdentifier: name)
                        }
                    }
                    
                    break
                }
                
            }
        }
        render(into: result)
        return result
    }
    
    public func update(into existing: UIView) -> UIView {
        guard let result = existing as? UITableView else {
            return render()
        }
        self.render(into: result)
        return result
    }
}

public extension UITableView {
    private static let DATASOURCE_KEY = "VirtualView.TableViewDataSource"
    public var itemsSource: [Identifiable] {
        get {
            return getAssociatedValue(key: UITableView.DATASOURCE_KEY,
                                      object: self,
                                      initialValue: [])
        }
        set {
            set(associatedValue: newValue, key: UITableView.DATASOURCE_KEY, object: self)
        }
    }
    
}

extension UITableView : UITableViewDataSource {
    
    
    public func setItemsSource(_ itemsSource:[Identifiable]){
        if(self.dataSource == nil)
        {
            self.dataSource = self
        }
        
        self.itemsSource = itemsSource
        self.reloadData()
    }
    
    private func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsSource.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = itemsSource[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier:item.identifier, for: indexPath)
        if var baseCell = cell as? CellDataSource {
            baseCell.actionDelegate = self
            baseCell.setDataContext(indexPath: indexPath, data: item)
        }
        return cell
    }
}



