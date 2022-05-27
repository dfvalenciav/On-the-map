//
//  MapViewController.swift
//  on the map
//
//  Created by Daniel Felipe Valencia Rodriguez on 16/05/22.
//

import UIKit
import MapKit

class MapViewController: UIViewController {



    @IBOutlet var mapView: MKMapView!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var dropPinButton: UIBarButtonItem!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    var locations = [StudentInformation]()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    override func viewDidAppear(_ animated: Bool) {
        updateRequest()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(true)
        updateRequest()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateRequest()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateRequest()
    }

    @IBAction func refreshButtonAction(_ sender: Any) {
        updateRequest()
    }
    
    func updateRequest() {
        if !mapView.annotations.isEmpty {
            mapView.removeAnnotations(mapView.annotations)
        }
        udacityClient.getStudentPins { (results, error) in
                print (results)
            self.locations = results as [StudentInformation]
            self.setup()
            self.showMapAnnotations(self.locations)
            }
    }
    
    
    
    

    @IBAction func logoutButtonAction(_ sender: Any) {
        udacityClient.logout{ (results, error)  in
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func addLocation(_ sender: Any) {
    performSegue(withIdentifier: "addLocation", sender: sender)
    }
    
    func showMapAnnotations(_ locations: [StudentInformation]) {
        var annotations = [MKPointAnnotation]()
               
        for location in locations {
            let latitude = CLLocationDegrees(location.latitude!)
            let longitude = CLLocationDegrees(location.longitude!)
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            let firstName = location.firstName
            let lastName = location.lastName
            let mediaURL = location.mediaURL
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(firstName) \(lastName)"
            annotation.subtitle = mediaURL
            
            annotations.append(annotation)
        }
        
        self.mapView.addAnnotations(annotations)
    }

    
    func setup () {
       var annotations = [MKPointAnnotation]()
        mapView.removeAnnotations(annotations)
        annotations.removeAll()
        
            for data in locations {
                    let lat = CLLocationDegrees(data.latitude ?? 0.0)
                    let long = CLLocationDegrees(data.longitude ?? 0.0)
                    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    let firstName = data.firstName
                    let lastName = data.lastName
                    let mediaURL = data.mediaURL
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.title = "\(firstName) \(lastName)"
                    annotation.subtitle = mediaURL
                    annotations.append(annotation)
                }
        self.mapView.addAnnotations(annotations)
            }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .blue
            pinView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
        }
    

    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let toOpen = view.annotation?.subtitle! {
                UIApplication.shared.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
            }
        }
    }
    
    
    
    
}
