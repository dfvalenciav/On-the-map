//
//  AddLocationViewController.swift
//  on the map
//
//  Created by Daniel Felipe Valencia Rodriguez on 17/05/22.
//

import Foundation
import UIKit
import MapKit


class AddLocationViewController : UIViewController, UITextFieldDelegate {
   
    
    
    
    @IBOutlet weak var CancelButtonOutlet: UIBarButtonItem!
    @IBOutlet weak var LocationTextFieldOutlet: UITextField!
    @IBOutlet weak var FindLocationOutlet: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var objectId: String?
    var locationTextFieldIsEmpty = true
    var linkTextFieldIsEmpty = true
    
    
    //life cyucle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LocationTextFieldOutlet.delegate = self
        //linkTextField.delegate = self
        buttonEnabled(true, button: FindLocationOutlet)
        activityIndicator.isHidden = true
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func backAction() -> Void {
        self.navigationController?.popViewController(animated: true)
    }
    
   
    @IBAction func findLocation(_ sender: Any) {
    self.setLoading(true)
        let newLocation = LocationTextFieldOutlet.text
        
       /* guard let url = URL(string: self.linkTextField.text!)
        ,UIApplication.shared.canOpenURL(url) else {
            self.showAlert(message: "Website link is incorrect:", title: "Invalid link")
            self.setLoading(false)
            return
        }*/
        worldPosition(newLocation: newLocation ?? "")
}

    
    // Position//
    
    private func worldPosition (newLocation: String) {
        CLGeocoder().geocodeAddressString(newLocation) { (newMarker, error) in
            if let error = error {
                
                self.showAlert(message: error.localizedDescription, title: "Location Not Found")
                self.setLoading(false)
                
            } else {
                var location: CLLocation?
            
            if let marker = newMarker, marker.count > 0 {
                location = marker.first?.location
                }
                
        if let location = location {
            self.loadNewLocation(location.coordinate)
            
        } else {
            self.showAlert(message: "Please try again", title: "Location Invalid")
            self.setLoading(false)
            print ("An error occured")
                }
            }
        }
    }
    
    private func loadNewLocation(_ coordinate: CLLocationCoordinate2D) {
                let controller = storyboard?.instantiateViewController(withIdentifier: "FinishAddLocationViewController") as! FinishAddLocationViewController
                controller.studentInformation = buildStudentInformation(coordinate)
                self.navigationController?.pushViewController(controller, animated: true)
                
            }

    private func buildStudentInformation(_ coordinate: CLLocationCoordinate2D) -> StudentInformation {
        
        var studentInfo = [
            "uniqueKey": udacityClient.Auth.key,
            "firstName": udacityClient.Auth.firstName,
            "lastName": udacityClient.Auth.lastName,
            "mapString": LocationTextFieldOutlet.text!,
            "mediaURL" : "",
            "latitude": coordinate.latitude,
            "longitude": coordinate.longitude,
        ] as [String: AnyObject]

        if let objectId = objectId {
            studentInfo["objectId"] = objectId as AnyObject
            print(objectId)
        }
        return StudentInformation(studentInfo)
    
}

    func setLoading(_ loading: Bool) {
        if loading {
            DispatchQueue.main.async {
                self.activityIndicator.isHidden = false
                self.buttonEnabled(false, button: self.FindLocationOutlet) }
                } else {
                    DispatchQueue.main.async {
                        self.activityIndicator.isHidden = true
                        self.buttonEnabled(true, button: self.FindLocationOutlet)
                    }
                }
                DispatchQueue.main.async {
                    self.LocationTextFieldOutlet.isEnabled = !loading
                    //self.linkTextField.isEnabled = !loading
                   // self.FindLocationOutlet.isEnabled = !loading
                }
                
            }
        
        // TextFields
        
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if textField == LocationTextFieldOutlet {
                let currentText = LocationTextFieldOutlet.text ?? ""
                guard let rangeString = Range (range, in: currentText)
                    else {
                        return false
                }
                
                let updatedText = currentText.replacingCharacters(in: rangeString, with: string)
                if updatedText.isEmpty && updatedText == "" {
                    locationTextFieldIsEmpty = true
                } else {
                    locationTextFieldIsEmpty = false
                    
                }
            }
    
            
          /*  if textField == linkTextField {
                let currentText = linkTextField.text ?? ""
                guard let rangeString = Range(range, in: currentText)
                    else {
                        return false
                }
                let updatedText = currentText.replacingCharacters(in: rangeString, with: string)
                if updatedText.isEmpty && updatedText == "" {
                    linkTextFieldIsEmpty = true
                } else {
                    linkTextFieldIsEmpty = false
                }
            }*/
            
            if locationTextFieldIsEmpty == false && linkTextFieldIsEmpty == false {
                buttonEnabled(true, button: FindLocationOutlet)
            } else {
                buttonEnabled(true, button: FindLocationOutlet)
            }
            return true
}
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        buttonEnabled (false, button: FindLocationOutlet)
        if textField == LocationTextFieldOutlet {
            locationTextFieldIsEmpty = true
        }
        /*if textField == linkTextField {
            linkTextFieldIsEmpty = true
        }*/
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as?
            UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            findLocation(FindLocationOutlet as Any)
        }
    return true
        }
}
