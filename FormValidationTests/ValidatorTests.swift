//
//  ValidatorTests.swift
//  FormValidation
//
//  Created by Kazuya Shida on 3/31/16.
//  Copyright © 2016 mani3. All rights reserved.
//

import XCTest
@testable import FormValidation

class ValidatorTests: XCTestCase {

    struct Regex {
        static let Email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        static let PhoneNumber = "^\\d{10}$"
    }
    
    struct Message {
        static let Required = "This field is required"
        static let Email = "Please enter a valid email address"
        static let PhoneNumber = "Please enter a valid phone number"
        static let Length = "Please enter %d characters only"
        static let MinLength = "Please enter at least %d characters"
        static let MaxLength = "Please enter no more than %d characters"
        static let Equal = "Please enter the same value"
    }
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testRequired() {
        let textField = UITextField(frame: CGRectZero)
        textField.validators = [
            textField.required().error(Message.Required),
        ]
        let (invalid, errorMessage) = textField.validate()
        XCTAssert(!invalid)
        XCTAssertEqual(errorMessage, Message.Required)
        textField.text = "sample message"
        let (valid, emptyMessage) = textField.validate()
        XCTAssert(valid)
        XCTAssertEqual(emptyMessage, "")
    }
    
    func testRegex() {
        let emailField = UITextField(frame: CGRectZero)
        emailField.validators = [
            emailField.required().error(Message.Required),
            emailField.with(Regex.Email).error(Message.Email),
        ]
        emailField.text = "not email"
        let (invalid, errorMessage) = emailField.validate()
        XCTAssert(!invalid)
        XCTAssertEqual(errorMessage, Message.Email)
        emailField.text = "test@example.com"
        let (valid, emptyMessage) = emailField.validate()
        XCTAssert(valid)
        XCTAssertEqual(emptyMessage, "")
    }
    
    func testEqualLength() {
        let textField = UITextField(frame: CGRectZero)
        let lengthErrorMessage = String(format: Message.Length, 5)
        textField.validators = [
            textField.length(5).error(lengthErrorMessage),
        ]
        textField.text = "over 5 characters"
        let (invalid, errorMessage) = textField.validate()
        XCTAssert(!invalid)
        XCTAssertEqual(errorMessage, lengthErrorMessage)
        textField.text = "12345"
        let (valid, emptyMessage) = textField.validate()
        XCTAssert(valid)
        XCTAssertEqual(emptyMessage, "")
    }
    
    func testMinMaxLength() {
        let textField = UITextField(frame: CGRectZero)
        let minErrorMessage = String(format: Message.MinLength, 4)
        let maxErrorMessage = String(format: Message.MaxLength, 8)
        textField.validators = [
            textField.minLength(4).error(minErrorMessage),
            textField.maxLength(8).error(maxErrorMessage),
        ]
        textField.text = "123"
        let (minFailed, minError) = textField.validate()
        XCTAssert(!minFailed)
        XCTAssertEqual(minError, minErrorMessage)
        
        textField.text = "123456"
        let (valid, empty) = textField.validate()
        XCTAssert(valid)
        XCTAssertEqual(empty, "")
        
        textField.text = "123456789"
        let (maxFailed, maxError) = textField.validate()
        XCTAssert(!maxFailed)
        XCTAssertEqual(maxError, maxErrorMessage)
    }
    
    func testValidator() {
        var text = ""
        let errorMessage = "Please enter '12345'"
        let validator = Validator(block: { () -> Bool in
            return text == "12345"
        })
        let textField = UITextField(frame: CGRectZero)
        textField.validators = [
            validator.error(errorMessage),
        ]
        let (invalid, message) = textField.validate()
        XCTAssert(!invalid)
        XCTAssertEqual(message, errorMessage)
        
        text = "12345"
        let (valid, emptyMessage) = textField.validate()
        XCTAssert(valid)
        XCTAssertEqual(emptyMessage, "")
    }
}
