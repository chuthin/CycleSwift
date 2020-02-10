//
//  TodoCycle.swift
//  CycleSwift
//
//  Created by chuthin on 3/8/19.
//  Copyright © 2019 chuthin. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import CycleSwift

public struct Todo:Identifiable, Decodable,Encodable {
    public var identifier: String = "TodoCell"
    public var title:String
    public var isCompleted:Bool
    public var id:String
    
    public init(_ title:String,_ isCompleted:Bool = false)
    {
        self.title = title
        self.isCompleted = isCompleted
        self.id = UUID().uuidString
    }
}

public struct TodoCycle:Cycle {
    public struct  State:Initializable,Equatable ,Decodable,Encodable {
        public static func == (lhs: TodoCycle.State, rhs: TodoCycle.State) -> Bool {
            if(lhs.all.count == rhs.all.count && lhs.all.count > 0)
            {
                for i in 0...lhs.all.count - 1 {
                    if(lhs.all[i].title != rhs.all[i].title || lhs.all[i].isCompleted != rhs.all[i].isCompleted)
                    {
                        return false
                    }
                }
            }
            return lhs.index == rhs.index && lhs.all.count == rhs.all.count
        }
        
        public init(){
            index = 0
            actives = []
            completeds = []
        }
        public var all:[Todo] {
            return actives + completeds
        }
        public var index:Int
        public var actives:[Todo]
        public var completeds:[Todo]
        
        public var todos:[Todo]
        {
            switch index {
            case 1:
                return actives
            case 2:
                return completeds
            default:
                return all
            }
        }
    }
    
    public enum Action {
        case New(String)
        case Complete(Int)
        case Delete(Int)
        case TabSelected(Int)
    }
    
    public static func intent(_ sources: Driver<Sources>) -> Driver<Action> {
        let dom = sources.dom()
        let todo = dom.flatMapLatest{ dom -> Driver<Action> in
            if let reactiveTodo = dom.select(UITextField.self, "todo") {
                 let text =  reactiveTodo.text.orEmpty.changed.asDriver()
                return reactiveTodo.controlEvent(UIControl.Event.editingDidEnd)
                    .asDriver()
                    .withLatestFrom(text)
                    .filter{!$0.isEmpty}
                    .map{Action.New($0) }
            }
            return Driver.never()
        }
        
        let tabSelected = dom.flatMapLatest{ dom -> Driver<Action> in
            let all = dom.select("allButton", \Reactive<UIButton>.tap)?.asDriver().map{ _ in Action.TabSelected(0)} ?? Driver.empty()
            let actives = dom.select("activeButton", \Reactive<UIButton>.tap)?.asDriver().map{ _ in Action.TabSelected(1)} ?? Driver.empty()
            let completeds = dom.select("completeButton", \Reactive<UIButton>.tap)?.asDriver().map{ _ in Action.TabSelected(2)} ?? Driver.empty()
            return Driver.merge(all,actives,completeds)
        }
        
        let tableViewAction = dom.flatMapLatest{ dom -> Driver<Action> in
            if let tableview = dom.select(UITableView.self, "tableView"){
                let selected = tableview.itemSelected.asDriver().map{Action.Complete($0.row)}
                let deleted = tableview.cellAction.asDriver().map{Action.Delete($0.index.row)}
                return Driver.merge(deleted,selected)
            }
            return Driver.empty()
        }
        
        return Driver.merge(todo,tabSelected,tableViewAction)
    }
    
    public static func model(_ state: State, _ action: TodoCycle.Action) -> State {
        switch action {
        case let .New(todo):
            var result = state
            result.actives.append(Todo(todo))
            return result
        case let .Complete(index):
            var result = state
            if(index < result.actives.count){
                var todo = result.actives[index]
                todo.isCompleted = true
                result.actives.remove(at: index)
                result.completeds.append(todo)
            }
            return result
        case let .Delete(index):
            var result = state
            if(result.index == 2)
            {
                result.completeds.remove(at: index)
            }
            else
            {
                result.completeds.remove(at:index - result.actives.count)
            }
            return result
        case let .TabSelected(index):
            var result = state
            result.index = index
            return result
        }
    }
    
    public static func view(_ state: Driver<State>) -> Driver<Sinks> {
        let domSink:Driver<Sinks> = state
            .map{ state -> DomSink in
                DomSink(VTView(id: "contentView", subviews: [
                    VTView(id: "top"),
                    VTTextField(id: "todo", placeholder : "What need to be done?", text: ""),
                    VTTableView(id: "tableView",itemsSource:state.todos, cells: [.cellClass("TodoCell")]),
                    VTButton(id: "allButton", style:state.index == 0 ? "tabSelected" : "tab", title: "All (\(state.all.count))"),
                    VTButton(id: "activeButton", style:state.index == 1 ? "tabSelected" : "tab", title: "Active (\(state.actives.count))"),
                    VTButton(id: "completeButton", style:state.index == 2 ? "tabSelected" : "tab", title: "Complete (\(state.completeds.count))")
                    ], constraints:[
                                    "C0":"V:|-[top(0)]-24-[todo]-12-[tableView]-12-[allButton(48)]|",
                                    "C1":"H:|-24-[todo]-24-|",
                                    "C2":"H:|[tableView]|",
                                    "C4":"H:|[top]|",
                                    "C5":"H:|[allButton][activeButton(==allButton)][completeButton(==allButton)]|",
                                    "C6":"V:[activeButton(48)]|",
                                    "C7":"V:[completeButton(48)]|"
                    ]))
        }
        
        let storeSink:Driver<Sinks> = state.skip(1).map{ StoreSink( Store(key:"todoState",value: $0))}
        
        return Driver.merge(domSink,storeSink)
    }
    
    public static func drivers() -> [Drivers] {
        return [.dom,.storeState]
    }
}
