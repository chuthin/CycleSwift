//
//  AppDelegate.swift
//  CycleSwiftExample
//
//  Created by ptpm on 3/11/19.
//  Copyright © 2019 thincv. All rights reserved.
//

import UIKit
import Stylist
import RxSwift
import RxCocoa
@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if let styleFile = Bundle.main.url(forResource: "Style", withExtension: "yaml")
        {
            Stylist.shared.watch(url: styleFile, animateChanges: true) { error in
                print("Error loading theme:\n\(error)")
            }
        }
        
        #if DEBUG
        _ = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
            .subscribe(onNext: { _ in
                print("Resource count \(RxSwift.Resources.total)")
            })
        #endif
        //UIApplication.shared.statusBarStyle = .lightContent
        FPSCounter.showInStatusBar(UIApplication.shared)
        return true
    }


}

