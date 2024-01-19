//
//  OrganizationManager.swift
//  Steds Care
//
//  Created by Erik Bautista on 11/27/21.
//

import Foundation

class OrganizationManager: NSObject {
    public static var shared = OrganizationManager()

    private override init() {}

    public func getOrganization() -> Organization {
        return Organization(id: 1, accessCode: "STEDS0", name: "St. Edward's University")
    }
}
