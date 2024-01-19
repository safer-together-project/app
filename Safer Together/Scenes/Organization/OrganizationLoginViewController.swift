//
//  OrganizationLoginViewController.swift
//  Steds Care
//
//  Created by Erik Bautista on 11/1/21.
//

import UIKit
import APIKit

class OrganizationLoginViewController: UIViewController {
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        loginButton.layer.cornerRadius = loginButton.frame.height / 4
        loginButton.isEnabled = false
        loginButton.addTarget(self, action: #selector(loginClicked), for: .touchDown)
    }

    @objc private func loginClicked() {
        print("Login")

        loginButton.isEnabled = false

        let request = StedsCareAPI.SubmitLoginRequest(username: usernameTextField.text ?? "", password: passwordTextField.text ?? "")

        DispatchQueue.global().asyncAfter(deadline: .now() + 1) { [weak self] in
            Session.send(request) { result in
                switch result {
                case .success(let response):
                    print(response)
                    self?.handleSuccess(response)
                case .failure(let error):
                    printError(error)
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Incorrect login.", message: "The information provided did not work. Try again.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
                        self?.present(alert, animated: true)
                    }
                }
                DispatchQueue.main.async {
                    self?.loginButton.isEnabled = true
                }
            }
        }

    }

    private func handleSuccess(_ employee: Employee) {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let organizationTabBarViewController = storyboard.instantiateViewController(withIdentifier: "organizationTabBarViewController")

            if let vc = organizationTabBarViewController as? OrganizationTabBarController {
                vc.employee = employee
            }

            let foregroundedScenes = UIApplication.shared.connectedScenes.filter { $0.activationState == .foregroundActive }
            guard let window = foregroundedScenes.map({ $0 as? UIWindowScene }).compactMap({ $0 }).first?.windows.filter({ $0.isKeyWindow }).first else {
                return
            }

            window.rootViewController = organizationTabBarViewController
            UIView.transition(with: window, duration: 0.3, options: [.transitionCrossDissolve], animations: {}, completion: nil)
        }
    }
}

extension OrganizationLoginViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if let username = usernameTextField.text, !username.isEmpty, let password = passwordTextField.text, !password.isEmpty {
            loginButton.isEnabled = true
        } else {
            loginButton.isEnabled = false
        }
    }
}
