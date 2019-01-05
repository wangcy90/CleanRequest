//
//  GitHubAPI.swift
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

import Moya

enum GitHubAPI {
    case zen
}

extension GitHubAPI: TargetType {
    
    var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }
    
    var path: String {
        switch self {
        case .zen:
            return "/zen"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Task {
        switch self {
        case .zen:
            return .requestPlain
        }
    }
    
    var validationType: ValidationType {
        switch self {
        case .zen:
            return .successCodes
        }
    }
    
    var sampleData: Data {
        switch self {
        case .zen:
            return "Half measures are as bad as nothing at all.".data(using: String.Encoding.utf8)!
        }
    }
    
    var headers: [String: String]? {
        return nil
    }
    
}
