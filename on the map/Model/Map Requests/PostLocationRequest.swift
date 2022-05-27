//
//  PostLocationRequest.swift
//  on the map
//
//  Created by Daniel Felipe Valencia Rodriguez on 25/05/22.
//

import Foundation

struct PostLocationRequest: Codable {
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Float
    let longitude: Float
}
