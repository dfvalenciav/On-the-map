//
//  ErrorResponse.swift
//  on the map
//
//  Created by Daniel Felipe Valencia Rodriguez on 16/05/22.
//

import Foundation

struct ErrorResponse: Codable {
    let message: String

    init(message: String) {
        self.message = message
    }
}

extension ErrorResponse: LocalizedError {
    var errorDescription: String? {
        return message
    }
}
