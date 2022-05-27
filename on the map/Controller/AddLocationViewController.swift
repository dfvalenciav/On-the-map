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
   
    
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var stackViewCentral: UIStackView!
    @IBOutlet weak var imageAddLocation: UIImageView!
    @IBOutlet weak var findLocationButton: UIButton!
    
    // MARK: - Properties
    
    private var presentingController: UIViewController?
    var geocoder = CLGeocoder()
    var latitude: Float = 0.0
    var longitude: Float = 0.0
    var keyboardIsVisible = false
    
    // MARK: - Lifecycle methods
        
    override func viewDidLoad() {
        locationTextField.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentingController = presentingViewController
        
        subscribeToKeyboardNotifications()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: - Actions
       
    @IBAction func findLocationButtonAction(_ sender: Any) {
        view.endEditing(true)
        if locationTextField.text!.isEmpty  {
            showFailure(title: "Information Missing", message: "Please fill the location and the link or information associated.")
        } else {
            setIndicator(true)
            geocoder.geocodeAddressString(locationTextField.text ?? "") { (placemarks, error) in
                self.processResponse(withPlacemarks: placemarks, error: error)
            }
        }
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Functions related to keyboard presentation
    
    // Function called when keyboard must be shown and the screen must be moved up
    @objc func keyboardWillShow(_ notification:Notification) {
        if !keyboardIsVisible {
            if locationTextField.isEditing {
                view.frame.origin.y -= getKeyboardHeight(notification) - 50  - findLocationButton.frame.height
            }
            keyboardIsVisible = true
        }
    }
    
    // Function called when screen must be moved down
    @objc func keyboardWillHide(_ notification:Notification) {
        if keyboardIsVisible {
            view.frame.origin.y = 0
            keyboardIsVisible = false
        }
    }
    
    // Get keyboard size for move the screen
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    // MARK: - Subscribe and unsubscribe from keyboard notifications
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Text field delegate functions
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    // MARK: - Main methods
    
    func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        if error != nil {
            setIndicator(false)
            showFailure(title: "Location Do Not Exist", message: "The informed location doesn't exist.")
        } else {
            if let placemarks = placemarks, placemarks.count > 0 {
                let location = (placemarks.first?.location)! as CLLocation

                let coordinate = location.coordinate
                
                self.latitude = Float(coordinate.latitude)
                self.longitude = Float(coordinate.longitude)
                                
                setIndicator(false)
                            
                goToConfirmingScreen()
            } else {
                setIndicator(false)
                showFailure(title: "Location Not Well Specified", message: "Try to use the full location name (Ex: California, USA).")
            }
        }
    }
    
    func goToConfirmingScreen() {
        let FinishAddLocationViewController = self.storyboard!.instantiateViewController(withIdentifier: "FinishAddLocationViewController") as! FinishAddLocationViewController
        FinishAddLocationViewController.latitude = self.latitude
        FinishAddLocationViewController.longitude = self.longitude
        FinishAddLocationViewController.mapString = self.locationTextField.text!
        FinishAddLocationViewController.mediaURL = ""
        FinishAddLocationViewController.navigationItem.title = "Add Location"
        self.navigationController?.pushViewController(FinishAddLocationViewController, animated: true)
    }
    
    func setIndicator(_ isFinding: Bool) {
        if isFinding {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
                
    func showFailure(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
