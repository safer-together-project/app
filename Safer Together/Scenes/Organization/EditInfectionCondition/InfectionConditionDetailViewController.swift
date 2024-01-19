//
//  InfectionConditionDetailViewController.swift
//  Safer Together
//
//  Created by Erik Bautista on 2/21/22.
//

import Foundation
import UIKit

class InfectionConditionDetailViewController: UITableViewController {
    typealias ConditionChangeAction = (InfectionCondition) -> Void

    private var condition: InfectionCondition?
    private var tempCondition: InfectionCondition?
    private var dataSource: UITableViewDataSource?
    private var conditionChangeAction: ConditionChangeAction?

    func configure(with condition: InfectionCondition, changeAction: @escaping ConditionChangeAction) {
        self.condition = condition
        self.conditionChangeAction = changeAction
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        setEditing(false, animated: false)
        navigationItem.backButtonTitle = "Dashboard"
//        navigationItem.setRightBarButton(editButtonItem, animated: false)
        navigationItem.largeTitleDisplayMode = .never
//    }
//
//    override func setEditing(_ editing: Bool, animated: Bool) {
//        super.setEditing(editing, animated: animated)
//
        guard let condition = condition else {
            return
        }
//
//        if editing {
            dataSource = EditInfectionConditionDataSource(condition: condition, changeAction: { [weak self] val in
                self?.conditionChangeAction?(val)
//                self.tempCondition = val
//                self.editButtonItem.isEnabled = true
            })
//            navigationItem.title = "Edit Condition for \(condition.infection?.name ?? "")"
//            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTrigger))
//        } else {
//            if let tempCondition = tempCondition {
//                self.condition = condition
//                self.tempCondition = nil
//                conditionChangeAction?(tempCondition)
//                dataSource = DetailInfectionConditionDataSource(condition: tempCondition)
//            } else {
//                dataSource = DetailInfectionConditionDataSource(condition: condition)
//            }
//            navigationItem.title = "View Condition"
//            navigationItem.leftBarButtonItem = nil
//            editButtonItem.isEnabled = true
//        }
//
        tableView.dataSource = dataSource
        tableView.reloadData()
    }

//    @objc
//    func cancelButtonTrigger() {
//        tempCondition = nil
//        setEditing(false, animated: true)
//    }
}
