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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loginWithFacebook: UILabel!
    
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
    
    
    @IBAction func loginAction(_ sender: Any) {
        setLoggingIn(true)
        udacityClient.login(username: self.EmailTextField.text ?? "", password: self.PasswordTextField.text ?? "", completion: handleLoginResponse(success:error:))
      
    }
    
 
                            
    func handleLoginResponse (success: Bool, error: Error?) -> Void  {
            if success {
                performSegue(withIdentifier: "loginNavigation", sender: nil)
            }
            else {
                DispatchQueue.main.async {
                    self.showLoginFailure(message : error?.localizedDescription ?? "")
                }
            }
        }
    
    
    func setLoggingIn(_ loggingIn: Bool) {
        if loggingIn {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        EmailTextField.isEnabled = !loggingIn
        PasswordTextField.isEnabled = !loggingIn
        LoginButton.isEnabled = !loggingIn
        loginWithFacebook.isEnabled = !loggingIn
    }
    
    func showLoginFailure(message: String) {
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }


}

