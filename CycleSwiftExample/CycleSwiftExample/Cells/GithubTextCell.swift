//
//  GithubTextCell.swift
//  CycleSwift
//
//  Created by chuthin on 3/4/19.
//  Copyright © 2019 chuthin. All rights reserved.
//

import Foundation
import UIKit
import CycleSwift
public class  GithubTextCell : UITableViewCell ,CellDataSource {
    public weak var actionDelegate: CellActionDelegate?
    public var data: Identifiable?
    fileprivate let name = UILabel()
    fileprivate let likebutton = UIButton()
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.name.translatesAutoresizingMaskIntoConstraints = false
        self.likebutton.translatesAutoresizingMaskIntoConstraints = false
        self.likebutton.tintColor = .blue
        self.likebutton.backgroundColor = .gray
        self.likebutton.addTarget(self, action: #selector(GithubTextCell.likeAction), for: .touchUpInside)
        selectionStyle = .none
        separatorInset = .zero
        name.numberOfLines = 0
        self.likebutton.setTitle("Like", for: .normal)
          self.addSubview(name)
        self.addSubview(likebutton)
        
      
        
        let views = ["name":name,"like":likebutton]
        var allConstraints = [NSLayoutConstraint]()
        allConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-24-[name]-8-|", options: [], metrics: nil, views: views)
        allConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[name]-12-|", options: [], metrics: nil, views: views)
        allConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:[like(50)]-12-|", options: [], metrics: nil, views: views)
         allConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[like(48)]", options: [], metrics: nil, views: views)
        self.addConstraints(allConstraints)
    }
    
    @objc func likeAction()
    {
        if let indexPath = self.indexPath {
            self.actionDelegate?.action(action: "like", index: indexPath)
        }
        
            print("like")
    }
    var indexPath:IndexPath? = nil
    public func setDataContext(indexPath: IndexPath, data: Identifiable) {
        self.indexPath = indexPath
        if let data = data as? User {
            self.name.text = data.name
        }
    }
    
    
}
