//
//  ViewController.swift
//  Steds Care
//
//  Created by Erik Bautista on 10/29/21.
//

import UIKit
import APIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var organizationLoginButton: UIButton!
    @IBOutlet weak var textFieldsStackView: UIStackView!
    @IBOutlet var textFields: [SingleTextField]!

    override func viewDidLoad() {
        super.viewDidLoad()
        textFields.forEach { $0.backspaceCalled = textFieldHandleDelete }
        loginButton.layer.cornerRadius = loginButton.frame.height / 4
        validateLoginButton()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @IBAction func handleLogin(_ sender: UIButton) {
        sender.isUserInteractionEnabled = true

        let accessCode = getAccessCodeText()

        let request = StedsCareAPI.ValidateOrganizationAccessCodeRequest(accessCode: accessCode)

        DispatchQueue.global().asyncAfter(deadline: .now() + 1) { [weak self] in
            Session.send(request) { result in
                switch result {
                case .success(let response):
                    self?.handleSuccess(organization: response)
                case .failure(let error):
                    printError(error)
                    let alert = UIAlertController(title: "Incorrect access code.", message: "This access code does not exist. Please try again.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
                    self?.present(alert, animated: true)
                }
                sender.isUserInteractionEnabled = true
            }
        }
    }

    private func handleSuccess(organization: Organization) {
        print(organization)
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let userTabBarViewController = storyboard.instantiateViewController(withIdentifier: "userTabBarViewController")

            let foregroundedScenes = UIApplication.shared.connectedScenes.filter { $0.activationState == .foregroundActive }
            guard let window = foregroundedScenes.map({ $0 as? UIWindowScene }).compactMap({ $0 }).first?.windows.filter({ $0.isKeyWindow }).first else {
                return
            }

            window.rootViewController = userTabBarViewController
            UIView.transition(with: window, duration: 0.3, options: [.transitionCrossDissolve], animations: {}, completion: nil)
        }
    }

    private func getAccessCodeText() -> String {
        return textFields
            .sorted(by: { $0.tag < $1.tag})
            .compactMap({ $0.text })
            .joined()
    }

    private func validateLoginButton() {
        let isAccessCodeValid = getAccessCodeText().count == 6
        loginButton.isEnabled = isAccessCodeValid
        loginButton.backgroundColor = isAccessCodeValid ? .link : .systemGray6
        loginButton.titleLabel?.textColor = isAccessCodeValid ? .white : .systemGray4
    }
}


// MARK: UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {

    func textFieldHandleDelete(_ textField: UITextField) {
        let moveBack = {
            let previousTag = textField.tag - 1
            if let previousResponder = textField.superview?.viewWithTag(previousTag) as? UITextField {
                previousResponder.text = ""
                previousResponder.becomeFirstResponder()
            }
        }
        moveBack()
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        let newPosition = textField.endOfDocument
        textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        guard let textFieldOldStringCount = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count else { return false }

        let newString = string.trimmingCharacters(in: .whitespacesAndNewlines)

        guard newString.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) == nil else {
            return false
        }

        var value = false

        let setValueAndMoveForward = {
            textField.text = string
            let nextTag = textField.tag + 1
            if let nextResponder = textField.superview?.viewWithTag(nextTag) {
                nextResponder.becomeFirstResponder()
            }
        }

        if textFieldOldStringCount < 1 && newString.count > 0 {
            setValueAndMoveForward()
            if textField.tag == 6 {
                textField.resignFirstResponder()
            }
        } else if textFieldOldStringCount >= 1 && string.count == 0 {
            textField.text = ""
            return false
        } else if textFieldOldStringCount >= 1 && string.count > 0 {
            let nextTag = textField.tag + 1
            if let previousResponder = textField.superview?.viewWithTag(nextTag) {
                previousResponder.becomeFirstResponder()
                if let activeTextField = previousResponder as? UITextField {
                    activeTextField.text = string
                }
            }
        } else {
            value = true
        }
        return value
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       if let nextField = self.view.viewWithTag(textField.tag + 1) as? UITextField {
           nextField.becomeFirstResponder()
       } else {
           textField.resignFirstResponder()
       }
       return false
   }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        validateLoginButton()
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        validateLoginButton()
    }
}

extension LoginViewController {
    @objc func keyboardWillShow(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//            if self.textFieldsStackView.frame.origin.y == 0 {
//                self.textFieldsStackView.frame.origin.y -= keyboardSize.height
//            }
//        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//            if self.textFieldsStackView.frame.origin.y != 0 {
//                self.textFieldsStackView.frame.origin.y -= keyboardSize.height
//            }
//        }
    }
}
