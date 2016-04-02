//
//  Alert.swift
//  FormValidation
//
//  Created by Kazuya Shida on 3/31/16.
//  Copyright © 2016 mani3. All rights reserved.
//

import UIKit

internal extension UIColor {
    convenience init(hex: Int, alpha: CGFloat) {
        let r: CGFloat = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let g: CGFloat = CGFloat((hex & 0x00FF00) >> 8) / 255.0
        let b: CGFloat = CGFloat((hex & 0x0000FF)) / 255.0
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
}

/// Alert is the feedback text for user action
public class Alert: UILabel {

    /**
     Colors is theme set like bootstrap alert styling

     - Success: Success style
     - Info:    Info style
     - Warning: Warning style
     - Danger:  Danger style
     */
    public enum Colors {
        case Success
        case Info
        case Warning
        case Danger

        /**
         Return a background color of each style

         - returns: Int, Hax RGB
         */
        public func bg() -> Int {
            switch self {
            case .Success: return 0xDFF0D8 // RGB(223,240,216)
            case .Info:    return 0xD9EDF7 // RGB(217,237,247)
            case .Warning: return 0xFCF8E3 // RGB(252,248,227)
            case .Danger:  return 0xF2DEDE // RGB(242,222,222)
            }
        }

        /**
         Return a border color of each style

         - returns: Int, Hax RGB
         */
        public func border() -> Int {
            switch self {
            case .Success: return 0xE2EDD8 // RGB(226,237,216)
            case .Info:    return 0xD6EFF4 // RGB(214,239,244)
            case .Warning: return 0xFAF1DF // RGB(250,241,223)
            case .Danger:  return 0xE9C8CD // RGB(233,200,205)
            }
        }

        /**
         Return a text color of each style

         - returns: Int, Hax RGB
         */
        public func text() -> Int {
            switch self {
            case .Success: return 0x3C763D // RGB(60,118,61)
            case .Info:    return 0x31708F // RGB(49,112,143)
            case .Warning: return 0x8A6D3B // RGB(138,109,59)
            case .Danger:  return 0xA94442 // RGB(169,68,66)
            }
        }
    }
    public let insets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 30)

    public var closeIconUnicode: UniChar = 0xF00D
    public var fontName: String = "FontAwesome"
    public var closeButton = UIButton(type: .Custom)

    convenience init(frame: CGRect, type: Colors) {
        self.init(frame: frame)
        self.userInteractionEnabled = true
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 5
        self.layer.borderColor = UIColor(hex: type.border(), alpha: 1).CGColor
        self.layer.backgroundColor = UIColor(hex: type.bg(), alpha: 1).CGColor
        self.textColor = UIColor(hex: type.text(), alpha: 1)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.numberOfLines = 0
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        /// Conceal if close button dose not have the target
        if closeButton.allTargets().isEmpty {
            return
        }
        if closeButton.superview == nil {
            let close: NSString = String(UnicodeScalar(closeIconUnicode)) as NSString
            if let font = UIFont(name: fontName, size: self.font.pointSize) {
                let size: CGSize = close.sizeWithAttributes([NSFontAttributeName: font])
                closeButton.setTitle(close as String, forState: .Normal)
                closeButton.setTitleColor(UIColor(white: 0.5, alpha: 0.5), forState: .Normal)
                closeButton.setTitleColor(UIColor(white: 0.5, alpha: 1.0), forState: .Highlighted)
                closeButton.titleLabel?.font = font
                closeButton.frame = CGRect.init(x: 0, y: 0, width: size.width, height: size.height)
                self.addSubview(closeButton)
            } else {
                NSLog("%@ not found. Add the font file or change Alert#fontName, please", fontName)
            }
        }
        /// Modify a position of the close button
        let s = closeButton.frame.size
        closeButton.hidden = self.frame.height <= 0.0
        closeButton.frame = CGRect.init(
            x: self.frame.width - self.insets.right / 2 - s.width / 2,
            y: self.frame.height / 2 - s.height / 2,
            width: s.width,
            height: s.height
        )
    }

    public override func drawTextInRect(rect: CGRect) {
        super.drawTextInRect(UIEdgeInsetsInsetRect(rect, insets))
    }
}
