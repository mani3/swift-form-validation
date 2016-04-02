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

    var alertHeightConstraint: NSLayoutConstraint?
    public var alertFont: UIFont = UIFont.systemFontOfSize(16)

    public override func layoutSubviews() {
        super.layoutSubviews()
        if alert.superview == nil {
            /// Setup alert view
            alert.closeButton.addTarget(self, action: "close:", forControlEvents: .TouchUpInside)
            self.addSubview(alert)
            let topConstraints = findConstraintsByAttribute(.Top)
            for constraint in topConstraints {
                var vertical = defaultAlertBottomMergin
                if constraint.constant > 0.0 {
                   vertical = constraint.constant
                }
                let c = NSLayoutConstraint.constraintsWithVisualFormat(
                    "V:[alert]-v-[item]",
                    options: [],
                    metrics: ["v": vertical],
                    views: ["alert" : alert, "item" : constraint.firstItem]
                )
                self.addConstraints(c)
                self.removeConstraint(constraint)
            }
            let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|-0-[alert]-0-|", options: [], metrics: nil, views: ["alert" : alert])
            let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|-0-[alert]", options: [], metrics: nil, views: ["alert" : alert])
            self.addConstraints(horizontalConstraints)
            self.addConstraints(verticalConstraints)

            let h = NSLayoutConstraint(item: alert, attribute: .Height, relatedBy: .Equal,
                toItem: nil, attribute: .Height, multiplier: 1, constant: 0)
            self.alert.addConstraint(h)
            self.alertHeightConstraint = h
        }
        alert.font = alertFont
        let s = alert.sizeThatFits(CGSize.zero)
        if s.height > 0 {
            let height = s.height + alert.insets.top + alert.insets.bottom
            self.alertHeightConstraint?.constant = height
        } else {
            self.alertHeightConstraint?.constant = 0
        }
    }

    public func validate() -> (Bool, String) {
        var errors: [String] = []
        var valid = true
        for view in self.subviews {
            if let validation = view as? Validate {
                let (isValid, errorMesssage) = validation.validate()
                if !isValid {
                    errors.append(errorMesssage)
                    valid = false
                }
            }
        }
        let message = errors.first ?? ""
        setAlertText(message)
        return (valid, message)
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

    private func close(button: UIButton) {
        setAlertText("")
    }
}
