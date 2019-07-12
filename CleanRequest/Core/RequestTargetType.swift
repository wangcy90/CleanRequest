//
//  RequestTargetType.swift
//  CleanRequest
//
//  email：chongyangfly@163.com
//  QQ：1909295866
//  github：https://github.com/wangcy90
//  blog：http://wangcy90.github.io
//
//  Created by WangChongyang on 2019/7/12.
//  Copyright © 2018年 WangChongyang. All rights reserved.
//

import Moya
import HandyJSON
import SwiftyJSON

#if canImport(RxSwift)

import RxSwift

public protocol RequestTargetType: TargetType, ReactiveCompatible {}

#else

public protocol RequestTargetType: TargetType {}

#endif

public extension RequestTargetType {
    
    typealias Progress = (ProgressResponse) -> ()
    
    typealias Failure = (Error) -> ()
    
    @discardableResult
    func request(success: ((Response) -> ())? = nil,
                 progress: Progress? = nil,
                 failure: Failure? = nil) -> Cancellable {
        
        return CleanRequest.provider.request(MultiTarget(self), progress: progress) {
            
            switch $0 {
            case let .success(response):
                success?(response)
            case let .failure(error):
                failure?(error)
            }
            
        }
        
    }
    
    @discardableResult
    func requestJSON(success: ((JSON) -> ())? = nil,
                     progress: Progress? = nil,
                     failure: Failure? = nil) -> Cancellable {
        
        return request(success: {
            
            do {
                success?(try $0._mapSwiftyJSON())
            }catch {
                failure?(error)
            }
            
        }, progress: progress, failure: failure)
        
    }
    
    @discardableResult
    func requestObject<T: HandyJSON>(path: String? = nil,
                                     success: ((T) -> ())? = nil,
                                     progress: Progress? = nil,
                                     failure: Failure? = nil) -> Cancellable {
        
        return request(success: {
            
            do {
                success?(try $0._mapObject(T.self, path: path))
            }catch {
                failure?(error)
            }
            
        }, progress: progress, failure: failure)
        
    }
    
    @discardableResult
    func requestObjectArray<T: HandyJSON>(path: String? = nil,
                                          success: (([T]) -> ())? = nil,
                                          progress: Progress? = nil,
                                          failure: Failure? = nil) -> Cancellable {
        
        return request(success: {
            
            do {
                success?(try $0._mapObjectArray(T.self, path: path))
            }catch {
                failure?(error)
            }
            
        }, progress: progress, failure: failure)
        
    }
    
}
