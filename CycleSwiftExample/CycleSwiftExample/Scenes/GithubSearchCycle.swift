//
//  GithubSearchCycle.swift
//  Cycle.Swift
//
//  Created by chuthin on 2/25/19.
//  Copyright © 2019 chuthin. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import ObjectMapper
import CycleSwift
public class GithubSearchCycle : Cycle {
    public static func drivers() -> [Drivers] {
        return [.dom,.http,.state]
    }
    
    public struct State : Initializable, Equatable, Encodable , Decodable {
        public static func == (lhs: State, rhs: State) -> Bool {
            return  lhs.searchText == rhs.searchText && lhs.results.count == rhs.results.count && lhs.shouldLoadNextPage == rhs.shouldLoadNextPage && lhs.currPage == rhs.currPage
        }
        
        public init() {
            searchText = ""
            needRender = true
            results = []
        }
        
        public var searchText:String {
            didSet{
                currPage = 1
                shouldLoadNextPage = false
                needRender = false
                url = searchText.isEmpty ? nil : "https://api.github.com/search/repositories?q=\(searchText)&page=\(currPage)&per_page=20"
                results = []
            }
        }
        public var loadingData:Bool = false
        public var currPage:Int = 1
        public var shouldLoadNextPage:Bool = false
        public var results:[Repo]
        public var needRender: Bool = false
        public var url:String?
    }
    
    required public init(){}
    
    public enum Action {
        case Search(String)
        case Response(RepoResponse)
        case LoadNextPage
    }
    
    public static func intent(_ sources: Driver<Sources>) -> Driver<Action> {
        let network = sources.network().flatMapLatest{ network -> Driver<Action> in
            if network.tag == "user" && network.response.count > 0
            {
                let response = try? Mapper<RepoResponse>().map(JSONString: network.response)
                if let res = response {
                    return Driver.just(.Response(res))
                }
            }
            return Driver.empty()
        }
        
        let dom = sources.dom()
        
        let searchAction =  dom
            .flatMapLatest{ dom -> Driver<Action> in
                return  dom.select("searchText",\Reactive<UITextField>.text)?.orEmpty.changed
                    .throttle(0.3, scheduler: MainScheduler.instance)
                    .asDriver(onErrorJustReturn: "")
                    .map{Action.Search($0)} ?? Driver.empty()
        }
        
        let state = sources.state(\StateSource<State>.value)
        
        let loarmore = state.map{$0.shouldLoadNextPage}
            .withLatestFrom(dom) {
                ($0,$1)
            }
            .flatMapLatest{ state, dom -> Driver<Action> in
                if(state)
                {
                    return dom.select("tableView",\Reactive<UITableView>.nearBottom)?
                        .skip(1)
                        .map{_ in Action.LoadNextPage} ?? Driver.empty()
                }
                return Driver.empty()
        }
        return Driver.merge(network,searchAction,loarmore)
    }
    
    public static func model(_ state: State, _ action: Action) -> State {
        switch action {
        case let .Search(text):
            var result = state
            if(result.searchText != text)
            {
                result.searchText = text
                result.needRender = state.results.count > 0 && text.isEmpty ? true : false
            }
            return result
        case let .Response(repoResponse):
            var result = state
            result.url = nil
            result.results += repoResponse.items ?? []
            result.shouldLoadNextPage = true
            result.needRender = true
            return result
        case  .LoadNextPage:
            var result = state
            result.needRender = false
            result.currPage += 1
            result.url = "https://api.github.com/search/repositories?q=\(result.searchText)&page=\(result.currPage)&per_page=20"
            result.shouldLoadNextPage = false
            return result
        }
    }
    
    public static func view(_ state: Driver<State>) -> Driver<Sinks> {
        let networkSink:Driver<Sinks> =  state.map{ $0.url}
            .filter{$0 != nil}
            .distinctUntilChanged()
            .map{
                NetworkSink(Request(url:$0!,tag:"user"))
        }
        
        let domSink:Driver<Sinks> = state
            .filter{ $0.needRender}
            .map{ state -> DomSink in
                DomSink(VTView(id: "contentView", subviews: [
                    VTView(id: "top"),
                    VTTextField(id: "searchText", placeholder : "Search text", text: state.searchText),
                    VTTableView(id: "tableView",
                                itemsSource:state.results, cells: [.cellNib("GithubCell")])], constraints:[
                                    "C0":"V:|-[top(0)]-24-[searchText]-12-[tableView]|",
                                    "C1":"H:|-24-[searchText]-24-|",
                                    "C2":"H:|[tableView]|",
                                    "C4":"H:|[top]|"
                    ]))
        }
        
        let stateSink:Driver<Sinks> = state.map{StateSink($0)}
        return Driver.merge(networkSink,domSink,stateSink)
    }
}
