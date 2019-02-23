//
//  Moya.swift
//  iOS-todoApp
//
//  Created by 조세상 on 13/12/2018.
//  Copyright © 2018 조세상. All rights reserved.
//

import Moya
import Foundation
enum MyService {
    case zen
    case showUser(id: Int)
}
extension MyService : TargetType {
    var baseURL: URL {return URL(string: "https://api.myservice.com")! }
    
    var path : String {
        switch self {
        case .zen:
            return "/zen"
        case .showUser(let id):
            return "/users/\(id)"
        }
    }
    var method : Moya.Method {
        switch self {
        case .zen:
            return .get
        default:
            return .get
        }
    }
    var task : Task {
        switch self {
        case .zen, .showUser :
            return .requestPlain
        }
    }
    var sampleData : Data{
        switch self {
        case .zen:
            return "Hello World, Tedious Boy!".utf8Encoded
        case .showUser(let id):
            return "{\"id\": \(id), \"first_name\": \"Harry\", \"last_name\": \"Potter\"}".utf8Encoded
        
        }
    }
    var headers : [String : String]? {
        return ["Content-type": "application/json"]
    }
}

private extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}


