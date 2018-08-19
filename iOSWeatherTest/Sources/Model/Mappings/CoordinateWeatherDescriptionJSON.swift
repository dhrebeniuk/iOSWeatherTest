//
//  CoordinateWeatherDescriptionJSON.swift
//  iOSWeatherTest
//
//  Created by Dmytro Hrebeniuk on 8/19/18.
//  Copyright © 2018 Dmytro. All rights reserved.
//

import Foundation

struct CoordinateWeatherDescriptionJSON: Decodable {
    
    let description: String
    let main: String
}
