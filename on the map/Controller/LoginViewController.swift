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
        loginWithFacebook.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        EmailTextField.text = ""
        PasswordTextField.text = ""
        activityIndicator.isHidden = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        setIndicator(false)
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        UIApplication.shared.open(udacityClient.EndPoints.getUdacitySignUpPage.url, options: [:], completionHandler: nil)
    }
    
    @IBAction func loginAction(_ sender: Any) {
        setIndicator(true)
        udacityClient.login(username: self.EmailTextField.text ?? "", password: self.PasswordTextField.text ?? "", completion: handleLoginResponse(success:error:))
      
    }
    
 
                            
    func handleLoginResponse (success: Bool, error: Error?) -> Void  {
            if success {
                //performSegue(withIdentifier: "loginNavigation", sender: nil)
                performSegue(withIdentifier: "loginNavigation", sender: nil)
            }
            else {
                DispatchQueue.main.async {
                    self.showLoginFailure(message : error?.localizedDescription ?? "")
                }
            }
        }
    
    
    func setIndicator(_ isFinding: Bool) {
        if isFinding {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    
    func showLoginFailure(message: String) {
        let alert = UIAlertController(title: "Authentication Error", message: "Email or Password invalid", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
        NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }


}

