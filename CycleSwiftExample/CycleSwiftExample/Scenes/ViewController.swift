//
//  ViewController.swift
//  CycleSwift
//
//
//  Created by chuthin on 2/28/19.
//  Copyright © 2019 chuthin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import CycleSwift
class ViewController: UIViewController {
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        /*_ = self.renderRootView(VTView(id: "contentView", subviews: [
            VTLabel(id: "label", text: "Hello world"),
            VTSwitch(id: "switch"),
            VTSlider(id: "slider", value: 0.5),
            VTStackView(id: "stackView", axis: .horizontal, subviews: [
                VTLabel(id: "label1", text: "Label1"),
                VTLabel(id: "label2", text: "Label2")
                ]),
            VTView(id: "scContentView", style: "contentView",subviews:[
                VTLabel(id: "label3", text: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.")
                ],constraints:[
                    "ct1":"V:|-0-[label3]-0-|",
                    "ct2":"H:|-24-[label3]-24-|"
                ]),
            VTScrollView(id: "scrollView",contentView:VTView(id: "scContentView1", style: "contentView",subviews:[
                VTImageView(id: "imageView",name:"background"),
                VTTextField(id: "textfield", placeholder: "Input here"),
                VTLabel(id: "label4", text: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.")
                ],constraints:[
                    "ct1":"V:|-12-[textfield(32)]-12-[label4]-12-|",
                    "ct2":"H:|-24-[label4]-24-|",
                    "ct3":"H:|-24-[textfield]-24-|",
                    "ct4":"V:|[imageView]|",
                    "ct5":"H:|[imageView]|"
                ])),
            VTButton(id: "button", title: "Click me!")
            ],constraints:[
                "c1" : "V:|-48-[label]-24-[switch]-12-[slider]-12-[stackView]-12-[scContentView]-12-[scrollView]-12-[button]",
                "c2" : "H:|-24-[label]-24-|",
                "c3" : "H:|-24-[button]-24-|",
                "c4" : "V:[button]-24-|",
                "c5" : "H:|-24-[stackView]",
                "c6" : "H:|[scContentView]|",
                "c7" : "H:|[scrollView]|",
                "c8" : "H:[switch(50)]-24-|",
                "c9" : "H:|-24-[slider]-24-|"
            ]))
        */
        /*renderRootView(VTView(id: "contentView",  subviews: [
         VTTableView(id: "tableView",  itemsSource: [
         User(name: "User 1", avatar: ""),
         User(name: "User 2", avatar: ""),
         User(name: "User 3", avatar: ""),
         ], cells: [
         VTCell.cellNib("GithubCell")
         ])
         ], constraints: [
         "c1": "V:|[tableView]|",
         "c2": "H:|[tableView]|"
         ]))*/
        
        /*let users:[User] =  [
         User(name: "User 1", avatar: ""),User(name: "User 2", avatar: ""),User(name: "User 3", avatar: ""),
         User(name: "User 1", avatar: ""),User(name: "User 2", avatar: ""),User(name: "User 3", avatar: ""),
         User(name: "User 1", avatar: ""),User(name: "User 2", avatar: ""),User(name: "User 3", avatar: ""),
         User(name: "User 1", avatar: ""),User(name: "User 2", avatar: ""),User(name: "User 3", avatar: ""),
         User(name: "User 1", avatar: ""),User(name: "User 2", avatar: ""),User(name: "User 3", avatar: ""),
         User(name: "User 1", avatar: ""),User(name: "User 2", avatar: ""),User(name: "User 3", avatar: ""),
         User(name: "User 1", avatar: ""),User(name: "User 2", avatar: ""),User(name: "User 3", avatar: ""),
         User(name: "User 1", avatar: ""),User(name: "User 2", avatar: ""),User(name: "User 3", avatar: ""),
         User(name: "User 1", avatar: ""),User(name: "User 2", avatar: ""),User(name: "User 3", avatar: ""),
         User(name: "User 1", avatar: ""),User(name: "User 2", avatar: ""),User(name: "User 3", avatar: ""),
         User(name: "User 1", avatar: ""),User(name: "User 2", avatar: ""),User(name: "User 3", avatar: ""),
         User(name: "User 1", avatar: ""),User(name: "User 2", avatar: ""),User(name: "User 3", avatar: ""),
         User(name: "User 1", avatar: ""),User(name: "User 2", avatar: ""),User(name: "User 3", avatar: ""),
         User(name: "User 1", avatar: ""),User(name: "User 2", avatar: ""),User(name: "User 3", avatar: ""),
         User(name: "User 1", avatar: ""),User(name: "User 2", avatar: ""),User(name: "User 3", avatar: ""),
         User(name: "User 1", avatar: ""),User(name: "User 2", avatar: ""),User(name: "User 3", avatar: ""),
         User(name: "User 1", avatar: ""),User(name: "User 2", avatar: ""),User(name: "User 3", avatar: ""),
         User(name: "User 1", avatar: ""),User(name: "User 2", avatar: ""),User(name: "User 3", avatar: "")
         ].map{$0.withIdentifier("GithubCollectionCell")}
         
         renderRootView(VTView(id: "contentView",  subviews: [
         VTCollectionView(id: "dataView",itemSize:CGSize(width: 80 , height: 80),scrollDirection :.vertical ,  itemsSource: users, cells: [
         VTCell.cellNib("GithubCollectionCell")
         ])
         ], constraints: [
         "c1": "V:|[dataView]|",
         "c2": "H:|[dataView]|"
         ]))*/
        
        //SafeArea "V:|-[***]-|"  "H:|-[***]-|"
        
        
        let users = [User(name: "User 1", avatar: ""),User(name: "User 2", avatar: ""),User(name: "User 3", avatar: "")]
        
        let reactives:[String:Any]? = renderRootView(VTView(id: "contentView", subviews: [
            VTTableView(id: "tableView", itemsSource: users.map{ $0.withIdentifier("GithubTextCell")}, cells: [.cellClass("GithubTextCell")])
            ], constraints: [
                "C1":"V:|-[tableView]-|",
                "C2":"H:|-[tableView]-|",
            ]))
        
         if let t = reactives.select("tableView", \Reactive<UITableView>.cellAction)
         {
                t.asObservable()
                    .subscribe(onNext:{
                        print($0)
                    })
                .disposed(by: disposeBag)
        }
        
        
       
        //text.rx.controlEvent(<#T##controlEvents: UIControlEvents##UIControlEvents#>)
        // rx = text.rx
        //.controlEvent(.editingChanged)
    }
    
    
    
}


