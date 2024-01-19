//
//  EditDurationCell.swift
//  Safer Together
//
//  Created by Erik Bautista on 2/21/22.
//

import UIKit

class EditDurationCell: UITableViewCell {
    typealias DurationChanged = (String) -> Void

    @IBOutlet weak var durationTextField: UITextField!

    private var durationChangeAction: DurationChanged?

    override func awakeFromNib() {
        super.awakeFromNib()
        durationTextField.addTarget(self, action: #selector(durationChanged(_:)), for: .editingDidEnd)
    }

    func configure(duration: Double, changeAction: @escaping DurationChanged) {
        durationTextField.text = "\(duration)"
        self.durationChangeAction = changeAction
    }

    @objc func durationChanged(_ sender: UITextField) {
        durationChangeAction?(sender.text ?? "3600")
    }
}
