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

    @IBOutlet private weak var coordinateLabel: UILabel?
    @IBOutlet private weak var humidityLabel: UILabel?
    @IBOutlet private weak var temperatureLabel: UILabel?
    @IBOutlet private weak var weatherDescriptionLabel: UILabel?
    
    var coordinate: CLLocationCoordinate2D?

    var weatherInfoManager = WeatherInfoManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        weatherInfoManager.setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        coordinate.map() { weatherInfoManager.loadInfo(coordinate: $0) { [weak self] weatherInfo, error in
            
            weatherInfo.map() { self?.updateUI(weatherItem: $0) }
            
            }
        }
    }
    
    private func updateUI(weatherItem: WeatherItem) {
        coordinateLabel?.text = "\(NSLocalizedString("Latitude", comment: "")): \(weatherItem.latitude)\n\(NSLocalizedString("Longtitude", comment: "")): \(weatherItem.longitude)"
        
        humidityLabel?.text = "\(NSLocalizedString("Humidity", comment: "")): \(weatherItem.humidity)"

        temperatureLabel?.text = "\(NSLocalizedString("Temperature: ", comment: "")): \(weatherItem.temperature)"
        
        weatherDescriptionLabel?.text = weatherItem.weatherDetails ?? ""
        
        tableView.setNeedsDisplay()
    }

}
