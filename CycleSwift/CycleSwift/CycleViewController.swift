//
//  CycleViewController.swift
//  CycleSwift
//
//  Created by chuthin on 3/6/19.
//  Copyright © 2019 chuthin. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

public enum Drivers {
    case dom
    case http
    case state
    case storeState
}


public protocol Cycle {
    associatedtype State: Initializable,Equatable, Encodable,Decodable
    associatedtype Action
    
    static func intent(_ sources:Driver<Sources>) -> Driver<Action>
    static func model(_ state:State,_ action:Action) -> State
    static func view(_ state: Driver<State>) -> Driver<Sinks>
    static func drivers() -> [Drivers]
}

public protocol Sources {}
public protocol Sinks {}
public enum SinkEmpty : Sinks {
    case value
}

public enum SourceEmpty : Sources {
    case value
}

public struct DomSource:Sources {
    public var reactives:[String:Any] = [:]
}

public struct NetworkSource:Sources {
    public var response:Response
}

public struct StateSource<S>:Sources {
    public var value:S
}

public struct StateSink<S>:Sinks {
    public var value:S
}
public typealias Store<S> = (key:String,value:S)
public struct StoreSink<S>:Sinks {
    public var store:Store<S>
}


public struct NetworkSink:Sinks {
    public var request:Request?
}

public struct DomSink:Sinks {
    public var view:VTView
}

public struct LogSink:Sinks {
    public var message:Any?
}

extension SharedSequenceConvertibleType where E == Sinks {
    
    public func dom() -> RxCocoa.SharedSequence<Self.SharingStrategy,VTView>
    {
        return self.filter{ $0 is DomSink}.map{ ($0 as! DomSink).view}
    }
    
    public func network() -> RxCocoa.SharedSequence<Self.SharingStrategy,Request?>
    {
        return self.filter{$0 is NetworkSink}.map{ ($0 as! NetworkSink).request}
    }
    
    public func state<S>(_ key: KeyPath<StateSink<S>, S>) -> RxCocoa.SharedSequence<Self.SharingStrategy,S>
    {
        return self.filter{$0 is StateSink<S>}
            .map{ value -> S in
                let sink = value as! StateSink<S>
                return sink[keyPath:key]
            }
    }
    
    public func store<S>(_ key: KeyPath<StoreSink<S>, Store<S>>) -> RxCocoa.SharedSequence<Self.SharingStrategy,Store<S>>
    {
        return self.filter{$0 is StoreSink<S>}
            .map{ value -> Store<S> in
                let sink = value as! StoreSink<S>
                return sink[keyPath:key]
        }
    }
}

extension SharedSequenceConvertibleType where E == Sources {
    
    public func dom() -> RxCocoa.SharedSequence<Self.SharingStrategy,[String:Any]?>
    {
        return self.filter{$0 is DomSource}
            .map{($0 as? DomSource)!.reactives}
    }
    
    public func network() -> RxCocoa.SharedSequence<Self.SharingStrategy,Response>
    {
        return self.filter{$0 is NetworkSource}
            .map{($0 as? NetworkSource)!.response}
    }
    
    public func state<S>(_ key: KeyPath<StateSource<S>, S>) -> RxCocoa.SharedSequence<Self.SharingStrategy,S>
    {
        return self.filter{$0 is StateSource<S>}
            .map{ value -> S in
             let source = value as! StateSource<S>
                return source[keyPath:key]
            }
    }
}

extension Optional where Wrapped == [String:Any] {
    public func select<T,E>(_ id :String,_ keypath:KeyPath<Reactive<T>, E>) -> E?{
        if let reactive = self?[id] as? Reactive<T> {
            return reactive[keyPath:keypath]
        }
        return nil
    }
    
    public func select<T>(_ type:T.Type, _ id :String) -> Reactive<T>?{
        if let reactive = self?[id] as? Reactive<T> {
            return reactive
        }
        return nil
    }
}


public class CycleViewController<C:Cycle>:UIViewController{
    let disposeBag = DisposeBag()
     let fakeSink:BehaviorSubject<Sinks> = BehaviorSubject(value: SinkEmpty.value)
    
