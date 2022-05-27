//
//  StudentResponse.swift
//  on the map
//
//  Created by Daniel Felipe Valencia Rodriguez on 19/05/22.
//

import Foundation

// MARK: - UserResponse
struct StudentResponse: Codable {
    let firstName: String
    let lastName: String

    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
    }
}
