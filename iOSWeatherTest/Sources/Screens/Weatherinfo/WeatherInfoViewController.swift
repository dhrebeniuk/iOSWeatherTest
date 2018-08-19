//
//  WeatherInfoViewController.swift
//  iOSWeatherTest
//
//  Created by Dmytro Hrebeniuk on 8/19/18.
//  Copyright © 2018 Dmytro. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherInfoViewController: UITableViewController {

    var coordinate: CLLocationCoordinate2D?

    var weatherInfoManager = WeatherInfoManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        weatherInfoManager.setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        coordinate.map() { weatherInfoManager.loadInfo(coordinate: $0) }
    }

}
