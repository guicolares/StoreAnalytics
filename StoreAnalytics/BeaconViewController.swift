//
//  BeaconViewController.swift
//  StoreAnalytics
//
//  Created by Guilherme Leite Colares on 5/7/15.
//  Copyright (c) 2015 Guilherme Leite Colares. All rights reserved.
//

import UIKit
import CoreLocation

class BeaconViewController: UIViewController, CLLocationManagerDelegate {
    var beaconsFaound:CLBeacon = CLBeacon()
    let locationManager:CLLocationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
    }
    
    
    override func viewDidDisappear(animated: Bool) {
        locationManager.stopMonitoringForRegion(nil)
    }
}
