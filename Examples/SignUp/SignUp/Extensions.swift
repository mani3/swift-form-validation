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
}