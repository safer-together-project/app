//
//  Utilities.swift
//  Steds Care
//
//  Created by Turing on 11/15/21.
//

import Foundation

//

//
import UIKit
import CoreGraphics

typealias Coordinate = (latitude: Double, longitude: Double)

class Utilities: NSObject {

    static func normValue(coordinate: Coordinate) -> Double {
        var norm:Double?
        norm = (pow(pow(coordinate.latitude, 2) + pow(coordinate.longitude, 2) , 0.5))
        return norm!
    }
    

    static func findDistance(point1: Coordinate, point2: Coordinate) -> Double {
        let xdist = pow((point1.latitude - point2.latitude),2.0)
        let ydist = pow((point1.longitude - point2.longitude),2.0)
        let dist = pow((xdist + ydist), 0.5)
        return dist
    }

    static func userPath1(beaconList: [Beacon]) -> Path {
        //create the traveled coordinates  for the user along sin(x) + 2
        var coordinateList : [Coordinate] = []

        for x in stride(from: 0.0, to: (2 * Double.pi), by: (Double.pi/2)){
            let y = sin(x) + 2.0
            coordinateList.append((x,y))
        }
        let userPath = createPath(coordinateList: coordinateList, beaconList: beaconList)
        return userPath
    }

    static func userPath2(beaconList : [Beacon]) -> Path {
        //create the traveled coordinates  for the user along sin(x) + 2
        var coordinateList : [Coordinate] = []
        
        for x in stride(from: 0.0, to: (2 * Double.pi), by: (Double.pi/2)){
            let y = 2.0
            coordinateList.append((x,y))
        }
        let userPath = createPath(coordinateList: coordinateList, beaconList: beaconList)
        return userPath
    }
    
    static func createPath(coordinateList : [Coordinate], beaconList : [Beacon]) -> Path {
        let date = Date()
        var userPath = Path(date: date)

        var pointId = 0 //change to UUID

        for coord in coordinateList {
            let initialDate = date
            let date = initialDate.addingTimeInterval(65 * 60)

            let sorted = beaconList.sorted(by: { firstBeacon, secondBeacon in
                let firstBeaconCoordinate: Coordinate =  (firstBeacon.latitude, firstBeacon.longitude)
                let firstDist = findDistance(point1: coord, point2: firstBeaconCoordinate)

                let secondBeaconCoordinate: Coordinate =  (secondBeacon.latitude, secondBeacon.longitude)
                let secondDist = findDistance(point1: coord, point2: secondBeaconCoordinate)

                return firstDist > secondDist
            })

            let closestBeacon  = sorted.first

            let p : Point = Point(
                id: pointId,
                beaconId: closestBeacon!.id!,
                beaconMajor: closestBeacon!.major!,
                beaconMinor: closestBeacon!.minor!,
                latitude: coord.latitude,
                longitude: coord.longitude,
                initialTimestamp: initialDate,
                finalTimestamp: date
            )
            pointId = pointId + 1
            
            userPath.points.append(p)
        }
        return userPath
    }

    
//    struct Infection {
//        var id: Int64
//        var name: String
//        var type: InfectionType
//        var mandateMask: Bool
//        var distance: Double
//        var duration: Double
//        var description: String
//
    static func comparePaths(path1: Path, path2: Path, condition: InfectionCondition ) -> (Bool, Date?, Double?) {
        let calendar = Calendar.current
        var date1:Date
        var date2:Date
        
        date1 = path1.date
        date2 = path2.date
        
        
        let path_one_day = calendar.component(.day, from: date1)
        let path_two_day = calendar.component(.day, from: date2)
        let path_one_month = calendar.component(.month, from: date1)
        let path_two_month = calendar.component(.month, from: date2)
        
        //check if dates for path are the same
        if (path_one_day == path_two_day) && (path_one_month == path_two_month) {
            //set up for comparison of paths so we dont deal with negative time
            if date1 < date2 {
                date2 = date1
                date1 = date2
            }
            for uPoint in path1.points {
                for iPoint in path2.points {
                    // distance check
                    let d : Double = findDistance(point1: (uPoint.latitude,uPoint.longitude), point2: (iPoint.latitude,iPoint.longitude))
                    if d <= condition.distance {
                        let uhour = calendar.component(.hour, from: date1)
                        let ihour = calendar.component(.hour, from: date2)
                        
                        let ifinalhour = calendar.component(.hour, from: date2)

                        //check if dates falls in range of upoint initial and final
                        if uhour >= ihour && uhour <= ifinalhour {
                            //might need to check timezone
                            let duration1 = uPoint.finalTimestamp.timeIntervalSince(uPoint.initialTimestamp)
                            let duration2 = iPoint.finalTimestamp.timeIntervalSince(iPoint.initialTimestamp)
                            if duration1 >= condition.duration && duration2 >= condition.duration {
                                return (true, date1, duration1)
                            }
                        }
                    }
                }
            }
        }
        return (false, nil, nil)
    }
    
