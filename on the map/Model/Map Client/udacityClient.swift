//
//  Map Client.swift
//  on the map
//
//  Created by Daniel Felipe Valencia Rodriguez on 12/05/22.
//

import Foundation
import UIKit

class udacityClient {

    struct Auth {
        static var sessionId: String?
        static var key = ""
        static var firstName = ""
        static var lastName = ""
        static var objectId = ""
        static var uniqueKey = ""
    }


enum EndPoints {
    
    static let base = "https://onthemap-api.udacity.com/v1"

    case sessionId
    case login
    case logout
    case addStudentLocation
    case gettingStudentLocations
    case updateStudentLocation
    case getLoggedInUserProfile
    
    var stringValue : String {
        switch self {
        case .sessionId: return EndPoints.base + "/session"
        case.login: return EndPoints.base
        case.logout: return EndPoints.base + "/session"
        case.addStudentLocation: return EndPoints.base + "/StudentLocation"
        case.gettingStudentLocations: return EndPoints.base + "/StudentLocation?order=-updatedAt&limit=100"
        case .updateStudentLocation: return EndPoints.base + "/StudentLocation/8ZExGR5uX8"
        case.getLoggedInUserProfile: return EndPoints.base + "/users/" + Auth.key
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
    
    class func logout(completion: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: EndPoints.logout.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
            completion (false, error)
            return
    }
        let range = 5..<data!.count
            let newData = data?.subdata(in: range)
            print (String(data: newData!, encoding: .utf8)!)
            Auth.sessionId = ""
            completion(false, error)
        }
        
        task.resume()
    }
    
   class func getStudentPins (completion: @escaping ([StudentInformation], Error?) -> Void ) {
        
        let session = URLSession.shared
        let url = udacityClient.EndPoints.gettingStudentLocations.url
        
        let task = session.dataTask(with: url) { data, response, error in
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion ([], error)
                }
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                print (String(data: data, encoding: .utf8) ?? "")
            
            let requestObject = try
                decoder.decode(StudentLocations.self, from: data)
            DispatchQueue.main.async {
                completion(requestObject.results, nil)
            }
        } catch {
            
            DispatchQueue.main.async {
                completion([], error)
                print (error.localizedDescription)
            }
        }
    }
    task.resume()
    }
    
    class func getStudentLists ( completion: @escaping ([StudentInformation], Error?) -> Void ) {

        let session = URLSession.shared
        let url = udacityClient.EndPoints.gettingStudentLocations.url
        let task = session.dataTask(with: url) { data, response, error in
            
            guard let data = data else {
                DispatchQueue.main.async {
                    
                    completion ([], error)
                }
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                print (String(data: data, encoding: .utf8) ?? "")
            let requestObject = try
                decoder.decode(StudentLocations.self, from: data)
            DispatchQueue.main.async {
                //self.tableView.reloadData()
                completion(requestObject.results, nil)
            }
        } catch {
            
            DispatchQueue.main.async {
                completion([], error)
                print (error.localizedDescription)
            }
        }
    }
    task.resume()
            }
    
    class func addStudentLocation(information: StudentInformation, completion: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: EndPoints.addStudentLocation.url)
        let jsonbody = "{\"uniqueKey\": \"\(information.uniqueKey)\", \"firstName\": \"\(information.firstName)\", \"lastName\": \"\(information.lastName)\",\"mapString\": \"\(information.mapString)\", \"mediaURL\": \"\(information.mediaURL)\",\"latitude\": \(information.latitude), \"longitude\": \(information.longitude)}"
        //print("\(information.latitude), \"longitude\":\(information.longitude)" )
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonbody.data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) {data, response, error in
            if error != nil {
                completion (false, error)
                return
            }
            print (String(data: data!, encoding: .utf8)!)
            completion(true, nil)
        }
        task.resume()
}
    
    class func updateStudentLocation(information: StudentInformation, completion: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: EndPoints.updateStudentLocation.url)
        let jsonbody = "{\"uniqueKey\": \"\(information.uniqueKey)\", \"firstName\": \"\(information.firstName)\", \"lastName\": \"\(information.lastName)\",\"mapString\": \"\(information.mapString)\", \"mediaURL\": \"\(information.mediaURL)\",\"latitude\": \(information.latitude), \"longitude\": \(information.longitude)}"
        
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonbody.data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                completion (false, error)
                return
            }
            print (String(data: data!, encoding: .utf8)!)
    }
        task.resume()
}
}
