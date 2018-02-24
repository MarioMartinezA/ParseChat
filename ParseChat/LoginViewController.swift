//
//  LoginViewController.swift
//  ParseChat
//
//  Created by Mario Martinez on 2/23/18.
//  Copyright © 2018 csumb. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func registerUser() {
        let newUser = PFUser()
        
        newUser.username = usernameLabel.text
        newUser.password = passwordLabel.text
        
        if (usernameLabel.text?.isEmpty)! {
            alertMessage(title: "Username Required", message: "Please enter a username")
        } else if (passwordLabel.text?.isEmpty)! {
            alertMessage(title: "Password Required", message: "Please enter a password")
        } else {
            newUser.signUpInBackground { (success: Bool, error: Error?) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    print("User Registered successfully")
                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
                    
                }
            }
        }
    }
    
    @IBAction func loginUser(_ sender: Any) {
        let username = usernameLabel.text ?? ""
        let password = passwordLabel.text ?? ""
        
        if (usernameLabel.text?.isEmpty)! {
            alertMessage(title: "Username Required", message: "Please enter a username")
        } else if (passwordLabel.text?.isEmpty)! {
            alertMessage(title: "Password Required", message: "Please enter a password")
        } else {
            PFUser.logInWithUsername(inBackground: username, password: password) { (user: PFUser?, error: Error?) in
                if let error = error {
                    print("User login failed:\(error.localizedDescription)")
                } else {
                    print("User Logged in successfully")
                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
                }
            }
        }
    }

    @IBAction func signUp(_ sender: Any) {
        registerUser()
    }
    
    func alertMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) {(action) in }
        
        alertController.addAction(OKAction)
        
        present(alertController, animated: true) { }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
