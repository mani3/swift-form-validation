//
//  UITextField.swift
//  FormValidation
//
//  Created by Kazuya Shida on 3/31/16.
//  Copyright © 2016 mani3. All rights reserved.
//

import UIKit

internal extension String {

    func match(pattern: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: .CaseInsensitive)
            let matches = regex.matchesInString(self, options: [],
                range: NSRange.init(location: 0, length: self.characters.count))
            return !matches.isEmpty
        } catch {
            return false
        }
    }
}

extension UITextField: Validate, ValidatorBuilder {

    private struct AssociateKeys {
        static var ValidatesKey = "validates_key"
        static var BorderColorKey = "border_color_key"
    }

    private struct Fonts {
        static var FontAwesome = "FontAwesome"
    }

    private struct Icons {
        static var Exclamation: UniChar = 0xF06A // Exclamation-Circle
        static var Check: UniChar = 0xF058 // Check-Circle
    }

    private struct Colors {
        static var Valid: UIColor = UIColor(hex: 0x00B900, alpha: 1)
        static var Invalid: UIColor = UIColor(hex: 0xB90000, alpha: 1)
    }

    public var validators: [Validator] {
        get {
            if let validators =
                objc_getAssociatedObject(self, &AssociateKeys.ValidatesKey) as? [Validator] {
                    return validators
            }
            return []
        }
        set {
            objc_setAssociatedObject(self, &AssociateKeys.ValidatesKey,
                newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    /// It is kept a border color with already set
    public var defaultBorderColor: UIColor {
        get {
            if let color = objc_getAssociatedObject(
                self, &AssociateKeys.BorderColorKey) as? UIColor {
                    return color
            } else {
                return UIColor.clearColor()
            }
        }
        set {
            objc_setAssociatedObject(self, &AssociateKeys.BorderColorKey,
                newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    public func validate() -> (Bool, String) {
        dismissValidationIcon()
        for validator: Validator in validators {
            let (valid, errorMessage) = validator.validate()
            if !valid {
                showValidationIcon(Icons.Exclamation, color: Colors.Invalid)
                return (false, errorMessage)
            }
        }
        showValidationIcon(Icons.Check, color: Colors.Valid)
        return (true, "")
    }

    public func showValidationIcon(unicode: UniChar, color: UIColor) {
        self.defaultBorderColor = UIColor(CGColor: self.layer.borderColor!)
        self.layer.borderColor = color.CGColor

        let iconText: NSString = String(UnicodeScalar(unicode)) as NSString
        if let font: UIFont = UIFont(name: Fonts.FontAwesome, size: self.font!.pointSize) {
            let size: CGSize = iconText.sizeWithAttributes([NSFontAttributeName: font])

            /// Create the icon for validation
            let icon: UIButton = UIButton(frame: CGRect.zero)
            icon.translatesAutoresizingMaskIntoConstraints = false
            icon.setTitle(iconText as String, forState: .Normal)
            icon.setTitleColor(color, forState: .Normal)
            icon.titleLabel?.font = font
            self.addSubview(icon)

            var format = "H:[icon(w)]-h-|"
            if self.textAlignment == .Right {
                format = "H:|-h-[icon(w)]"
            }
            let horizontalConstraint = NSLayoutConstraint.constraintsWithVisualFormat(
                format,
                options: [],
                metrics: ["w": size.width, "h": 10],
                views: ["icon": icon]
            )
            self.addConstraints(horizontalConstraint)
            let v = (self.frame.height - size.height) / 2
            let verticalConstraint = NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|-v-[icon(h)]",
                options: [],
                metrics: ["v": v, "h": size.height],
                views: ["icon": icon]
            )
            self.addConstraints(verticalConstraint)
        }
    }

    public func dismissValidationIcon() {
        self.layer.borderColor = self.defaultBorderColor.CGColor
        for view in self.subviews {
            if view is UIButton {
                view.removeFromSuperview()
                return
            }
        }
    }

    // MARK: ValidatorBuilder

    public func with(regex: String) -> Validator {
        let validator = Validator(block: { () -> Bool in
            return self.text!.match(regex)
        })
        return validator
    }

    public func required() -> Validator {
        let validator = Validator(block: { () -> Bool in
            return !self.text!.isEmpty
        })
        return validator
    }

    public func length(equal: Int) -> Validator {
        let validator = Validator(block: { () -> Bool in
            return self.text!.characters.count == equal
        })
        return validator
    }

    public func minLength(min: Int) -> Validator {
        let validator = Validator(block: { () -> Bool in
            return self.text!.characters.count >= min
        })
        return validator
    }

    public func maxLength(max: Int) -> Validator {
        let validator = Validator(block: { () -> Bool in
            return self.text!.characters.count <= max
        })
        return validator
    }

    public func whether(block: ValidateBlock) -> Validator {
        let validator = Validator(block: block)
        return validator
    }
}
