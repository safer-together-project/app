//
//  SingleTextField.swift
//  Steds Care
//
//  Created by Erik Bautista on 11/16/21.
//

import Foundation
import UIKit

class SingleTextField: UITextField {
    var backspaceCalled: ((UITextField) -> ())?

    override func deleteBackward() {
        if (text ?? "").isEmpty {
            backspaceCalled?(self)
        }

        super.deleteBackward()
    }
}
