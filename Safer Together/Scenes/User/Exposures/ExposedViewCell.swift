//
//  ExposedViewCell.swift
//  Steds Care
//
//  Created by Erik Bautista on 1/21/22.
//

import UIKit

class ExposedViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    static let identifier = "exposed-view-cell"

    func bind(exposed: ExposedDomain) {
        let nameExposed = exposed.infectionName

        let duration = exposed.duration
        let dateExposed = exposed.exposedDate

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short

        let timeInterval = TimeInterval(duration)

        titleLabel.text = "\(nameExposed)"

        let calendar = Calendar.current
        let currentDate = Date()
        var preText = "You've been"
        if let advancedOneWeek = calendar.date(byAdding: .day, value: 7, to: dateExposed) {
            // If dateExposed + 7 is greater than the current date, then that means that it has not been a week since
            // They've been infected
            if advancedOneWeek >= currentDate {
                backgroundColor = UIColor(named: "exposedRed")
                titleLabel.textColor = .white
                subtitleLabel.textColor = .white
                preText = "You've been"
            } else {
                // This will be set if it's passed one week since infecteds
                backgroundColor = UIColor(named: "exposedYellow")
                titleLabel.textColor = .white
                subtitleLabel.textColor = .white
                preText = "You were"
            }
        }

        if let advancedTwoWeeks = calendar.date(byAdding: .day, value: 14, to: dateExposed) {
            // If it's been two weeks since they've been exposed then just set color to default
            if advancedTwoWeeks <= currentDate {
                backgroundColor = .tertiarySystemGroupedBackground
                titleLabel.textColor = .label
                subtitleLabel.textColor = .label
                preText = "You were"
            }
        }

        let timeFormatter = DateComponentsFormatter()
        timeFormatter.allowedUnits = [.hour, .minute]
        timeFormatter.unitsStyle = .brief
        timeFormatter.zeroFormattingBehavior = .dropAll

        subtitleLabel.text = "\(preText) exposed to \(nameExposed) on \(dateFormatter.string(from: dateExposed)) for about \(timeFormatter.string(from: duration) ?? "0 mins")."
    }
}
