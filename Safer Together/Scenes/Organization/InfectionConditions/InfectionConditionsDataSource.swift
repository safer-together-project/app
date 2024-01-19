//
//  InfectionConditionDataSource.swift
//  Safer Together
//
//  Created by Erik Bautista on 2/21/22.
//

import Foundation
import APIKit
import UIKit


class InfectionConditionsDataSource: NSObject {

    private var source: [InfectionCondition] = []

    func fetchLatestData(organizationId: Int, callback: @escaping () -> Void) {
        let request = StedsCareAPI.FetchInfectionConditionsRequest(organizationId: organizationId)

        Session.send(request) { [weak self] result in
            switch result {
            case .success(let response):
                self?.source = response
            case .failure(let error):
                printError(error)
            }
            callback()
        }
    }

    func update(_ condition: InfectionCondition, at row: Int) {
        source[row] = condition

        let request = StedsCareAPI.UpdateInfectionConditionRequest(condition: condition)
        Session.send(request) { result in
            switch result {
            case .success(_):
                print("Updated Success!!!")
            case .failure(let error):
                print("Failed to update condition. \(error)")
            }
        }
    }

    func infectionCondition(at row: Int) -> InfectionCondition {
        return source[row]
    }
}

extension InfectionConditionsDataSource: UITableViewDataSource {
    static let infectionConditionsCellIdentifier = "InfectionConditionCell"

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        source.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InfectionConditionsDataSource.infectionConditionsCellIdentifier, for: indexPath)

        // Pass title to cell
        cell.textLabel?.text = source[indexPath.row].infection?.name ?? "Unknown"

        return cell
    }

}
