//
//  BeaconManager.swift
//  Steds Care
//
//  Created by Erik Bautista on 10/30/21.
//

import Foundation
import CoreLocation
import SPPermissions
import SPPermissionsLocationAlways

class MainBeaconManager: NSObject, BeaconManagerProtocol{
    static var shared: BeaconManagerProtocol {
        return MainBeaconManager()
    }

    private override init() {
        super.init()
        locationManager.delegate = self

        if (locationManager.authorizationStatus != .authorizedAlways) {
            locationManager.requestAlwaysAuthorization()
        }
    }

    func getOrganizationBeacons() -> [Beacon] {
        return []
    }
    
    func startScan() {
    }
    
    func stopScan() {
    }
    
    private var locationManager = CLLocationManager()

    private var beaconRegion: CLBeaconRegion!
    private var identityConstraint: CLBeaconIdentityConstraint!

    let permissions: [SPPermissions.Permission] = [.locationAlways]
}

extension MainBeaconManager: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
        
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
    }

}
