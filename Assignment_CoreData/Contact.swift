//
//  Contact.swift
//  Assignment_CoreData
//
//  Created by MacStudent on 2020-01-16.
//  Copyright © 2020 Karan. All rights reserved.
//

import Foundation
class Contact {
    var firstname: String
    var lastname: String
    var email: String
    var phonenumber: String
    
    init(firstname: String, lastname: String, email: String, phonenumber: String) {
        self.firstname = firstname;
        self.lastname = lastname;
        self.email = email;
        self.phonenumber = phonenumber;
    }
}
