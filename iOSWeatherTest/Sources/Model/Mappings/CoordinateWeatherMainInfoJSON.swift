//
//  CoordinateWeatherMainInfoJSON.swift
//  iOSWeatherTest
//
//  Created by Dmytro Hrebeniuk on 8/19/18.
//  Copyright © 2018 Dmytro. All rights reserved.
//

import Foundation

struct CoordinateWeatherMainInfoJSON: Decodable {
    
    let grnd_level: Double
    let humidity: Double

    let pressure: Double
    let sea_level: Double
    let temp: Double
    let temp_max: Double
    let temp_min: Double

}
