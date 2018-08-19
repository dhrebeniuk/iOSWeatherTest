//
//  OpenWeatherClient.swift
//  iOSWeatherTest
//
//  Created by Dmytro Hrebeniuk on 8/19/18.
//  Copyright © 2018 Dmytro. All rights reserved.
//

import Foundation
import Alamofire

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
        return URL(string: "https://api.openweathermap.org/data/2.5")!
        }
    }
    
    private static let appId = "bdd55e2dad33397fb359fe81db2e5880"
}

extension OpenWeatherClient {
    
    public func requestWeatherInfo(latitude: Double, longitude: Double, completion: @escaping RequestResultCompletion<CoordinateWeatherInfoJSON>) {
        let url = self.webAPIURL.appendingPathComponent("weather")
        
        Alamofire.request(url, method: .get, parameters: ["lat":latitude, "lon": longitude, "appid": OpenWeatherClient.appId]).responseData { (response) in
            switch response.result {
            case .success(let jsonData):
                let decoder = JSONDecoder()
                do {
                    let weatherInfo = try decoder.decode(CoordinateWeatherInfoJSON.self, from: jsonData)
                    completion(RequestResult<CoordinateWeatherInfoJSON>.success(weatherInfo))
                }
                catch {
                    completion(RequestResult<CoordinateWeatherInfoJSON>.error(error))
                }
            case .failure(let error):
                completion(RequestResult<CoordinateWeatherInfoJSON>.error(error))
            }
        }
    }
    
}

