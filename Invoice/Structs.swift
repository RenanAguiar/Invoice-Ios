//
//  Structs.swift
//  tes
//
//  Created by Renan Aguiar on 2017-12-13.
//  Copyright © 2017 Renan Aguiar. All rights reserved.
//

import Foundation


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
}

struct Meta: Codable {
    let sucess: String
    let message: String!
  //  let token: String
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
    
}



//class Client: Codable {
//    var client_id: Int!
//    let name: String!
//    let postal_code: String!
//    let province: String!
//    let city: String!
//    let address: String!
//
//    init(name: String, client_id: Int! = nil, postal_code: String, province: String, city: String, address: String) {
//        self.client_id = client_id
//        self.name = name
//        self.postal_code = postal_code
//        self.province = province
//        self.city = city
//        self.address = address
//    }
//
//   static func getClients() -> [Client]  {
//
//    var clients: [Client]
// makeRequest(endpoint: "http://blog.local:4711/api/clients/all",
//                    parameters: [:],
//            completionHandler: { (container : ApiContainer<Client>?, error : Error?) in
//                if let error = error {
//                    print("error calling POST on /getClients")
//                    print(error)
//                    return
//                }
//
//                print(container!.result)
//                clients = (container?.result)!
//        } )
//    return clients
//       }
//
//}





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
