//
//  AgreementViewController.swift
//  Safer Together
//
//  Created by Erik Bautista on 3/1/22.
//

import UIKit

class AgreementViewController: UIViewController {
    @IBOutlet weak var circularView: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        circularView.backgroundColor = PathManager.shared.pointOption == 1 ? .systemGreen : .systemOrange
        circularView.layer.cornerRadius = circularView.bounds.height / 2
    }
}
