//
//  DummyBeaconManager.swift
//  Steds Care
//
//  Created by Erik Bautista on 11/27/21.
//

import Foundation

class DummyBeaconManager: NSObject, BeaconManagerProtocol {
    static var shared: BeaconManagerProtocol { return DummyBeaconManager() }

    private override init() {
        super.init()
    }

    func getOrganizationBeacons() -> [Beacon] {
        let beacon1 = Beacon(id: UUID(uuidString: "373FDC08-3996-40AC-BC00-C3BFDD3BD129"),
                             major: 0,
                             minor: 0,
                             organizationId: 1,
                             status: 0,
                             latitude: 2,
                             longitude: 2)

//        let beacon2 = Beacon(id: UUID(uuidString: "F84FFD41-452E-493C-9B97-5485B56C68F1"),
//                             major: 0,
//                             minor: 1,
//                             organizationId: 10,
//                             status: 0,
//                             latitude: 30.0,
//                             longitude: 80.0)
//
//        let beacon3 = Beacon(id: UUID(uuidString: "39500C7E-8FFC-45E1-BE09-5603D4C79C9D"),
//                             major: 0,
//                             minor: 2,
//                             organizationId: 10,
//                             status: 0,
//                             latitude: 80.0,
//                             longitude: 80.0)

        return [beacon1]
    }
    
    func startScan() {
    }

    func stopScan() {
    }
}
