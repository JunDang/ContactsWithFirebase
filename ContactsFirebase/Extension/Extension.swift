//
//  Extensiion.swift
//  ContactsFirebase
//
//  Created by Jun Dang on 2019-01-03.
//  Copyright © 2019 Jun Dang. All rights reserved.
//

import UIKit
import SwiftMessages

extension UIColor {
    
    class var azure:UIColor{
        return self.init(red: (0.0/255.0), green: (128.0/255.0), blue: (255.0/255.0), alpha: 1.0)
    }
    
    class var babyBlue:UIColor{
        return self.init(red: (128.0/255.0), green: (170.0/255.0), blue: (255.0/255.0), alpha: 1.0)
    }
    
    class var lavenderGray:UIColor{
        return self.init(red: (196.0/255.0), green: (192.0/255.0), blue: (208.0/255.0), alpha: 1.0)
    }
    
    class var darkScarlet:UIColor{
        return self.init(red: (77.0/255.0), green: (0.0/255.0), blue: (25.0/255.0), alpha: 1.0)
    }

    class var burgundy:UIColor{
        return self.init(red: (120.0/255.0), green: (0.0/255.0), blue: (21.0/255.0), alpha: 1.0)
    }
}

extension UIViewController {
    func disPlayError(_ errorMessage: String) {
        let error = MessageView.viewFromNib(layout: .tabView)
        error.configureTheme(.error)
        error.configureContent(title: "Error", body: errorMessage)
        error.button?.setTitle("Stop", for: .normal)
        SwiftMessages.show(view: error)
    }
    
    func disPlayInfo(_ title: String, message: String) {
        let info = MessageView.viewFromNib(layout: .messageView)
        info.configureTheme(.info)
        info.button?.isHidden = true
        info.configureContent(title: title, body: message)
        var infoConfig = SwiftMessages.defaultConfig
        infoConfig.presentationStyle = .center
        infoConfig.duration = .seconds(seconds: 2)
        SwiftMessages.show(config: infoConfig, view: info)
    }
}

extension String {
    
    func isValidName() -> Bool {
        if self.count == 0 {
            return false
        }
        
        do {
            let regex = try NSRegularExpression(pattern: ".*[^A-Za-z].*", options: .caseInsensitive)
            if let _ = regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSMakeRange(0, self.count)) {
                return false
            }
        } catch {
            debugPrint(error.localizedDescription)
            return true
        }
        return true
    }
    
    func isValidEmail() -> Bool {
        guard self.count != 0 else { return false }
        let regEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let pred = NSPredicate(format:"SELF MATCHES %@", regEx)
        return pred.evaluate(with: self)
    }
    
    func isValidPassword() -> Bool {
        if self.count >= 6 {
            return true
        }
        return false
    }
}

