//
//  ViewController.swift
//  ProjectX
//
//  Created by Anthony Lee on 10/23/18.
//  Copyright © 2018 projectX. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    @IBOutlet weak var errorTextLabel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupUI()
    }
    
    func setupUI(){
        //Set Background Image
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "purple")
        backgroundImage.contentMode = .scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        
        //Set Delegates
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
        //Set Font Attributes
        usernameTextField.textColor = UIColor.white
        passwordTextField.textColor = UIColor.white
        
        //Set Placeholder Attributes
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font : UIFont(name: "Courier New", size: 17)!,
            ]
        
        usernameTextField.attributedPlaceholder = NSAttributedString(string: "Username", attributes:attributes)
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes:attributes)
        
        //Add Bottom Border
        let border = LoginViewController.createBottomBorder(usernameTextField)
        let border2 = LoginViewController.createBottomBorder(passwordTextField)
        usernameTextField.layer.addSublayer(border)
        usernameTextField.layer.masksToBounds = true
        passwordTextField.layer.addSublayer(border2)
        passwordTextField.layer.masksToBounds = true
        
        //Add Icons to TextFields
        let userIcon = UIImage(named: "username_icon")
        let passwordIcon = UIImage(named: "password_icon")
        LoginViewController.setTextFieldImage(userIcon, textField: usernameTextField)
        LoginViewController.setTextFieldImage(passwordIcon, textField: passwordTextField)
        
        //set button Borders
        logInButton.layer.cornerRadius = 15
        logInButton.layer.borderWidth = 1.0
        logInButton.layer.borderColor = UIColor.white.cgColor
    }
    
    @IBAction func signIn(_ sender: Any) {
        let email = usernameTextField.text
        let password = passwordTextField.text
        
        guard email != "" && password != "" else{
            self.errorTextLabel.text = "Empty email/password field"
            return
        }
        
        Auth.auth().signIn(withEmail: email!, password: password!, completion: { (user, error) in
            guard let _ = user else {
                if let error = error {
                    if let errCode = AuthErrorCode(rawValue: error._code){
                        switch (errCode){
                        case .userNotFound:
                            self.errorTextLabel.text = "User account not found"
                        case .wrongPassword:
                            self.errorTextLabel.text = "Incorrect password"
                        case .invalidEmail:
                            self.errorTextLabel.text = "Invalid email"
                        default:
                            self.errorTextLabel.text = "An error has occured. Please try again"
                        }
                    }
                    print("Error: \(error.localizedDescription)")
                }
                return
            }
            self.signInTo()
        })
    }
    
    @IBAction func tapDismissKeyboard(_ sender: UITapGestureRecognizer) {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    func signInTo(){
        self.performSegue(withIdentifier: "toLearnOrTeach", sender: nil)
    }
}

//UI Setup and TextFieldDelegates
extension LoginViewController : UITextFieldDelegate{
    static func createBottomBorder(_ textField : UITextField) -> CALayer{
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.white.cgColor
        border.frame = CGRect(x: 10, y: textField.frame.size.height - width, width: textField.frame.size.width, height: textField.frame.size.height)
        border.borderWidth = width
        return border
    }
    
    static func setTextFieldImage(_ userIcon: UIImage?, textField: UITextField) {
        let image = UIImageView(image: userIcon)
        image.frame = CGRect(x: 0.0, y: 0.0, width: userIcon!.size.width + 20, height: (userIcon?.size.height)!)
        image.contentMode = .scaleAspectFit
        image.tintColor = UIColor.white
        textField.leftView = image
        textField.leftViewMode = .always
    }
    
    //MARK: TextField Delegates
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

