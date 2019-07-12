//
//  CleanRequest+Rx.swift
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
import RxSwift
import HandyJSON
import SwiftyJSON

public extension Reactive where Base: RequestTargetType {
    
    func request() -> Single<Response> {
        return Single.just(MultiTarget(base)).flatMap { CleanRequest.provider.rx.request($0) }
    }
    
}

public extension PrimitiveSequence where TraitType == SingleTrait, ElementType == Moya.Response {
    
    func mapSwiftyJSON() -> Single<JSON> {
        return flatMap { response -> Single<JSON> in
            return .just(try response._mapSwiftyJSON())
        }
    }
    
    func mapObject<T: HandyJSON>(_ type: T.Type, path: String? = nil) -> Single<T> {
        return flatMap { response -> Single<T> in
            return .just(try response._mapObject(T.self, path: path))
        }
    }
    
    func mapObjectArray<T: HandyJSON>(_ type: T.Type, path: String? = nil) -> Single<[T]> {
        return flatMap { response -> Single<[T]> in
            return .just(try response._mapObjectArray(T.self, path: path))
        }
    }
    
}

public extension PrimitiveSequence where TraitType == SingleTrait, ElementType == JSON {
    
    func mapObject<T: HandyJSON>(_ type: T.Type, path: String? = nil) -> Single<T> {
        return flatMap { json -> Single<T> in
            return .just(try json._mapObject(T.self, path: path))
        }
    }
    
    func mapObjectArray<T: HandyJSON>(_ type: T.Type, path: String? = nil) -> Single<[T]> {
        return flatMap { json -> Single<[T]> in
            return .just(try json._mapObjectArray(T.self, path: path))
        }
    }
    
}

extension JSON {
    
    func _mapObject<T: HandyJSON>(_ type: T.Type, path: String? = nil) throws -> T {
        guard let model = JSONDeserializer<T>
            .deserializeFrom(dict: dictionaryObject, designatedPath: path) else {
                throw JSONMapError.objectMapping
        }
        return model
    }
    
    func _mapObjectArray<T: HandyJSON>(_ type: T.Type, path: String? = nil) throws -> [T] {
        guard let modelArray = JSONDeserializer<T>
            .deserializeModelArrayFrom(json: rawString(), designatedPath: path) as? [T] else {
                throw JSONMapError.objectArrayMapping
        }
        return modelArray
    }
    
}

enum JSONMapError: LocalizedError {
    
    case objectMapping
    case objectArrayMapping
    
    public var errorDescription: String? {
        switch self {
        case .objectMapping:
            return "Failed to map data to object."
        case .objectArrayMapping:
            return "Failed to map data to objectArray."
        }
    }
    
}
