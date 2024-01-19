//
//  InfectionCollectionViewCell.swift
//  Steds Care
//
//  Created by Erik Bautista on 11/22/21.
//

import UIKit

class InfectionCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!

    static var cellIdentifier: String {
        return "infection-cell"
    }

    override var isSelected: Bool {
        didSet(newValue){
            contentView.backgroundColor = newValue ? .link.withAlphaComponent(0.2) : .systemGray6
            nameLabel.textColor = newValue ? .link : .label
        }
    }

    func configure(_ infectionCondition: InfectionCondition) {
        nameLabel.text = infectionCondition.infection?.name ?? "Unknown"
    }
}
