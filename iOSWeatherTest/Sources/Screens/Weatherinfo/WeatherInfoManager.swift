//
//  WeatherInfoManager.swift
//  iOSWeatherTest
//
//  Created by Dmytro Hrebeniuk on 8/19/18.
//  Copyright © 2018 Dmytro. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation

class WeatherInfoManager {
    
    var client = OpenWeatherClient()
    
    private(set) var managedContext: NSManagedObjectContext?
    
    func setup() {
        managedContext = createManagedObjectContenxt()
    }
    
    func loadInfo(coordinate: CLLocationCoordinate2D) {
        client.requestWeatherInfo(latitude: coordinate.latitude, longitude: coordinate.longitude) { responseResult in
            switch responseResult {
            case .success(let locationInfo):
                break
            case .error(_):
                break
            }
        }
    }
}

extension WeatherInfoManager {
    
    private func createManagedObjectContenxt() -> NSManagedObjectContext {
        let storageURL = try! FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("PostsDataModel.sqlite")
        
        guard let managedModelURL = Bundle.main.url(forResource: "WeatherDataModel", withExtension: "momd") else { fatalError() }
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: managedModelURL) else { fatalError() }
        
        return try! NSManagedObjectContext.managedObjectContext(atURL: storageURL, withModel: managedObjectModel)
    }
}
