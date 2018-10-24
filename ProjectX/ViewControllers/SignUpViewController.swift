//
//  SignUpViewController.swift
//  ProjectX
//
//  Created by Anthony Lee on 10/23/18.
//  Copyright © 2018 projectX. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func accountCreated(_ sender: Any) {
        let user = PFUser()
        user.username = usernameTextField.text
        user.password = passwordTextField.text
        user.signUpInBackground { (success
            , error) in
            if success{
                print("User Created")
                self.performSegue(withIdentifier: "SignUpAndLogin", sender: nil)
                //                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            } else {
                print(error?.localizedDescription)
            }
        }
    }
    
    @IBAction func cancelSignUp(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
