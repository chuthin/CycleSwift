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

[Complete example](https://github.com/chuthin/CycleSwift/blob/master/CycleSwift/CounterCycle.swift)
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

