//
//  TableViewController.swift
//  on the map
//
//  Created by Daniel Felipe Valencia Rodriguez on 17/05/22.
//

import Foundation
import UIKit

class TableViewController : UIViewController {
    
    @IBOutlet weak var logoutButonAction: UIBarButtonItem!
    @IBOutlet weak var dropPinButton: UIBarButtonItem!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func logoutButtonAction(_ sender: Any) {
        udacityClient.logout{ (results, error)  in
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
                
            }
        }
    }
}
