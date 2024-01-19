//
//  BeaconManagerProtocol.swift
//  Steds Care
//
//  Created by Erik Bautista on 11/19/21.
//

import Foundation

protocol BeaconManagerProtocol {
    static var shared: BeaconManagerProtocol { get }
    func startScan()
    func stopScan()
    func getOrganizationBeacons() -> [Beacon]
}
