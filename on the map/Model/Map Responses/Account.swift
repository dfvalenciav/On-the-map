//
//  Account.swift
//  on the map
//
//  Created by Daniel Felipe Valencia Rodriguez on 13/05/22.
//

import Foundation

struct Account : Codable {
    let UserRegistered: Bool
    let keySession: String
    
    enum CodingKeys: String, CodingKey {
        case UserRegistered = "registered"
        case keySession = "key"
    }
}



