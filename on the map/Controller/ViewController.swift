//
//  ViewController.swift
//  on the map
//
//  Created by Daniel Felipe Valencia Rodriguez on 12/05/22.
//

import UIKit

class LoginViewController: UIViewController {

    

    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var LoginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor.init(named: "GradientTop")?.cgColor, UIColor.init(named: "GradientBottom")?.cgColor]
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        EmailTextField.text = ""
        PasswordTextField.text = ""
    }


}

