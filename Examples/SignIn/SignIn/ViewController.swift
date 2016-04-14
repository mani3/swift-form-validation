//
//  ViewController.swift
//  SignIn
//
//  Created by Kazuya Shida on 4/13/16.
//  Copyright © 2016 mani3. All rights reserved.
//

import UIKit
import FormValidation

class ViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var form: Form!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        form.alertFont = UIFont.systemFontOfSize(16)
        
        /// Register email validators
        self.emailField.validators = [
            emailField.required().error("Please enter a email"),
            emailField.with("[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}")
                .error("Please enter a valid email"),
        ]
        
        /// Register password validators
        self.passwordField.validators = [
            passwordField.required().error("Please enter a password"),
            passwordField.minLength(6).error("Please enter at least 6 characters"),
            passwordField.maxLength(12).error("Please enter no more than 12 characters"),
        ]
    }
    
    override func viewDidLayoutSubviews() {
        emailField.cornerTop = 5.0
        passwordField.cornerBottom = 5.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func signin(button: UIButton) {
        let (valid, _) = self.form.validate()
        if valid {
            /// Something
        }
    }
}