    open func drive(){
        drive(C.State.empty)
    }
    
    open func load(_ state:C.State){
         let initSink:Driver<Sinks> = C.view(Driver.just(state))
         initSink.drive(fakeSink)
            .disposed(by: disposeBag)
    }
    
    open func drive(_ state:C.State){
        let sources = drivers(fakeSink.asDriver(onErrorJustReturn: SinkEmpty.value))
        let sinks:Driver<Sinks> = main(sources,state)
        sinks
            .drive(fakeSink)
            .disposed(by: disposeBag)
    }
    
    open func drivers(_ sinks:Driver<Sinks>) -> Driver<Sources>{
        let domSourceBehavior:BehaviorSubject<Sources> = BehaviorSubject(value: SourceEmpty.value)
        
        let drivers = C.drivers()
        if(drivers.contains(.dom))
        {
            domDriver(sinks, domSourceBehavior)
        }
        
        if(drivers.contains(.http))
        {
            networksDriver(sinks, domSourceBehavior)
        }
       
        if(drivers.contains(.state))
        {
            stateDriver(sinks, domSourceBehavior)
        }
        
        if(drivers.contains(.storeState))
        {
            storeDriver(sinks)
        }
        
        return domSourceBehavior.asDriver(onErrorJustReturn: SourceEmpty.value)
    }
    
    
    open func networksDriver(_ sinks: Driver<Sinks>,_ sources:BehaviorSubject<Sources>){
        let network = sinks.network().filter{ $0 != nil}.asObservable()
        return network.flatMapLatest{request -> Observable<Response> in
            if let url = URL(string: request?.url ?? "") {
                let uRLRequest = URLRequest(url: url)
                return Observable<Response>.create({ observer in
                    SessionManager.default.request(uRLRequest)
                        .validate(statusCode: 200..<300)
                        .responseString{ response in
                            switch response.result {
                            case .success :
                                observer.onNext(Response(response: response.value ?? "", tag: request?.tag ?? ""))
                                observer.onCompleted()
                            case .failure(let error):
                                observer.onError(error)
                            }
                    }
                    return Disposables.create()
                })
            }
            return Observable.empty()
            }
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext:{
                sources.onNext(NetworkSource(response: $0))
            })
            .disposed(by: disposeBag)
    }
    
    open func domDriver(_ sinks: Driver<Sinks>,_ sources:BehaviorSubject<Sources>){
        let dom = sinks.dom()
        var isRendered = false
        return dom.asObservable()
            .subscribe(onNext:{[weak self] view in
                if let `self` = self  {
                    let reactives = self.renderRootView(view)
                    if(!isRendered)
                    {
                        sources.onNext(DomSource(reactives: reactives))
                    }
                    isRendered = true
                }
            })
            .disposed(by: disposeBag)
    }
    
    
    open func stateDriver(_ sinks: Driver<Sinks>,_ sources:BehaviorSubject<Sources>){
        let state = sinks.state(\StateSink<C.State>.value)
        return state
            .asObservable()
            .observeOn(MainScheduler.asyncInstance )
            .subscribe(onNext:{ state in
                sources.onNext(StateSource(value: state))
            })
            .disposed(by: disposeBag)
    }
    
    open func storeDriver(_ sinks: Driver<Sinks>){
        let store = sinks.store(\StoreSink<C.State>.store)
        return store
            .asObservable()
            .subscribe(onNext:{ store in
                if let encodedData = try? JSONEncoder().encode(store.value), let jsonString = String(data: encodedData, encoding: .utf8) {
                    UserDefaults.standard.set(jsonString, forKey: store.key)
                    UserDefaults.standard.synchronize()
                }
            })
            .disposed(by: disposeBag)
    }
    
    open func main(_ sources:Driver<Sources>,_ props:C.State) -> Driver<Sinks> {
        let actions = C.intent(sources)
        let state = actions.scan(props, accumulator: C.model).distinctUntilChanged().startWith(props)
        let sinks = C.view(state)
        return sinks
    }
}

extension Data
{
    func toString() -> String?
    {
        return String(data: self, encoding: .utf8)
    }
}
