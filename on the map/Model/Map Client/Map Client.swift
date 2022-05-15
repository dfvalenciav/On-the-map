//
//  Map Client.swift
//  on the map
//
//  Created by Daniel Felipe Valencia Rodriguez on 12/05/22.
//

import Foundation

class MapClient {

struct Auth {
    static var sessionId = ""
}


enum EndPoints {
    
    static let base = "https://onthemap-api.udacity.com/v1"

    case sessionId
    case login
    case logout
    
    var stringValue : String {
        switch self {
        case .sessionId: return EndPoints.base + "/session/"
        case.login: return EndPoints.base
        case.logout: return EndPoints.base
        }
    }
        
    var url: URL {
       return URL(string: stringValue)!
        }
    
}
    
    
    class func taskForPostRequest <RequestType : Encodable , ResponseType : Decodable> (
        url : URL, responseType : ResponseType.Type, body : RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
            
            var request = URLRequest (url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try! JSONEncoder().encode(body)
            let session = URLSession.shared
            let task = session.dataTask(with: request){
                data, response, error in
                guard let data = data else {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                    return
                }
                let decoder = JSONDecoder()
                do {
                    let responseObject = try decoder.decode(ResponseType.self, from: data)
                    DispatchQueue.main.async {
                        completion(responseObject, nil)
                    }
                } catch{
                    do {
                        let errorResponse = try decoder.decode(SessionResponse.self, from: data) as Error
                        DispatchQueue.main.async {
                            completion(nil, errorResponse)
                        }
                    } catch {
                        DispatchQueue.main.async {
                            completion(nil, error)
                        }
                    }
                }
                let range = Range(5..<data!.count)
                let newData = data?.subdata(in: range) /* subset response data! */
                print(String(data: newData!, encoding: .utf8)!)
                
            }
            task.resume()
            
    }
    
    class func createSessionId (username : String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        var udacity : Udacity
        udacity.username = username
        udacity.password = password
        let body = LoginRequest(udacity:udacity)
        taskForPostRequest(url: EndPoints.sessionId.url, responseType : SessionResponse.self, body: body){
            response, error in
            if let response = response {
                Auth.sessionId = response.session.sessionId
                completion (true, nil)
            } else {
                completion (false, nil)
            }
        }
    }
    
    
    /**
     var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
     request.httpMethod = "POST"
     request.addValue("application/json", forHTTPHeaderField: "Accept")
     request.addValue("application/json", forHTTPHeaderField: "Content-Type")
     // encoding a JSON body from a string, can also use a Codable struct
     request.httpBody = "{\"udacity\": {\"username\": \"account@domain.com\", \"password\": \"********\"}}".data(using: .utf8)
     let session = URLSession.shared
     let task = session.dataTask(with: request) { data, response, error in
       if error != nil { // Handle error…
           return
       }
       let range = Range(5..<data!.count)
       let newData = data?.subdata(in: range) /* subset response data! */
       print(String(data: newData!, encoding: .utf8)!)
     }
     task.resume()
     
     */
    
    
    /**+
     class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
         var request = URLRequest(url: url)
         request.httpMethod = "POST"
         request.httpBody = try! JSONEncoder().encode(body)
         request.addValue("application/json", forHTTPHeaderField: "Content-Type")
         let task = URLSession.shared.dataTask(with: request) { data, response, error in
             guard let data = data else {
                 DispatchQueue.main.async {
                     completion(nil, error)
                 }
                 return
             }
             let decoder = JSONDecoder()
             do {
                 let responseObject = try decoder.decode(ResponseType.self, from: data)
                 DispatchQueue.main.async {
                     completion(responseObject, nil)
                 }
             } catch {
                 do {
                     let errorResponse = try decoder.decode(TMDBResponse.self, from: data) as Error
                     DispatchQueue.main.async {
                         completion(nil, errorResponse)
                     }
                 } catch {
                     DispatchQueue.main.async {
                         completion(nil, error)
                     }
                 }
             }
         }
         task.resume()
     }
     **/
    

}
