//
//  ViewController.swift
//  on the map
//
//  Created by Daniel Felipe Valencia Rodriguez on 12/05/22.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor.init(named: "GradientTop")?.cgColor, UIColor.init(named: "GradientBottom")?.cgColor]
        view.layer.insertSublayer(gradientLayer, at: 0)
    }


}

