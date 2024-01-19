//
//  AppDelegate.swift
//  Steds Care
//
//  Created by Erik Bautista on 10/29/21.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
 
        //these are the same paths they need to change to intersect only once 
//        let path1Coordinates : [Coordinate] = [(0,10),(10,10),(10,20),(10,30),(10,40),(10,50),(10,60),(20,60),(30,60),(40,60),(50,60),(60,60),(50,60),(40,60),(30,60),(20,60),(10,60),(10,50),(10,40),(10,30),(10,20),(10,10),(0,10)]
//        let path2Coordinates : [Coordinate] = [(0,10),(10,10),(10,20),(10,30),(10,40),(20,40),(30,40),(40,40),(30,40),(20,40),(10,40),(10,30),(10,20),(10,10),(0,10)]
//        let userPoints2 = Utilities.genPoints(coordinates: path2Coordinates)
//        let beacon1 = Beacon(id: UUID(), major: 0, minor: 0,latitude: 5.0, longitude: 3.0)
//        let beacon2 = Beacon(id: UUID(), major: 0, minor: 1,latitude: 3.0, longitude: 8.0)
//        let beacon3 = Beacon(id: UUID(), major: 0, minor: 2, latitude: 8.0, longitude: 8.0)
//        let beaconList = [beacon1, beacon2, beacon3]
//        let userPoints1 = Utilities.genPoints(coordinates: path1Coordinates, beaconList:beaconList)
//
//        let distanceDict1 = Utilities.genDistanceList(userPoints: userPoints1, beaconList: beaconList)
//        let distanceDict2 = Utilities.genDistanceList(userPoints: userPoints2, beaconList: beaconList)
//        let didCross = Utilities.comparePaths(path1: userPoints1, path2: userPoints2)
//        print(didCross)
//        print(distanceDict1)
//        print(distanceDict2)

        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All set!")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }

        UNUserNotificationCenter.current().delegate = self

        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}

// Allow showing notification at the beginning
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        print(userInfo)
        completionHandler([.banner,.sound])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                   didReceive response: UNNotificationResponse,
                                   withCompletionHandler completionHandler: @escaping () -> Void) {
           let userInfo = response.notification.request.content.userInfo
           // Print full message.
           print("tap on on forground app",userInfo)
           completionHandler()
       }
}
