//
//  Contact.swift
//  ContactsFirebase
//
//  Created by Jun Dang on 2019-01-03.
//  Copyright © 2019 Jun Dang. All rights reserved.
//

import UIKit

class Contact: NSObject {
    var email: String = ""
    var lastName: String = ""
    var firstName: String = ""
    init(dictionary: [String: Any]) {
        self.email = dictionary["email"] as? String ?? ""
        self.lastName = dictionary["last name"] as? String ?? ""
        self.firstName = dictionary["first name"] as? String ?? ""
   }
}
