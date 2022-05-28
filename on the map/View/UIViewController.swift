//
//  UIViewController.swift
//  on the map
//
//  Created by Daniel Felipe Valencia Rodriguez on 21/05/22.
//

import Foundation
import UIKit


extension UIViewController {
    
    func buttonEnabled(_ enabled: Bool, button: UIButton) {
        if enabled {
            button.isEnabled = true
            
        } else {
            
            button.isEnabled = false
        }
    }
    
    func showAlert(message: String, title: String) {
        let alertVC = UIAlertController (title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true)
}
    
    //open links
    
    func openLink(_ url: String) {
        guard let url = URL(string: url), UIApplication.shared.canOpenURL(url)
            else {
                showAlert(message: "Cannot open link", title: "Invalid URL")
                return
        }
}
    
    func showFailure(message: String) {
        let alert = UIAlertController(title: "ALERT", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
        NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
