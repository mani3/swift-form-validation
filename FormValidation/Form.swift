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

    public override func awakeFromNib() {
        super.awakeFromNib()
        NSLog("%@", #function)
    }
    
    public override func updateConstraints() {
        NSLog("%@", #function)
        super.updateConstraints()
    }
    
    public func hasConstraint(view: UIView, constraint: NSLayoutConstraint) -> Bool {
        for c in view.constraints {
            if c.isEqualConstraint(constraint) {
                return true
            }
        }
        return false
    }

    public override func layoutSubviews() {
        NSLog("%@", #function)
        
        if alert.superview == nil {
            /// Add the alert label
            self.addSubview(alert)
            /// Add the close button on alert
            alert.closeButton.addTarget(self, action:
                #selector(Form.close(_:)), forControlEvents: .TouchUpInside)
            
            /// Setup constraints of alert
            let topConstraints = findConstraintsByAttribute(.Top)
            for constraint in topConstraints {
                var vertical = defaultAlertBottomMergin
                if constraint.constant > 0.0 {
                    vertical = constraint.constant
                }
                /// Replace top constraint on Form
                let c = NSLayoutConstraint.constraintsWithVisualFormat(
                    "V:[alert]-v-[item]",
                    options: [],
                    metrics: ["v": vertical],
                    views: ["alert" : alert, "item" : constraint.firstItem]
                )
                constraint.active = false
                //self.removeConstraint(constraint)
                self.addConstraints(c)
            }
            let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|-0-[alert]-0-|", options: [], metrics: nil, views: ["alert" : alert])
            let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|-0-[alert]", options: [], metrics: nil, views: ["alert" : alert])
            self.addConstraints(horizontalConstraints)
            self.addConstraints(verticalConstraints)
            
            /// The height of Alert label is adjusted using this height constraint
            let h = NSLayoutConstraint(item: alert, attribute: .Height, relatedBy: .Equal,
                                       toItem: nil, attribute: .Height, multiplier: 1, constant: 0)
            self.alert.addConstraint(h)
            self.alertHeightConstraint = h
        }
        
        /// Remove constraints depulication on Form
        let topConstraints = findConstraintsByAttribute(.Top)
        for constraint in topConstraints {
            if constraint.firstItem as? Alert != alert {
                constraint.active = false
            }
        }
        
        alert.font = alertFont
        /// Fix a height of alert label depending on message
        let s = alert.sizeThatFits(CGSize.zero)
        if s.height > 0 {
            let height = s.height + alert.insets.top + alert.insets.bottom
            self.alertHeightConstraint?.constant = height
        } else {
            /// Hide an alert label if empty message
            self.alertHeightConstraint?.constant = 0
        }
        super.layoutSubviews()
        
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
