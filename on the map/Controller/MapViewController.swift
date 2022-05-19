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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    @IBAction func logoutButtonAction(_ sender: Any) {
        udacityClient.logout{ (results, error)  in
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
