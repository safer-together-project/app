//
//  DetailInfectionConditionDataSource.swift
//  Safer Together
//
//  Created by Erik Bautista on 2/21/22.
//

import Foundation
import UIKit

class DetailInfectionConditionDataSource: NSObject {
    static let identifier = "detailinfectioncoditioncell"

    let condition: InfectionCondition

    init(condition: InfectionCondition) {
        self.condition = condition
    }
}


extension DetailInfectionConditionDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: DetailInfectionConditionDataSource.identifier, for: indexPath)
    }
}
