//
//  EditInfectionConditionDataSource.swift
//  Safer Together
//
//  Created by Erik Bautista on 2/21/22.
//

import Foundation
import UIKit

class EditInfectionConditionDataSource: NSObject {
    typealias ConditionChangeAction = (InfectionCondition) -> Void

    enum ConditionSection: Int, CaseIterable {
        case maskRequired
        case distance
        case duration

        var displayText: String {
            switch self {
            case .maskRequired:
                return "Mask Required"
            case .distance:
                return "Distance"
            case .duration:
                return "Duration"
            }
        }

        var numRows: Int {
            switch self {
            case .maskRequired, .distance, .duration:
                return 1
            }
        }

        func cellIdentifier(for row: Int) -> String {
            switch self {
            case .maskRequired:
                return "EditMaskRequiredCell"
            case .distance:
                return "EditDistanceCell"
            case .duration:
                return "EditDurationCell"
            }
        }
    }
    
    static let identifier = "editinfectioncoditioncell"

    var condition: InfectionCondition

    private var conditionChangeAction: ConditionChangeAction?


    init(condition: InfectionCondition, changeAction: @escaping ConditionChangeAction) {
        self.condition = condition
        self.conditionChangeAction = changeAction
    }
}

extension EditInfectionConditionDataSource {
    private func dequeueAndConfigCell(for indexPath: IndexPath, from tableView: UITableView) -> UITableViewCell {
        guard let section = ConditionSection(rawValue: indexPath.section) else {
            fatalError("Section index out of range")
        }
        let identifier = section.cellIdentifier(for: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        
        switch section {
        case .maskRequired:
            if let requiredCell = cell as? EditMaskRequiredCell {
                requiredCell.configure(on: condition.maskRequired) { on in
                    self.condition.maskRequired = on
                    self.conditionChangeAction?(self.condition)
                }
            }
        case .duration:
            if let requiredCell = cell as? EditDurationCell {
                requiredCell.configure(duration: condition.duration) { duration in
                    self.condition.duration = Double(duration) ?? 3600
                    self.conditionChangeAction?(self.condition)
                }
            }
        case .distance:
            if let requiredCell = cell as? EditDistanceCell {
                requiredCell.configure(distance: condition.distance) { distance in
                    self.condition.distance = Double(distance) ?? 3
                    self.conditionChangeAction?(self.condition)
                }
            }
        }
        return cell

    }
}


extension EditInfectionConditionDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return ConditionSection.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ConditionSection(rawValue: section)?.numRows ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return dequeueAndConfigCell(for: indexPath, from: tableView)
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let section = ConditionSection(rawValue: section) else {
            fatalError("Section index out of range")
        }
        return section.displayText
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}
