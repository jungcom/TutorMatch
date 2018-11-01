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

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }
    
    func setupUI(){
        //Set Delegates
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        //Set Font Attributes
        emailTextField.textColor = UIColor.white
        passwordTextField.textColor = UIColor.white
        
        //Set Placeholder Attributes
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font : UIFont(name: "Courier New", size: 20)!,
            ]
        
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Username", attributes:attributes)
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes:attributes)
        
        //Add Bottom Border
        let border = LoginViewController.createBottomBorder(emailTextField)
        let border2 = LoginViewController.createBottomBorder(passwordTextField)
        emailTextField.layer.addSublayer(border)
        emailTextField.layer.masksToBounds = true
        passwordTextField.layer.addSublayer(border2)
        passwordTextField.layer.masksToBounds = true
        
        //Add Icons to TextFields
        let userIcon = UIImage(named: "username_icon")
        let passwordIcon = UIImage(named: "password_icon")
        LoginViewController.setTextFieldImage(userIcon, textField: emailTextField)
        LoginViewController.setTextFieldImage(passwordIcon, textField: passwordTextField)
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
        user.username = emailTextField.text
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

extension SignUpViewController : UITextFieldDelegate{
    
    //MARK: TextField Delegates
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
