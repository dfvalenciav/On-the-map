//
//  SessionResponse.swift
//  on the map
//
//  Created by Daniel Felipe Valencia Rodriguez on 13/05/22.
//

import Foundation

struct SessionResponse : Codable {
    let account : Account
    let session : Session
    
    enum CodingKeys : String, CodingKey {
        case account
        case session
    }
}
