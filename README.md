# CycleSwift
An implement Cycle.js. https://cycle.js.org with [RxSwift](https://github.com/ReactiveX/RxSwift), [VFL](https://developer.apple.com/library/archive/documentation/UserExperience/Conceptual/AutolayoutPG/VisualFormatLanguage.html) and [Stylist](https://github.com/yonaskolb/Stylist)

Note!: VFL SafeArea "V:|-[***]-|"  "H:|-[***]-|"
# Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate RxFeedback into your Xcode project using CocoaPods, specify it in your `Podfile`:

```bash
pod 'CycleSwift'
```

Then, run the following command:

```bash
$ pod install
```
# Examples
## Counter

[Complete example](https://github.com/chuthin/CycleSwift/blob/master/CycleSwiftExample/CycleSwiftExample/Scenes/CounterCycle.swift)
```swift
    public struct CounterCycle : Cycle {
   
    public struct State : Initializable, Equatable , Encodable, Decodable{
        var counter:Int
        public init() {
            counter = 0
        }
        
        public init(_ counter: Int) {
            self.counter =  counter
        }
    }
    
    public enum Action {
        case Increment(Int)
        case Decrement(Int)
    }
    
    public init(){}
    
    public static func drivers() -> [Drivers] {
        return [.dom]
    }
    
    public static func intent(_ sources: Driver<Sources>) -> Driver<Action> {
        return sources.dom()
            .flatMapLatest{ dom -> Driver<Action> in
                let increment = dom.select("incrementButton",\Reactive<UIButton>.tap)?.asDriver().map{ _ in Action.Increment(1) } ?? Driver.empty()
                let decrement =  dom.select("decrementButton",\Reactive<UIButton>.tap)?.asDriver().map{_ in Action.Decrement(-1)} ?? Driver.empty()
                return Driver.merge(increment,decrement)
        }
    }
    
    public static func model(_ state: State, _ action: Action) -> State {
        switch action {
        case let .Increment(value):
            return State(state.counter + value)
        case let .Decrement(value):
            return State(state.counter + value)
        }
    }
    
    public static func view(_ state: Driver<State>) -> Driver<Sinks> {
        let domSink:Driver<Sinks> = state.map{ state -> DomSink in
            DomSink(view: VTView(id: "contentView", style: "view", subviews:[
                VTLabel(id: "counterLabel", text: "Counter: \(state.counter)"),
                VTButton(id: "incrementButton", style: "primary", title: "Increment"),
                VTButton(id: "decrementButton", title: "Decrement")
                ],constraints:[
                    "C0" : "H:[contentView]-(<=1)-[counterLabel]",
                    "C1" : "V:[counterLabel]-24-[incrementButton(48)]-24-[decrementButton(48)]",
                    "C2" : "H:|-24-[counterLabel]-24-|",
                    "C3" : "H:|-24-[incrementButton]-24-|",
                    "C4" : "H:|-24-[decrementButton]-24-|"
                ],formatOptions:[
                    "C0":"alignAllCenterY"
                ]))
        }
        return domSink
    }
}

```
<img src="https://github.com/chuthin/CycleSwift/blob/master/CycleSwiftExample/CycleSwiftExample/Assets/GIF-190311_213248.gif" width="320px" />

## Todos

[Complete example](https://github.com/chuthin/CycleSwift/blob/master/CycleSwiftExample/CycleSwiftExample/Scenes/TodoCycle.swift)
```swift
public static func intent(_ sources: Driver<Sources>) -> Driver<Action> {
        let dom = sources.dom()
        let todo = dom.flatMapLatest{ dom -> Driver<Action> in
            if let reactiveTodo = dom.select(UITextField.self, "todo") {
                 let text =  reactiveTodo.text.orEmpty.changed.asDriver()
                 return reactiveTodo.controlEvent(ControlEvents.editingDidEnd)
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
            if(result.index == 2){
                result.completeds.remove(at: index)
            }
            else{
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
```
<img src="https://github.com/chuthin/CycleSwift/blob/master/CycleSwiftExample/CycleSwiftExample/Assets/todos.gif" width="320px" />

## Paging with Github search

[Complete example](https://github.com/chuthin/CycleSwift/blob/master/CycleSwiftExample/CycleSwiftExample/Scenes/TodoCycle.swift)
```swift
public static func intent(_ sources: Driver<Sources>) -> Driver<Action> {
        let network = sources.network().flatMapLatest{ network -> Driver<Action> in
            if network.tag == "user" && network.response.count > 0{
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
            .withLatestFrom(dom) {($0,$1)}
            .flatMapLatest{ state, dom -> Driver<Action> in
                if(state){
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
            if(result.searchText != text){
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
            .map{ NetworkSink(Request(url:$0!,tag:"user"))}
        
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
```
<img src="https://github.com/chuthin/CycleSwift/blob/master/CycleSwiftExample/CycleSwiftExample/Assets/github-search.gif" width="320px" />
