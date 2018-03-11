//
//  Structs.swift
//  tes
//
//  Created by Renan Aguiar on 2017-12-13.
//  Copyright © 2017 Renan Aguiar. All rights reserved.
//

import Foundation
import UIKit


struct formValidation {
    let textField: UITextField
    let label: UILabel
}


struct ApiContainer<T: Codable>: Codable {
    let meta: Meta
    let result: [T]
}

struct Login : Codable {
    let token: String
    let error: String
}


struct User : Codable {
    let email: String
    let password: String
}

enum BackendError: Error {
    case urlError(reason: String)
    case objectSerialization(reason: String)
    case objectDeletion(reason: String)
}

struct Meta: Codable {
    let sucess: String
    let message: String!
}


struct Response: Codable {
    let field: String!
    let message: String!
}

struct Address: Codable {
    let city: String
    let zipcode: String
}


struct Province {
    let name, abbrev : String
}



let provinces = [Province(name: "Alberta", abbrev: "AB"), Province(name: "British Columbia", abbrev: "BC"),
                 Province(name: "Manitoba", abbrev: "MB"), Province(name: "New Brunswick", abbrev: "NB"),
                 Province(name: "Newfoundland and Labrador", abbrev: "NL"), Province(name: "Northwest Territorie", abbrev: "NT"),
                 Province(name: "Nova Scotia", abbrev: "NS"), Province(name: "Nunavut", abbrev: "NU"),
                 Province(name: "Ontario", abbrev: "ON"), Province(name: "Prince Edward Island", abbrev: "PE"),
                 Province(name: "Quebec", abbrev: "QC"), Province(name: "Saskatchewan", abbrev: "SK"),
                 Province(name: "Yukon", abbrev: "YT")]


struct Client: Codable {
    var client_id: Int!
    let name: String!
    let postal_code: String!
    let province: String!
    let city: String!
    let address: String!
    
    init(name: String, client_id: Int! = nil, postal_code: String, province: String, city: String, address: String) {
        self.client_id = client_id
        self.name = name
        self.postal_code = postal_code
        self.province = province
        self.city = city
        self.address = address
        
    }
    
    var cityProvince: String {
        return [ city, province ].flatMap({$0}).joined(separator:" - ")
    }
    
    var nameFirstLetter: String {
        return String(self.name[self.name.startIndex]).uppercased()
    }
    
}


struct Contact: Codable {
    var client_contact_id: Int!
    var client_id: Int!
    let first_name: String!
    let last_name: String!
    let email: String!
    let phone: String!
    
    init(client_contact_id: Int! = nil, client_id: Int! = nil,first_name: String, last_name: String, email: String, phone: String) {
        self.client_contact_id = client_contact_id
        self.client_id = client_id
        self.first_name = first_name
        self.last_name = last_name
        self.email = email
        self.phone = phone        
    }
    
    var fullName: String {
        return [ first_name, last_name ].flatMap({$0}).joined(separator:" ")
    }
}

struct InvoiceItem: Codable {
    var invoice_detail_id: Int!
    let invoice_id: Int!
    let description: String!
    let unit_price: Decimal!
    let quantity: Decimal!
    
    init(invoice_detail_id: Int! = nil, invoice_id: Int! = nil, description: String, unit_price: Decimal, quantity: Decimal) {
        self.invoice_detail_id = invoice_detail_id
        self.invoice_id = invoice_id
        self.description = description
        self.unit_price = unit_price
        self.quantity = quantity
    }
}

struct Invoice: Codable {
    var invoice_id: Int!
    let client_id: Int!
    var tax: Decimal!
    var date_issue: String!
    var due_date: String!
    var amount_paid: Decimal!
    var date_transaction: String!
    var voided: Int!
    var note: String!
    var invoice_number: String!
    var status: String!
    var items: [InvoiceItem]!
    
    init(invoice_id: Int! = nil, client_id: Int! = nil,tax: Decimal, date_issue: String, due_date: String = "0000-00-00", amount_paid: Decimal, date_transaction: String, voided: Int, note: String, invoice_number: String, status: String, items: [InvoiceItem]) {
        self.invoice_id = invoice_id
        self.client_id = client_id
        self.tax = tax
        self.date_issue = date_issue
        self.due_date = due_date
        self.amount_paid = amount_paid
        self.date_transaction = date_transaction
        self.voided = voided
        self.note = note
        self.invoice_number = invoice_number
        self.status = status
        self.items = items
    }
    
    init(invoice_id: Int! = nil, client_id: Int! = nil,tax: Decimal, date_issue: String, due_date: String = "0000-00-00", status: String, items: [InvoiceItem]) {
        self.invoice_id = invoice_id
        self.client_id = client_id
        self.tax = tax
        self.date_issue = date_issue
        self.due_date = due_date
        self.voided = 0
        self.status = status
        self.items = items
    }
    
    
    init(invoice_id: Int! = nil, client_id: Int! = nil,amount_paid: Decimal, date_transaction: String) {
        self.invoice_id = invoice_id
        self.client_id = client_id
        self.amount_paid = amount_paid
        self.date_transaction = date_transaction
    }
    
    
    init(invoice_id: Int! = nil, client_id: Int! = nil, note: String) {
        self.invoice_id = invoice_id
        self.client_id = client_id
        self.note = note
    }

}

struct SignUp: Codable {
    let businessName: String
    let email: String
    let password: String
    let passwordConfirmation: String
    
    init(businessName: String, email: String, password: String, passwordConfirmation: String) {
        self.businessName = businessName
        self.email = email
        self.password = password
        self.passwordConfirmation = passwordConfirmation
        
    }
}
