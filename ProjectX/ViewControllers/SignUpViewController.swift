//
//  SignUpViewController.swift
//  ProjectX
//
//  Created by Anthony Lee on 10/23/18.
//  Copyright © 2018 projectX. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController {

    @IBOutlet weak var errorTextLabel: UILabel!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
        
        //DataBase

//        let databaseURL = "https://projectx-ed29a.firebaseio.com/"
//        ref = Database.database().reference(fromURL: databaseURL)
//        ref.updateChildValues(["any": 123123])
    }
    
    func setupUI(){
        //Set Delegates
        emailTextField.delegate = self
        passwordTextField.delegate = self
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        
        //Set Font Attributes
        emailTextField.textColor = UIColor.white
        passwordTextField.textColor = UIColor.white
        firstNameTextField.textColor = UIColor.white
        lastNameTextField.textColor = UIColor.white
        
        //Set Placeholder Attributes
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font : UIFont(name: "Courier New", size: 17)!,
            ]
        
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email Address", attributes:attributes)
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes:attributes)
        firstNameTextField.attributedPlaceholder = NSAttributedString(string: "First Name", attributes:attributes)
        lastNameTextField.attributedPlaceholder = NSAttributedString(string: "Last Name", attributes:attributes)
        
        //Add Bottom Border
        let border = LoginViewController.createBottomBorder(emailTextField)
        let border2 = LoginViewController.createBottomBorder(passwordTextField)
        let border3 = LoginViewController.createBottomBorder(firstNameTextField)
        let border4 = LoginViewController.createBottomBorder(lastNameTextField)
        emailTextField.layer.addSublayer(border)
        emailTextField.layer.masksToBounds = true
        passwordTextField.layer.addSublayer(border2)
        passwordTextField.layer.masksToBounds = true
        firstNameTextField.layer.addSublayer(border3)
        firstNameTextField.layer.masksToBounds = true
        lastNameTextField.layer.addSublayer(border4)
        lastNameTextField.layer.masksToBounds = true
        
        //Add Icons to TextFields
        let userIcon = UIImage(named: "username_icon")
        let passwordIcon = UIImage(named: "password_icon")
        let emailIcon = UIImage(named: "email_icon")
        LoginViewController.setTextFieldImage(userIcon, textField: firstNameTextField)
        LoginViewController.setTextFieldImage(userIcon, textField: lastNameTextField)
        LoginViewController.setTextFieldImage(emailIcon, textField: emailTextField)
        LoginViewController.setTextFieldImage(passwordIcon, textField: passwordTextField)
        
        //set button borders
        createAccountButton.layer.cornerRadius = 15
        createAccountButton.layer.borderWidth = 1.0
        createAccountButton.layer.borderColor = UIColor.white.cgColor
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
        let email = emailTextField.text
        let password = passwordTextField.text
        Auth.auth().createUser(withEmail: email!, password: password!, completion: { (user, error) in
            guard let _ = user else {
                if let error = error {
                    if let errCode = AuthErrorCode(rawValue: error._code){
                        switch (errCode){
                        case .invalidEmail:
                            self.errorTextLabel.text = "Invalid email"
                        case .emailAlreadyInUse:
                            self.errorTextLabel.text = "Email already in use"
                        case .weakPassword:
                            self.errorTextLabel.text = "Password is weak. Try a longer password"
                        default:
                            self.errorTextLabel.text = "An error has occured. Please try again"
                        }
                    }
                    print("Error: \(error.localizedDescription)")
                }
                return
            }
            
            // if successful add user
            let databaseURL = Constants.databaseURL
            guard let uid = Auth.auth().currentUser?.uid else {
                print ("No UID")
                return
            }
            
            //Create a user and add to the Firebase database
            self.ref = Database.database().reference(fromURL: databaseURL)
            let userRef = self.ref.child("users").child(uid)
            let values = ["firstName":self.firstNameTextField.text, "lastName":self.lastNameTextField.text, "email":email]
            userRef.updateChildValues(values, withCompletionBlock: { (err, ref) in
                if err != nil{
                    print(err?.localizedDescription)
                    return
                }
                print("Saved user data to DB")
            })
            
            self.signInTo()
        })
    }
    
    @IBAction func cancelSignUp(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func signInTo(){
        self.performSegue(withIdentifier: "SignUpAndLogin", sender: nil)
    }
    
    @IBAction func tapToDismissKeyboard(_ sender: UITapGestureRecognizer) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        lastNameTextField.resignFirstResponder()
        firstNameTextField.resignFirstResponder()
    }
    
}

extension SignUpViewController : UITextFieldDelegate{
    
    
    //MARK: TextField Delegates
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == emailTextField || textField == passwordTextField{
            UIView.animate(withDuration: 0.2, delay: 0,options: UIView.AnimationOptions.curveEaseOut,animations: {
                self.view.frame.origin.y = -80 // If you want to restrict the button not to repeat animation..You can enable by setting into true
                
            },completion: nil)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == emailTextField || textField == passwordTextField{
            UIView.animate(withDuration: 0.2, delay: 0,options: UIView.AnimationOptions.curveEaseOut,animations: {
                self.view.frame.origin.y = 0 // If you want to restrict the button not to repeat animation..You can enable by setting into true
                
            },completion: nil)
        }
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
