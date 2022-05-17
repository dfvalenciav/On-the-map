//
//  Map Client.swift
//  on the map
//
//  Created by Daniel Felipe Valencia Rodriguez on 12/05/22.
//

import Foundation

class udacityClient {

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
        case .sessionId: return EndPoints.base + "/session"
        case.login: return EndPoints.base
        case.logout: return EndPoints.base
        }
    }
        
    var url: URL {
       return URL(string: stringValue)!
        }
    
}
    
    
    class func taskForGetRequest<ResponseType: Decodable>(url: URL, responseType:  ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
                   guard let data = data else {
                       DispatchQueue.main.async {
                           completion(nil, error)
                       }
                       return
    }
            let decoder = JSONDecoder()
            do{
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(ErrorResponse.self, from: data) as! Error
                    DispatchQueue.main.async {
                        completion((errorResponse as! ResponseType), nil)
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
        
        class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType,  completion: @escaping (ResponseType?, Error?) -> Void) {
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.httpBody = try! JSONEncoder().encode(body)
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    if error != nil {
                        completion(nil, error)
                        print(error)
                        return
                    }
                    
                    let range = 5..<data!.count
                    let newData = data?.subdata(in: range)
                    guard let data = data else {
                        DispatchQueue.main.async {
                            completion(nil, error)
                        }
                        return
                    }
                    let decoder = JSONDecoder()
                    do {
                        let responseObject = try decoder.decode(responseType.self, from: newData!)
                        DispatchQueue.main.async {
                            completion(responseObject, nil)
                        }
                    }catch{
                        do {
                            print(String(data: newData!, encoding: .utf8)!)
                            
                            let errorResponse = try decoder.decode(ErrorResponse.self, from: newData!)
                            
                            DispatchQueue.main.async {
                                completion((errorResponse as! ResponseType), nil)
                            }
                        }catch {
                            DispatchQueue.main.async {
                                completion(nil, error)
                                
                                
                            }
                        }
                    }
                }
                task.resume()
            }

    class func login (username : String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        var udacity : Udacity
        udacity = Udacity(username: username, password: password)
        let body = LoginRequest(udacity:udacity)
        taskForPOSTRequest(url: EndPoints.sessionId.url, responseType : SessionResponse.self, body: body){
            response, error in
            if let response = response {
                Auth.sessionId = response.session.sessionId
                completion (true, nil)
            } else {
                completion (false, nil)
            }
        }
    }

}
