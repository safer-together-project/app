//
//  UserDashboard.swift
//  Steds Care
//
//  Created by Erik Bautista on 11/15/21.
//

import UIKit
import APIKit

let reportsRepository = Application.shared.services.makeReportsRepository()
let exposedRepository = Application.shared.services.makeExposuresRepository()

class UserDashboardViewController: UIViewController {
    @IBOutlet weak var createReportButton: CardButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var circularView: UIView!
    @IBOutlet weak var pathSegment: UISegmentedControl!
}

extension UserDashboardViewController {
    @objc func handlePath1Clicked() {
        print("Path 1 clicked")
        PathManager.shared.pointOption = 1
        circularView.backgroundColor = .systemGreen
    }

    @objc func handlePath2Clicked() {
        print("Path 2 clicked")
        PathManager.shared.pointOption = 2
        circularView.backgroundColor = .systemOrange
    }
}

extension UserDashboardViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        circularView.backgroundColor = PathManager.shared.pointOption == 1 ? .systemGreen : .systemOrange
        circularView.layer.cornerRadius = circularView.bounds.height / 2

        pathSegment.setAction(.init(handler: { [self] action in
            self.handlePath1Clicked()
        }), forSegmentAt: 0)
        pathSegment.setTitle("Path 1", forSegmentAt: 0)
        pathSegment.setAction(.init(handler: { [self] action in
            self.handlePath2Clicked()
        }), forSegmentAt: 1)
        pathSegment.setTitle("Path 2", forSegmentAt: 1)

        let refreshControl = UIRefreshControl(frame: .zero, primaryAction: UIAction(handler: { [weak self] _ in
            self?.fetchReports()
        }))

        scrollView.refreshControl = refreshControl
    }

    @objc private func fetchReports() {
        let organization = OrganizationManager.shared.getOrganization()

        let reportsRequest = StedsCareAPI.FetchReportsRequest(organization: organization)

        Session.send(reportsRequest) { [weak self] result in
            switch result {
            case .success(let response):
                self?.handleServerReports(serverReports: response)
            case .failure(let error):
                printError(error)
            }
            DispatchQueue.main.async {
                self?.scrollView.refreshControl?.endRefreshing()
            }
        }
    }

    private func handleServerReports(serverReports: [Report]) {
        // these are reports we want to filter out.

        var omitReportIds: Set<Int64> = []

        // Fetch self submitted reports. We do not want to notify user of reports they've submitted.

        let repositorySubmittedReports = reportsRepository.reports()

        switch repositorySubmittedReports {
        case .success(let repositoryReports):
            repositoryReports.compactMap({ $0.id }).forEach { omitReportIds.insert($0) }
        case .failure(_):
            break
        }

        // Fetch Exposed reports

        let repositoryExposedReports = exposedRepository.exposures()

        switch repositoryExposedReports {
        case .success(let repositoryExposed):
            repositoryExposed.compactMap({ $0.reportId }).forEach { omitReportIds.insert($0) }
        case .failure(_):
            break
        }

        // These are reports that are filtered

        let filteredReports = serverReports.filter({ $0.id != nil ? !omitReportIds.contains($0.id!) : false })
        if (filteredReports.count > 0) {
            findAnyNewExposures(reports: filteredReports)
        }
    }

    private func findAnyNewExposures(reports: [Report]) {
        // TODO: See if any reports have a path that aligns with our user's path and create a Exposure notification if necessary.

        let userPath = PathManager.shared.getLocalPath()

        for report in reports {
            if let path = report.path, let infectionCondition = report.infectionCondition {
                let exposedData = Utilities.comparePaths(path1: userPath, path2: path, condition: infectionCondition)
                if exposedData.0, let dateExposed = exposedData.1, let duration = exposedData.2, let reportId = report.id, let infection = report.infectionCondition?.infection {
                    let exposed = ExposedDomain(id: UUID(), reportId: reportId, exposedDate: dateExposed, duration: duration, infectionName: infection.name, infectionTypeValue: Int16(infection.type.rawValue))
                    let saveExposedResult = exposedRepository.save(exposed: exposed)
                    switch saveExposedResult {
                    case .success():
                        print("Sucessfully saved exposed result to the database!")
                    case .failure(let error):
                        print("There was an error saving exposed: \(error)")
                    }

                    createPushNotification(exposed: exposed)
                }
            }
        }
    }

    private func createPushNotification(exposed: ExposedDomain) {
        let content = UNMutableNotificationContent()
        content.title = "Potential Exposures"
        content.subtitle = "You might be exposed to \(exposed.infectionName)!"
        content.sound = .defaultCritical

        content.body = "You were in contact with a person who has \(exposed.infectionName) on \(exposed.exposedDate)."

        // show this notification one seconds from now
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

        // choose a random identifier
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        // add our notification request
        UNUserNotificationCenter.current().add(request)
    }
}
