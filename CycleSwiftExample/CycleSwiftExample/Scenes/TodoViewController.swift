//
//  TodoViewController.swift
//  CycleSwift
//
//  Created by chuthin on 3/8/19.
//  Copyright © 2019 chuthin. All rights reserved.
//

import Foundation
import CycleSwift
public class TodoViewController : CycleViewController<TodoCycle> {
    public override func viewDidLoad() {
        super.viewDidLoad()
        let decoder = JSONDecoder()
        if let json =  UserDefaults.standard.string(forKey: "todoState"),let jsonData = json.data(using: .utf8),let state = try? decoder.decode(TodoCycle.State.self, from: jsonData)
        {
             drive(state)
        }
        else {
            drive()
        }
        
    }
}
