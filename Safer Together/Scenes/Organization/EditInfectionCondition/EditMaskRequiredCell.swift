//
//  EditMaskRequiredCell.swift
//  Safer Together
//
//  Created by Erik Bautista on 2/21/22.
//

import Foundation
import UIKit

class EditMaskRequiredCell: UITableViewCell {
    typealias SwitchChanged = (Bool) -> Void

    @IBOutlet weak var onSwitch: UISwitch!

    private var switchChangeAction: SwitchChanged?

    override func awakeFromNib() {
        super.awakeFromNib()
        onSwitch.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
    }
    func configure(on: Bool, changeAction: @escaping SwitchChanged) {
        onSwitch.isOn = on
        self.switchChangeAction = changeAction
    }
    
    @objc func switchChanged(_ sender: UISwitch) {
        switchChangeAction?(sender.isOn)
    }
}
