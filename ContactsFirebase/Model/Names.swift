//
//  Name.swift
//  ContactsFirebase
//
//  Created by Jun Dang on 2019-01-10.
//  Copyright © 2019 Jun Dang. All rights reserved.
//

import Foundation
import Contacts


class Names {
    
    var isExpanded: Bool
    var names: [FavoritableContact]
    
    init(isExpanded: Bool, names:[FavoritableContact]) {
        self.isExpanded = isExpanded
        self.names = names
    }
}

class FavoritableContact {
    let contact: Contact
    var hasFavorited: Bool = false
    init(contact: Contact, hasFavorited: Bool){
        self.contact = contact
        self.hasFavorited = hasFavorited
    }
}
