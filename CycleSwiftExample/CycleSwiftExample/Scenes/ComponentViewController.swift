//
//  ComponentViewController.swift
//  Cycle.Swift
//
//  Created by chuthin on 2/26/19.
//  Copyright © 2019 chuthin. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
/*
class ComponentViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        run()
    }
    
    public func run() {
        let fakeSink:BehaviorSubject<Sinks> = BehaviorSubject(value: SinkEmpty.value)
        let sources = driver(fakeSink.asDriver(onErrorJustReturn: SinkEmpty.value))
        let sinks:Driver<Sinks> = main(sources)
        sinks.drive(fakeSink)
            .disposed(by: disposeBag)
    }
    
    public func main(_ domSource:Driver<Sources>) -> Driver<Sinks> {
        let firstNameComponent = textInputComponent(domSource,Props(title:"First Name",placeholder:"First name",id:"firstName"))
        let lastNameComponent = textInputComponent(domSource,Props(title:"Last Name",placeholder:"Last name",id:"lasttName"))
        let state = Driver.combineLatest(firstNameComponent.value, lastNameComponent.value)
            .map{ "\($0) \($1)"}
            .distinctUntilChanged()
        
        let sinks:Driver<Sinks> = Driver.combineLatest(state,firstNameComponent.view, lastNameComponent.view)
            .map{ (arg) -> DomSink in
                let (fullname, firstName, lastName) = arg
                return DomSink(view:VTView(id: "contentView", style: "view", subviews:[
                    firstName,
                    lastName,
                    VTLabel(id: "fullName", style:"active", text: "FullName: \(fullname)")
                    ],constraints:[
                    "C1" : "V:|-148-[firstName]-12-[lasttName]-12-[fullName]",
                    "C2" : "H:|[firstName]|",
                    "C3" : "H:|[lasttName]|",
                    "C0" : "H:|-24-[fullName]-24-|"
                ]))
        }
        return sinks
    }
    
    
    typealias Props = (title:String,placeholder:String,id:String)
    public func textInputComponent(_ source:Driver<Sources>,_ props:Props) -> (view:Driver<VTView>, value:Driver<String>) {
        let state = source.dom().flatMap{ dom -> Driver<String> in
            return dom.select("\(props.id)_textField",\Reactive<UITextField>.text)?.orEmpty
                .throttle(0.3, scheduler: MainScheduler.instance)
                .asDriver(onErrorJustReturn: "") ?? Driver.empty()
        }.startWith("")
        .distinctUntilChanged()
    
        let view = state.map{ value -> VTView in
            return VTView(id: props.id, subviews: [
                VTLabel(id: "\(props.id)_label", text: props.title),
                VTTextField(id: "\(props.id)_textField", placeholder: props.placeholder, text: value)
                ], constraints:[
                    "C1" : "V:|-12-[\("\(props.id)_label")]-4-[\("\(props.id)_textField")]-12-|",
                    "C2" : "H:|-24-[\("\(props.id)_textField")]-24-|",
                    "C0" : "H:|-24-[\("\(props.id)_label")]-24-|",
                ])
        }
        return (view:view,value:state)
    }
}

*/
