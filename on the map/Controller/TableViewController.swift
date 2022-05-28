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
    @IBOutlet weak var studentsTableView: UITableView!
    
    var indicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        indicator = UIActivityIndicatorView (style: UIActivityIndicatorView.Style.medium)
        self.view.addSubview(indicator)
        indicator.bringSubviewToFront(self.view)
        indicator.center = self.view.center
        super.viewDidLoad()
        studentsTableView.delegate = self
        studentsTableView.dataSource = self
        updateRequest()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        StudentModel.student = StudentsData.sharedInstance().students
        udacityClient.getStudentLists { (results, error) in
            StudentModel.student = results
            StudentsData.sharedInstance().students = results
            self.studentsTableView.reloadData()

            }
    }
    
    
    @IBAction func logoutButtonAction(_ sender: Any) {
        udacityClient.logout{ (results, error)  in
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
                
            }
        }
    }
    
    @IBAction func addLocationAction(_ sender: Any) {
        performSegue(withIdentifier: "addLocation1", sender: sender)
    }
    
    
    @IBAction func refreshAction(_ sender: Any) {
        updateRequest()
    }
    
    func backAction () -> Void {
        self.navigationController?.popViewController(animated: true)
    }
    
    func handleStudent(_ student: [StudentLocations]) -> Void {
        
    }
    
    func updateRequest() {
        udacityClient.getStudentLists { (results, error) in
                print (results)
            StudentsData.sharedInstance().students = results as [StudentInformation]
            self.studentsTableView.reloadData()
        }
        
    }
    
}

extension TableViewController : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentModel.student.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentTableViewCell", for: indexPath)
        let student = StudentsData.sharedInstance().students[indexPath.row]
        cell.textLabel?.text = "\(student.firstName)" + " " + "\(student.lastName)"
        cell.imageView?.image = UIImage(named: "icon_pin")
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexpath: IndexPath) {
        let student = StudentsData.sharedInstance().students[indexpath.row]
        if  !verifyUrl(urlString: student.mediaURL) {
            self.showFailure(message: "Invalid URL!")
        }
    }
    func showActivityIndicator() {
        indicator.isHidden = false
        indicator.startAnimating()
    }
    
    func hideActivityIndicator() {
        indicator.isHidden = true
        indicator.stopAnimating()
    }
    }
    
    func verifyUrl (urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url = NSURL(string: urlString)  {
                UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
            }
        }
        
        return false
    }
        


