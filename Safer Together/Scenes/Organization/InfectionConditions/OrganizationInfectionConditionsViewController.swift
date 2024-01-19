//
//  OrganizationInfectionConditionsViewController.swift
//  Steds Care
//
//  Created by Erik Bautista on 11/15/21.
//

import Foundation
import UIKit
import APIKit

class OrganizationInfectionConditionsViewController: UITableViewController {
    var employee: Employee!

    private var infectionConditionsDataSource: InfectionConditionsDataSource?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Welcome \(employee.firstName)"

        tableView.allowsMultipleSelection = false

        infectionConditionsDataSource = .init()
        tableView.dataSource = infectionConditionsDataSource

        let refreshControl = UIRefreshControl(frame: .zero, primaryAction: UIAction(handler: { [unowned self] _ in
            fetchData()
        }))

        self.refreshControl = refreshControl
    }

    private func fetchData() {
        infectionConditionsDataSource?.fetchLatestData(organizationId: employee.organizationId, callback: { [weak self] in
            self?.refreshControl?.endRefreshing()
            self?.tableView.reloadData()
        })
    }
    
    static let showDetailSegueIdentifier = "ShowConditionDetailSegue"

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Self.showDetailSegueIdentifier,
           let destination = segue.destination as? InfectionConditionDetailViewController,
           let cell = sender as? UITableViewCell,
           let indexPath = tableView.indexPath(for: cell) {

            let rowIndex = indexPath.row
            guard let condition = infectionConditionsDataSource?.infectionCondition(at: rowIndex) else {
                fatalError("Couldn't find data source for reminder list.")
            }
            destination.configure(with: condition) { [weak self] newCondition in
                self?.infectionConditionsDataSource?.update(newCondition, at: indexPath.row)
                self?.tableView.reloadData()
            }
        }
    }
}
