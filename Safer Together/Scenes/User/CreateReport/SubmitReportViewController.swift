//
//  SubmitReportViewController.swift
//  Steds Care
//
//  Created by Erik Bautista on 11/22/21.
//

import Foundation
import UIKit
import APIKit

class SubmitReportViewController: UIViewController {
    @IBOutlet weak var circularView: UIView!

    var infectionCondition: InfectionCondition!

    let reportRepository = Application.shared.services.makeReportsRepository()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        circularView.backgroundColor = PathManager.shared.pointOption == 1 ? .systemGreen : .systemOrange
        circularView.layer.cornerRadius = circularView.bounds.height / 2
    }

    override func viewDidLoad() {
        let organization = OrganizationManager.shared.getOrganization()
        let path = PathManager.shared.getLocalPath()

        let report = Report(
            organizationId: organization.id,
            infectionConditionId: self.infectionCondition.id,
            created: Date(),
            path: path
        )

        DispatchQueue.global().async {
            let request = StedsCareAPI.SubmitReportRequest(report: report)

            _ = Session.send(request) { result in
                switch result {
                case .success(let newReport):
                    let reportDomain = ReportDomain(
                        id: newReport.id,
                        organizationId: report.organizationId,
                        infectionConditionId: report.infectionConditionId,
                        created: report.created,
                        infectionName: self.infectionCondition.infection?.name ?? "Unknown",
                        infectionTypeValue: self.infectionCondition.infection?.type ?? .unknown
                    )

                    let repositoryResult = self.saveToRepository(report: reportDomain)

                    switch repositoryResult {
                    case .success(()):
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: "Success", message: "Report has been submitted successfully", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Close", style: .default, handler: {_ in
                                self.navigationController?.popToRootViewController(animated: true)
                            }))
                            self.present(alert, animated: true)
                        }

                    case .failure(let error):
                        print(error)
                        let alert = UIAlertController(title: "Failed to add report.", message: "There was an error adding to database.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
                        self.present(alert, animated: true)
                    }

                case .failure(let error):
                    printError(error)
                    let alert = UIAlertController(title: "Failed to submit report.", message: "There was an error sending to the server.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
            }
        }
    }

    private func saveToRepository(report: ReportDomain) -> Result<Void, Error> {
        return reportRepository.save(report: report)
    }
}
