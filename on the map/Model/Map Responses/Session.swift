//
//  Session.swift
//  on the map
//
//  Created by Daniel Felipe Valencia Rodriguez on 13/05/22.
//

import Foundation

struct Session : Codable {
    let sessionId : String
    let expirationDate : String
    
    enum CodingKeys : String, CodingKey {
        case sessionId = "id"
        case expirationDate = "expiration"
    }
}



