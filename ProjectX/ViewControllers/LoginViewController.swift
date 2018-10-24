//
//  ViewController.swift
//  ProjectX
//
//  Created by Anthony Lee on 10/23/18.
//  Copyright © 2018 projectX. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func signIn(_ sender: Any) {
        PFUser.logInWithUsername(inBackground: usernameTextField.text!, password: passwordTextField.text!) { (user, error) in
            if user != nil{
                print("Logged In!")
                self.performSegue(withIdentifier: "toLearnOrTeach", sender: nil)
            } else {
                print("\(error?.localizedDescription)")
            }
        }
    }
}

