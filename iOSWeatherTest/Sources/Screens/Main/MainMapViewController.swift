//
//  MainMapViewController.swift
//  iOSWeatherTest
//
//  Created by Dmytro Hrebeniuk on 8/19/18.
//  Copyright © 2018 Dmytro. All rights reserved.
//

import UIKit
import MapKit
import SegueWithCompletion

class MainMapViewController: UIViewController {

    private let showWeatherDetailsSegue = "showWeatherDetailsSegue"
    
    @IBOutlet weak var mapView: MKMapView?
    @IBOutlet var doubleTapGestureRecogniser: UITapGestureRecognizer?

    @IBAction func doubleTapAction(_ sender: Any) {
        let location = doubleTapGestureRecogniser?.location(in: mapView)

        _ = location.map {
            self.mapView?.convert($0, toCoordinateFrom: self.mapView)
        }.map() {  location in
            self.performWithNavigationController(segue: showWeatherDetailsSegue) { (weatherDetailsViewController: UIViewController) in
                
            }
        }
    }
}
