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
    
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
        }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            }
    }
    
    
    
    

    @IBAction func logoutButtonAction(_ sender: Any) {
        udacityClient.logout{ (results, error)  in
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
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
                mapView.addAnnotations(annotations)
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
    
    func mapView(_ _mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let open = view.annotation?.subtitle {
                openLink(open ?? "")
            }
        }
    }
    
    
}
