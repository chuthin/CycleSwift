//
//  TodoCell.swift
//  CycleSwift
//
//  Created by chuthin on 3/8/19.
//  Copyright © 2019 chuthin. All rights reserved.
//

import Foundation
import UIKit
import CycleSwift
public class  TodoCell : UITableViewCell ,CellDataSource {
    public weak var actionDelegate: CellActionDelegate?
    public var data: Identifiable?
    fileprivate let name = UILabel()
    fileprivate let deleteButton = UIButton()
    fileprivate let line = UIView()
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.name.translatesAutoresizingMaskIntoConstraints = false
        self.deleteButton.translatesAutoresizingMaskIntoConstraints = false
        self.line.translatesAutoresizingMaskIntoConstraints = false
        self.deleteButton.tintColor = .blue
        self.deleteButton.addTarget(self, action: #selector(GithubTextCell.likeAction), for: .touchUpInside)
        selectionStyle = .none
        separatorInset = .zero
        name.numberOfLines = 0
        line.backgroundColor = UIColor.gray
        self.deleteButton.setImage(UIImage(named: "delete"), for: .normal)
        self.addSubview(name)
        self.addSubview(line)
        self.addSubview(deleteButton)
        
        let views = ["content":self,"name":name,"delete":deleteButton,"line":line]
        var allConstraints = [NSLayoutConstraint]()
        allConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-24-[name]-8-[delete(36)]-24-|", options: [], metrics: nil, views: views)
        allConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[name]-12-|", options: [], metrics: nil, views: views)
        allConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-4-[delete(36)]", options: [], metrics: nil, views: views)
        allConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-22-[line(0.5)]", options: [], metrics: nil, views: views)
        allConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-12-[line]-12-|", options: [], metrics: nil, views: views)
        
        self.addConstraints(allConstraints)
    }
    
    @objc func likeAction()
    {
        if let indexPath = self.indexPath {
            self.actionDelegate?.action(action: "delete", index: indexPath)
        }
        
    }
    var indexPath:IndexPath? = nil
    public func setDataContext(indexPath: IndexPath, data: Identifiable) {
        self.indexPath = indexPath
        if let data = data as? Todo {
            self.name.text = data.title
            line.isHidden = !data.isCompleted
            deleteButton.isHidden = !data.isCompleted
        }
    }
    
    
}
