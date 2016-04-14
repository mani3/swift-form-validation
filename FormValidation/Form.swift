//
//  Form.swift
//  FormValidation
//
//  Created by Kazuya Shida on 3/31/16.
//  Copyright © 2016 mani3. All rights reserved.
//

import UIKit

public class Form: UIView, Validate {

    let alert = Alert(frame: CGRect.zero, type: .Danger)
    let defaultAlertBottomMergin: CGFloat = 10.0

    public var alertFont: UIFont? = UIFont.systemFontOfSize(16)
    var constants: [NSLayoutConstraint: CGFloat] = [:]

    public override func awakeFromNib() {
        super.awakeFromNib()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        if alert.superview == nil {

            /// Add the alert label
            self.addSubview(alert)

            /// Add the close button on alert
            alert.closeButton.addTarget(self, action:
                #selector(Form.close(_:)), forControlEvents: .TouchUpInside)
        }
        /// Font
        alert.font = alertFont

        /// Fix a height of alert label depending on message
        let size = alert.sizeThatFits(CGSize.init(
            width: self.frame.width - alert.insets.right, height: 0))
        print(size)
        var height: CGFloat = 0
        if size.height > 0 {
            height = size.height + alert.insets.top + alert.insets.bottom
        }

        /// Set a position of Alert
        alert.frame = CGRect.init(x: 0, y: 0, width: self.frame.width, height: height)

        /// Setup constraints for alert space
        let topConstraints = findConstraintsByAttribute(.Top)
        for constraint in topConstraints {
            if constants[constraint] == nil {
                constants[constraint] = constraint.constant
            }
            let mergin = defaultAlertBottomMergin
            if height > 0.0 {
                constraint.constant = height + mergin
            } else {
                constraint.constant = constants[constraint] ?? 0.0
            }
        }
    }

    private func validation(view: UIView, inout errors: [String]) {
        for v in view.subviews {
            if let validation = v as? Validate {
                let (valid, message) = validation.validate()
                if !valid {
                    errors.append(message)
                }
            }
            self.validation(v, errors: &errors)
        }
    }

    public func validate() -> (Bool, String) {
        var errors: [String] = []
        validation(self, errors: &errors)
        let message = errors.first ?? ""
        setAlertText(message)
        return (errors.isEmpty, message)
    }

    public func setAlertText(text: String) {
        alert.text = text
        setNeedsLayout()
    }

    private func findConstraintsByAttribute(attribute: NSLayoutAttribute) -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        for constraint in self.constraints {
            if constraint.firstAttribute == attribute
                && constraint.secondItem as? Form == self {
                    constraints.append(constraint)
            }
        }
        return constraints
    }

    public func close(button: UIButton) {
        setAlertText("")
    }
}
