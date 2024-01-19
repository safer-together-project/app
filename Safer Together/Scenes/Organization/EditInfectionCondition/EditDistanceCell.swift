//
//  EditDistanceCell.swift
//  Safer Together
//
//  Created by Erik Bautista on 2/21/22.
//

import Foundation
import UIKit

class EditDistanceCell: UITableViewCell {
    typealias DistanceChanged = (String) -> Void

    @IBOutlet weak var distanceTextField: UITextField!

    private var distanceChangeAction: DistanceChanged?

    override func awakeFromNib() {
        super.awakeFromNib()
        distanceTextField.addTarget(self, action: #selector(distanceChanged(_:)), for: .editingDidEnd)
    }

    func configure(distance: Double, changeAction: @escaping DistanceChanged) {
        distanceTextField.text = "\(distance)"
        self.distanceChangeAction = changeAction
    }
    
    @objc func distanceChanged(_ sender: UITextField) {
        distanceChangeAction?(sender.text ?? "3")
    }
}
