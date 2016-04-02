//
//  Validator.swift
//  FormValidation
//
//  Created by Kazuya Shida on 3/31/16.
//  Copyright © 2016 mani3. All rights reserved.
//

import Foundation

public typealias ValidateBlock = (() -> Bool)

protocol Validate {

    func validate() -> (Bool, String)
}

@objc protocol ValidatorBuilder {

    optional func with(regex: String) -> Validator
    optional func required() -> Validator
    optional func length(equal: Int) -> Validator
    optional func minLength(min: Int) -> Validator
    optional func maxLength(max: Int) -> Validator
    optional func whether(block: ValidateBlock) -> Validator
}

public class Validator: NSObject, Validate {

    let block: ValidateBlock
    var errorMessage: String

    public init(block: ValidateBlock, errorMessage: String = "") {
        self.block = block
        self.errorMessage = errorMessage
    }

    public func validate() -> (Bool, String) {
        return (self.block(), self.errorMessage)
    }

    public func error(message: String) -> Validator {
        self.errorMessage = message
        return self
    }
}
