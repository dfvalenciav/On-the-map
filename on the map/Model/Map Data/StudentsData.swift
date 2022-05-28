//
//  StudentsData.swift
//  on the map
//
//  Created by Daniel Felipe Valencia Rodriguez on 27/05/22.
//

import Foundation

class StudentsData: NSObject {

    var students = [StudentInformation]()

    class func sharedInstance() -> StudentsData {
        struct Singleton {
            static var sharedInstance = StudentsData()
        }
        return Singleton.sharedInstance
    }

}
