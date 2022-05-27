//
//  FinishAddLocationViewController.swift
//  on the map
//
//  Created by Daniel Felipe Valencia Rodriguez on 17/05/22.
//

import Foundation
import UIKit
import MapKit

class FinishAddLocationViewController : UIViewController {


    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var submitButtonOutlet: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var likedinTextFieldOutlet: UITextField!
    
    // MARK: - Properties
    
    private var presentingController: UIViewController?
    var latitude: Float = 0.0
    var longitude: Float = 0.0
    var mapString: String = ""
    var mediaURL: String = ""
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        showMapAnnotation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentingController = presentingViewController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.mapView.alpha = 0.0
        UIView.animate(withDuration: 1.0, delay: 0, options: [], animations: {
            self.mapView.alpha = 1.0
        })
    }
        
    // MARK: - MKMapViewDelegate

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    // MARK: - Actions
    
    @IBAction func finishButtonAction(_ sender: Any) {
        udacityClient.getPublicUserData(completion: handlePublicUserData(firstName:lastName:error:))
    }
    
    // MARK: - Main methods
    
    func showMapAnnotation() {
        let latitude = CLLocationDegrees(self.latitude)
        let longitude = CLLocationDegrees(self.longitude)
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = self.mapString

        mapView.addAnnotation(annotation)
        mapView.selectAnnotation(annotation, animated: true)
    }
    
    func handlePublicUserData(firstName: String?, lastName: String?, error: Error?) {
        mediaURL = likedinTextFieldOutlet.text!
        if error == nil {
            udacityClient.postStudentLocation(firstName: firstName!, lastName: lastName!, mapString: self.mapString, mediaURL: self.mediaURL, latitude: self.latitude, longitude: self.longitude, completion: handlePostStudentResponse(success:error:))
        } else {
            showFailure(title: "Not Possible to Get User Information", message: error?.localizedDescription ?? "")
        }
    }
    
    func handlePostStudentResponse(success: Bool, error: Error?) {
        if success {
            self.navigationController?.dismiss(animated: true, completion: nil)
        } else {
            showFailure(title: "Not Possible to Save Information", message: error?.localizedDescription ?? "")
        }
    }
    
    func showFailure(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
