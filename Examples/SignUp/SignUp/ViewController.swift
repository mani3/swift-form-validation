//
//  ViewController.swift
//  SignUp
//
//  Created by Kazuya Shida on 4/11/16.
//  Copyright © 2016 mani3. All rights reserved.
//

import UIKit
import FormValidation

class ViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField?
    @IBOutlet weak var emailField: UITextField?
    @IBOutlet weak var passwordField: UITextField?
    @IBOutlet weak var confirmPasswordField: UITextField?
    
    @IBOutlet weak var form: Form?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Register username validators
        if let username = usernameField {
            username.validators = [
                username.required().error("Please enter a username"),
                username.maxLength(20).error("Please enter no more than 20 characters"),
            ]
        }
        
        /// Register email validators
        if let email = emailField {
            email.validators = [
                email.required().error("Please enter a email"),
                email.with("[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}")
                    .error("Please enter a valid email"),
            ]
        }
        
        /// Register password validators
        if let password = passwordField {
            password.validators = [
                password.required(),
                password.minLength(6).error("Please enter at least 6 characters"),
                password.maxLength(12).error("Please enter no more than 12 characters"),
            ]
        }
        
        /// This validation is for confirm password
        let validator = Validator (block: { [weak self] () -> Bool in
            if let (validPassword, _) = self?.passwordField?.validate() {
                if !validPassword {
                    return false
                }
            }
            if self?.passwordField?.text == self?.confirmPasswordField?.text {
                return true
            }
            return false
            })
        /// Register confirm password validation
        if let confirmPassword = confirmPasswordField {
            confirmPassword.validators = [
                validator.error("Your passwords mismatched"),
            ]
        }
    }
    
    // MARK: Action
    
    @IBAction func signup(button: UIButton) {
        if let form = self.form {
            let (valid, _) = form.validate()
            if valid {
                /// Something
            }
        }
    }
}

