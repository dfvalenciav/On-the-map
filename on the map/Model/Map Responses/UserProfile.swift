//
//  UserProfile.swift
//  on the map
//
//  Created by Daniel Felipe Valencia Rodriguez on 19/05/22.
//

import Foundation
struct UserProfile: Codable {
    let firstName: String
    let lastName: String
    let nickname: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case nickname
    }
}
