//
//  Extensions.swift
//  SignUp
//
//  Created by Kazuya Shida on 4/11/16.
//  Copyright © 2016 mani3. All rights reserved.
//

import UIKit

extension UITextField {
    
    var paddingLeft: CGFloat {
        get {
            if let view: UIView = self.leftView {
                return view.frame.width
            }
            return 0.0
        }
        set {
            let paddingView = UIView(frame: CGRect.init(x: 0, y: 0, width: newValue, height: self.frame.height))
            self.leftView = paddingView
            self.leftViewMode = .Always
        }
    }
    
    var paddingRignt: CGFloat {
        get {
            if let view: UIView = self.rightView {
                return view.frame.width
            }
            return 0.0
        }
        set {
            let paddingView = UIView(frame: CGRect.init(x: 0, y: 0, width: newValue, height: self.frame.height))
            self.rightView = paddingView
            self.rightViewMode = .Always
        }
    }
    
    var cornerTop: CGFloat {
        get {
            return 0.0
        }
        set {
            let corner: UIRectCorner = UIRectCorner.TopLeft.union(UIRectCorner.TopRight)
            roundCorners(corner, radius: newValue)
        }
    }
    
    var cornerBottom: CGFloat {
        get {
            return 0.0
        }
        set {
            let corner: UIRectCorner = UIRectCorner.BottomLeft.union(UIRectCorner.BottomRight)
            roundCorners(corner, radius: newValue)
        }
    }
    
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.CGPath
        self.layer.masksToBounds = true
        self.layer.mask = mask
    }
}