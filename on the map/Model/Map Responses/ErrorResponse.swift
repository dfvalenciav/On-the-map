//
//  ErrorResponse.swift
//  on the map
//
//  Created by Daniel Felipe Valencia Rodriguez on 16/05/22.
//

import Foundation

struct ErrorResponse: Codable {
    let statusCode: Int
    let statusMessage: String
    
    enum Codingkeys: String, CodingKey {
        case statusCode = "status"
        case statusMessage = "error"
        
    }
    
}
extension ErrorResponse : LocalizedError {
    var errorDescription: String? {
        return statusMessage
    }
}
