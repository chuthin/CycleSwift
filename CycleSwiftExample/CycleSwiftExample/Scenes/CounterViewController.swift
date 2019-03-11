//
//  CounterViewController.swift
//  CycleSwift
//
//  Created by chuthin on 2/25/19.
//  Copyright © 2019 chuthin. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
import CycleSwift
class CounterViewController: CycleViewController<CounterCycle> {
    override func viewDidLoad() {
        super.viewDidLoad()
        drive()
    }
}

