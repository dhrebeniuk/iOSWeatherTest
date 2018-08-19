//
//  OpenWeatherClient.swift
//  iOSWeatherTest
//
//  Created by Dmytro Hrebeniuk on 8/19/18.
//  Copyright © 2018 Dmytro. All rights reserved.
//

import Foundation

public enum RequestResult<T> {
    case success(T)
    case error(Error)
    
    public var success: Bool {
        switch self {
        case .success:
            return true
        case .error:
            return false
        }
    }
}

public typealias RequestResultCompletion<T> = (_ result: RequestResult<T>) -> ()


class OpenWeatherClient {
    
    static let shared = OpenWeatherClient()
    
    var webAPIURL: URL { get {
        return URL(string: "api.openweathermap.org/data/2.5")!
        }
    }
    
}

extension OpenWeatherClient {
    
}

