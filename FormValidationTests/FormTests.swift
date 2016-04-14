//
//  FormTests.swift
//  FormValidation
//
//  Created by Kazuya Shida on 4/14/16.
//  Copyright © 2016 mani3. All rights reserved.
//

import XCTest
@testable import FormValidation

class FormTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testTextField1() {
        let error = ""
        let textField = UITextField(frame: CGRect.zero)
        textField.validators = [
            textField.required().error(error)
        ]
        let form = Form(frame: CGRect.zero)
        form.addSubview(textField)
        let (isValid, errorMessage) = form.validate()
        XCTAssert(!isValid)
        XCTAssertEqual(errorMessage, error)
        textField.text = "sample text"
        let (valid, empty) = form.validate()
        XCTAssertTrue(valid)
        XCTAssertEqual(empty, "")
    }
    
    func testTextField2() {
        let error = ""
        let textField1 = UITextField(frame: CGRect.zero)
        textField1.validators = [
            textField1.required().error(error)
        ]
        let textField2 = UITextField(frame: CGRect.zero)
        textField2.validators = [
            textField2.required().error(error)
        ]
        let view = UIView(frame: CGRect.zero)
        view.addSubview(textField1)
        view.addSubview(textField2)
        
        let form = Form(frame: CGRect.zero)
        form.addSubview(view)
        let (valid, errorMessage) = form.validate()
        XCTAssert(!valid)
        XCTAssertEqual(errorMessage, error)
        textField1.text = "1234"
        textField2.text = "5678"
        let (isValid, empty) = form.validate()
        XCTAssert(isValid)
        XCTAssertEqual(empty, "")
    }
    
    func testFormEmpty() {
        let form = Form(frame: CGRect.zero)
        let (valid, message) = form.validate()
        XCTAssert(valid)
        XCTAssertEqual(message, "")
    }
}
