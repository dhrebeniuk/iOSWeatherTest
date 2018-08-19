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
    
    func loadInfo(coordinate: CLLocationCoordinate2D, completion: @escaping (_ weatherItem: WeatherItem?, _ error: Error?) -> ()) {
        client.requestWeatherInfo(latitude: coordinate.latitude, longitude: coordinate.longitude) { [weak self] responseResult in
            var networkError: Error? = nil

            switch responseResult {
            case .success(let locationInfo):
                self?.save(coordinate: coordinate, weatherInfo: locationInfo)
                break
            case .error(let error):
                networkError = error
                break
            }
            
            DispatchQueue.main.async {
                self?.createFrechRequest(coordinate: coordinate).map() {
                    var weatherInfo: WeatherItem? = nil
                    do {
                        weatherInfo = try self?.managedContext?.fetch($0).first
                    }
                    catch {
                        
                    }
                    completion(weatherInfo, networkError)
                }
            }
        }
    }
    
    private func save(coordinate: CLLocationCoordinate2D, weatherInfo: CoordinateWeatherInfoJSON) {
        _ = self.managedContext.flatMap() { managedContext -> NSManagedObjectContext in
            let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            context.parent = managedContext
            return context
        }.map() { managedContext in
            WeatherItem.entity().name.map() {
                var weatherItem: WeatherItem?
                    
                do {
                  weatherItem = try managedContext.fetchManagedObject(entityName: $0, uniqueItems: [(key: #keyPath(WeatherItem.longitude), value: NSNumber(value: coordinate.longitude)),
                    (key: #keyPath(WeatherItem.latitude), value: NSNumber(value: coordinate.latitude))]) as? WeatherItem
                }
                catch {
                    
                }
                
                if (weatherItem == nil) {
                    weatherItem = NSEntityDescription.insertNewObject(forEntityName: $0, into:managedContext) as? WeatherItem
                }
                
                weatherItem?.weatherDetails = weatherInfo.weather.first?.description
                weatherItem?.humidity = weatherInfo.main.humidity
                weatherItem?.temperature = weatherInfo.main.temp
                weatherItem?.pressure = weatherInfo.main.pressure
                weatherItem?.latitude = coordinate.latitude
                weatherItem?.longitude = coordinate.longitude
            }
            
            try? managedContext.save()
        }
    }

    func createFrechRequest(coordinate: CLLocationCoordinate2D) -> NSFetchRequest<WeatherItem>? {
        return WeatherItem.entity().name.flatMap() { name -> NSFetchRequest<WeatherItem>? in
            return (managedContext?.fetchRequest(entityName: name, uniqueItems: [(key: #keyPath(WeatherItem.longitude), value: NSNumber(value: coordinate.longitude)), (key: #keyPath(WeatherItem.latitude), value: NSNumber(value: coordinate.latitude))]))
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
