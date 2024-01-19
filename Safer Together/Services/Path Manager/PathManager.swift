//
//  PathManager.swift
//  Steds Care
//
//  Created by Erik Bautista on 11/26/21.
//

import Foundation

class PathManager {
    private init() {}

    static var shared = PathManager()

    var pointOption: Int = 1

    func getLocalPath() -> Path {
        if pointOption == 1 {
            return Utilities.userPath1(beaconList: DummyBeaconManager.shared.getOrganizationBeacons())
        } else {
            return Utilities.userPath2(beaconList: DummyBeaconManager.shared.getOrganizationBeacons())
        }
    }
}
