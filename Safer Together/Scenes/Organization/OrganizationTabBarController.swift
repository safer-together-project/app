//
//  OrganizationTabBarController.swift
//  Safer Together
//
//  Created by Erik Bautista on 2/21/22.
//

import UIKit

class OrganizationTabBarController: UITabBarController {
    var employee: Employee!

    override func viewDidLoad() {
        super.viewDidLoad()
        for vc in viewControllers ?? [] {
            if let nav = vc as? UINavigationController {
                if let dash = nav.topViewController as? OrganizationInfectionConditionsViewController {
                    dash.employee = employee
                }
            }
        }
    }
}
