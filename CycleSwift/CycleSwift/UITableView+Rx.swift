//
//  UITableView+Rx.swift
//  CycleSwift
//
//  Created by chuthin on 3/6/19.
//  Copyright © 2019 chuthin. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
extension Reactive where Base:UITableView{
    public var nearBottom: Driver<()> {
        func isNearBottomEdge(tableView: UITableView, edgeOffset: CGFloat = 20.0) -> Bool {
            return tableView.contentOffset.y + tableView.frame.size.height + edgeOffset > tableView.contentSize.height
        }
        
        return self.contentOffset
            .throttle(0.5, scheduler: MainScheduler.asyncInstance)
            .asDriver(onErrorJustReturn: CGPoint(x: 0, y: 0 ))
            .flatMap { _ in
                return isNearBottomEdge(tableView: self.base, edgeOffset: 0.0)
                    ? Driver.just(())
                    : Driver.empty()
        }
    }
    
}


extension UITableView : CellActionDelegate {
    @objc public func action(action: String, index: IndexPath) {
        print("action :\(action)")
    }
}

extension Reactive where Base:UITableView {
    
    func cast<T>(_ resultType: T.Type, _ object: Any) throws -> T {
        guard let returnValue = object as? T else {
            throw RxCocoaError.castingError(object: object, targetType: resultType)
        }
        
        return returnValue
    }
    public var cellAction: ControlEvent<CellAction> {
        let source = self.methodInvoked(#selector(UITableView.action(action:index:)))
            .map { arg -> CellAction in
                let action = try self.cast(String.self, arg[0])
                let index = try self.cast(IndexPath.self, arg[1])
                return CellAction(action:action,index:index)
        }
        return ControlEvent(events: source)
    }
}

