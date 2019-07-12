//
//  ViewController.swift
//  CleanRequest
//
//  email：chongyangfly@163.com
//  QQ：1909295866
//  github：https://github.com/wangcy90
//  blog：http://wangcy90.github.io
//
//  Created by WangChongyang on 01/05/2019.
//  Copyright (c) 2019 WangChongyang. All rights reserved.
//

import UIKit
import CleanRequest
import RxSwift

class ViewController: UIViewController {
    
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        customSettings()
        normalRequest()
        rxRequest()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func customSettings() {

//        CleanRequest.provider = MoyaProvider<MultiTarget>()
        
//        CleanRequest.setManager(<#T##manager: Manager##Manager#>)

//        CleanRequest.setPlugins(<#T##plugins: [PluginType]##[PluginType]#>)
        
    }
    
    func normalRequest() {
        
        GitHubAPI.zen.request(success: { (response) in
            debugPrint(response)
        }, progress: { (progress) in
            debugPrint(progress)
        }) { (error) in
            debugPrint(error)
        }
        
        GitHubAPI.zen.requestJSON(success: { (json) in
            debugPrint(json)
        }, progress: { (progress) in
            debugPrint(progress)
        }) { (error) in
            debugPrint(error)
        }
        
    }
    
    func rxRequest() {
        
        GitHubAPI.zen.rx.request().subscribe(onSuccess: { (response) in
            debugPrint(response)
        }) { (error) in
            debugPrint(error)
        }.disposed(by: disposeBag)
        
        GitHubAPI.zen.rx.request().mapSwiftyJSON().subscribe(onSuccess: { (json) in
            debugPrint(json)
        }) { (error) in
            debugPrint(error)
        }.disposed(by: disposeBag)
        
    }
    
}

