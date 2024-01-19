//
//  ReportViewCell.swift
//  Steds Care
//
//  Created by Erik Bautista on 1/21/22.
//

import UIKit

class ReportViewCell: UICollectionViewCell {
    static let identifier = "report-view-cell"

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    func bind(report: ReportDomain) {
        titleLabel.text = "Report: \(report.infectionName)"

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short

        dateLabel.text = "Submitted on: \(dateFormatter.string(from: report.created))"
    }
}
