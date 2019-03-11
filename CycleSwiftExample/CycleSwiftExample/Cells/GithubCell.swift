//
//  GithubCell.swift
//  CycleSwift
//
//  Created by chuthin on 2/22/19.
//  Copyright © 2019 thincv. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
import CycleSwift
public class  GithubCell : UITableViewCell ,CellDataSource {
    public weak var actionDelegate: CellActionDelegate?
    public var data: Identifiable?
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        avatar.layer.cornerRadius = 24
        avatar.clipsToBounds = true
    }
    
    public func setDataContext(indexPath: IndexPath, data: Identifiable) {
        
        if let data = data as? Repo {
            self.name.text = data.name
            if let url = URL(string: data.user?.avatar ?? "")
            {
                self.avatar.kf.setImage(with: url)
            }
        }
    }
}
