//
//  CleanRequest.swift
//  CleanRequest
//
//  email：chongyangfly@163.com
//  QQ：1909295866
//  github：https://github.com/wangcy90
//  blog：http://wangcy90.github.io
//
//  Created by WangChongyang on 2018/6/23.
//  Copyright © 2018年 WangChongyang. All rights reserved.
//

import Moya
import Alamofire
import HandyJSON
import SwiftyJSON

public final class CleanRequest {
    
    public static var provider = MoyaProvider<MultiTarget>()
    
    public static func setManager(_ manager: Manager) {
        
        let plugins = provider.plugins
        
        provider = MoyaProvider<MultiTarget>(manager: manager, plugins: plugins)
        
    }
    
    public static func setPlugins(_ plugins: [PluginType]) {
        
        let manager = provider.manager
        
        provider = MoyaProvider<MultiTarget>(manager: manager, plugins: plugins)
        
    }
    
}

public extension TargetType {
    
    typealias Progress = (ProgressResponse) -> ()
    
    typealias Failure = (Error) -> ()
    
    @discardableResult
    public func request(success: ((Response) -> ())? = nil,
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
    public func requestJSON(success: ((JSON) -> ())? = nil,
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
    public func requestObject<T: HandyJSON>(path: String? = nil,
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
    public func requestObjectArray<T: HandyJSON>(path: String? = nil,
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

extension Moya.Response {
    
    func _mapSwiftyJSON() throws -> JSON {
        return try JSON(data: data)
    }
    
    func _mapObject<T: HandyJSON>(_ type: T.Type, path: String? = nil) throws -> T {
        guard let jsonString = String(data: data, encoding: .utf8),
            let object = JSONDeserializer<T>
                .deserializeFrom(json: jsonString, designatedPath: path) else {
                    throw MoyaError.stringMapping(self)
        }
        return object
    }
    
    func _mapObjectArray<T: HandyJSON>(_ type: T.Type, path: String? = nil) throws -> [T] {
        guard let jsonString = String(data: data, encoding: .utf8),
            let objectArray = JSONDeserializer<T>
                .deserializeModelArrayFrom(json: jsonString, designatedPath: path) as? [T] else {
                    throw MoyaError.stringMapping(self)
        }
        return objectArray
    }
    
}
