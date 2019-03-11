//
//  VTCollectionView.swift
//  VirtualViews
//
//  Created by chuthin on 3/1/19.
//  Copyright © 2019 chuthin. All rights reserved.
//

import Foundation
import UIKit

public struct VTCollectionView : VirtualView {
    public let id :String
    public let style:String
    public let isHidden:Bool
    public let itemSize:CGSize
    public let minimumLineSpacing:Float
    public let minimumInteritemSpacing:Float
    public let scrollDirection:UICollectionView.ScrollDirection
    public let itemsSource:[Identifiable]
    public let cells:[VTCell]
    public let isReactive: Bool
    
    public init(id:String,isHidden:Bool = false,itemSize:CGSize = .zero,scrollDirection:UICollectionView.ScrollDirection = .horizontal,minimumLineSpacing:Float = 0,minimumInteritemSpacing:Float = 0,itemsSource:[Identifiable] = [],cells:[VTCell] = [],isReactive:Bool = true) {
        self.id = id
        self.style = ""
        self.isHidden = isHidden
        self.itemsSource = itemsSource
        self.cells = cells
        self.itemSize = itemSize
        self.scrollDirection = scrollDirection
        self.minimumLineSpacing = minimumLineSpacing
        self.minimumInteritemSpacing = minimumInteritemSpacing
        self.isReactive = isReactive
    }
    
    public func render(into result:UICollectionView){
        result.tag = self.id.hash
        result.isHidden = self.isHidden
        result.setItemsSource(self.itemsSource)
        result.reactiveKey = self.isReactive ? self.id : nil
    }
    
    public func render() -> UIView {
        let layout = UICollectionViewFlowLayout()
    
        layout.itemSize = self.itemSize
        layout.scrollDirection = self.scrollDirection
        layout.minimumLineSpacing = CGFloat(self.minimumLineSpacing)
        layout.minimumInteritemSpacing = CGFloat(self.minimumInteritemSpacing)
        let result = UICollectionView(frame: .zero, collectionViewLayout: layout)
        result.backgroundColor = .white
        
        
        result.translatesAutoresizingMaskIntoConstraints = false
        if result.dataSource == nil {
            for cell in self.cells {
                switch cell {
                case let .cellNib(identifier):
                    let nib =  UINib(nibName: identifier, bundle: nil)
                    result.register(nib, forCellWithReuseIdentifier: identifier)
                case let .cellClass(name):
                    if name == "UICollectionViewCell"
                    {
                        if let  type = NSClassFromString(name) as? UICollectionViewCell.Type {
                            result.register(type, forCellWithReuseIdentifier: name)
                        }
                    }
                    else
                    {
                        if let bundleName = Bundle.main.infoDictionary?["CFBundleName"], let type = NSClassFromString("\(bundleName).\(name)") as? UITableViewCell.Type {
                            result.register(type, forCellWithReuseIdentifier: name)
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
        guard let result = existing as? UICollectionView else {
            return render()
        }
        self.render(into: result)
        return result
    }
}

public extension UICollectionView {
    private static let DATASOURCE_KEY = "VirtualView.CollectionViewDataSource"
    public var itemsSource: [Identifiable] {
        get {
            return getAssociatedValue(key: UICollectionView.DATASOURCE_KEY,
                                      object: self,
                                      initialValue: [])
        }
        set {
            set(associatedValue: newValue, key: UICollectionView.DATASOURCE_KEY, object: self)
        }
    }
    
}

extension UICollectionView : UICollectionViewDataSource {
    public func setItemsSource(_ itemsSource:[Identifiable]){
        if(self.dataSource == nil)
        {
            self.dataSource = self
        }
        
        self.itemsSource = itemsSource
        self.reloadData()
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemsSource.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = itemsSource[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: item.identifier, for: indexPath)
        if let baseCell = cell as? CellDataSource {
            baseCell.setDataContext(indexPath: indexPath, data: item)
        }
        return cell
    }
}