    static func multilateration(coordinate: Coordinate, beacon: Beacon, r: Double) -> Coordinate {
        //for lines with slopes
        let p = beacon.latitude
        let q = beacon.longitude
        var intersection : Coordinate = ( p, q)
        if (coordinate.latitude - beacon.latitude) != 0 {
            let m : Double = (coordinate.longitude - beacon.longitude)/(coordinate.latitude - beacon.latitude)
            let c = -1*m*coordinate.latitude + coordinate.longitude
            let A = (pow(m,2) + 1)
            let B = 2*((m*c) - (m*q) - (p))
            let C = pow(q,2) - pow(r,2) + pow(p,2) - (2*c*q) + pow(c,2)
            
            // The positive root
            let posRootX: Double = (-B + (B*B - 4*A*C).squareRoot()) / (2*A)

            // The negative root
            let negRootX : Double = (-B - (B*B - 4*A*C).squareRoot()) / (2*A)
            
            var closestX: Double = 0.0
            if (abs(posRootX - coordinate.latitude) < abs(negRootX - coordinate.latitude)) {
                closestX = posRootX
            } else {
                closestX = negRootX
            }

            let y  = m*closestX + c

            intersection = (closestX, y)
        }
        else {
            let k = coordinate.latitude
            let A = 1.0
            let B = -2*q
            let C = pow(p,2) + pow(q,2) - pow(r,2) - (2*k*p) + pow(k,2)
            
            // The positive root for longitude value when x = beacon.latitude
            let posRootY: Double = (-B + (B*B - 4*A*C).squareRoot()) / (2*A)

            // The negative root for longitude value when x = beacon.latitude
            let negRootY : Double = (-B - (B*B - 4*A*C).squareRoot()) / (2*A)

            var closestY = 0.0

            if (abs(posRootY - coordinate.longitude) < abs(negRootY - coordinate.longitude)) {
                closestY = posRootY
            } else {
                closestY = negRootY
            }

            print("this is our closest y guesses: \(closestY)")
            
            let x  = p + r
            intersection = (x, closestY)
        }
        return intersection
    }

    
    // point1 is the closest to user
    //  Utilities.swift
    //  Trilateration
    //
    //  Created by Tharindu Ketipearachchi on 1/17/18.
    //  Copyright © 2018 Tharindu Ketipearachchi. All rights reserved.
    //  edited to fit project objects
    static func trilateration(beacon1: Beacon, beacon2: Beacon, beacon3: Beacon, r1: Double, r2:Double, r3: Double) -> Coordinate {

        //Unit vector in a direction from point1 to point 2
        let p1p2: Double = pow(pow(beacon2.latitude - beacon1.latitude, 2.0) + pow(beacon2.longitude - beacon1.longitude, 2.0), 0.5)
    
        let ex: Coordinate = ((beacon2.latitude - beacon1.latitude) / p1p2, (beacon2.longitude - beacon1.longitude) / p1p2)
        
        let aux: Coordinate = (beacon3.latitude - beacon1.latitude, beacon3.longitude - beacon1.longitude)
        
        //Signed magnitude of the x component
        let i: Double = ((ex.latitude) * (aux.latitude)) + ((ex.longitude) * aux.longitude)
        
        //The unit vector in the y direction.
        let aux2: Coordinate = (beacon3.latitude - beacon1.latitude - (i * (ex.latitude)), beacon3.longitude - beacon1.longitude - (i * (ex.longitude)))
        
        let ey: Coordinate = ((aux2.latitude) / self.normValue(coordinate: aux2), (aux2.longitude) / self.normValue(coordinate: aux2))
        
        //The signed magnitude of the y component
        let j:Double = Double((ey.latitude) * (aux.latitude)) + ((ey.longitude) * (aux.longitude))
        
        //Coordinates
        let x:Double = (pow(r1, 2) - pow(r2, 2) + pow(p1p2, 2)) / (2 * p1p2)
        let y:Double = ((pow(r1, 2) - pow(r3, 2) + pow(i, 2) + pow(j, 2))/(2 * j)) - (i * x/j)
        
        //Result coordinates
        let finalX:Double = beacon1.latitude + x * ex.latitude + y * (ey.latitude)
        let finalY:Double = beacon1.longitude + x * ex.longitude + y * (ey.longitude)
        
        let location: Coordinate = (finalX, finalY)
    
        return location
    }
    
    
}


extension CGAffineTransform {
    func transform(_ coordinate: Coordinate) -> Coordinate {
        var hahhahaha = Coordinate(0, 0)
        let omgX: CGFloat = (a * CGFloat(coordinate.latitude)) + (c * CGFloat(coordinate.longitude)) + tx
        let omgY: CGFloat = (b * CGFloat(coordinate.latitude)) + (d * CGFloat(coordinate.longitude)) + ty
        hahhahaha.latitude = Double(omgX)
        hahhahaha.longitude = Double(omgY)
        return hahhahaha
    }
    

}
