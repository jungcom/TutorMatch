//
//  SelectSubjectViewController.swift
//  ProjectX
//
//  Created by Anthony Lee on 11/20/18.
//  Copyright © 2018 projectX. All rights reserved.
//

import UIKit

class SelectSubjectViewController: UIViewController {

    var subject:String?
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var subjectTextField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        subjectTextField.delegate = self
        setupUIConstraints()
    }
    
    func setupUIConstraints(){
        //popUpView Constraints
        popupView.layer.cornerRadius = 20
        popupView.translatesAutoresizingMaskIntoConstraints = false
        popupView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        popupView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        popupView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        popupView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25).isActive = true
        
        //Title Constraints
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        titleLabel.topAnchor.constraint(equalTo: popupView.topAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: popupView.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: popupView.trailingAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalTo: popupView.heightAnchor, multiplier: 0.2).isActive = true
        
        //selectButton Constraints
        selectButton.translatesAutoresizingMaskIntoConstraints = false
        selectButton.heightAnchor.constraint(equalTo: popupView.heightAnchor, multiplier: 0.2).isActive = true
        selectButton.leadingAnchor.constraint(equalTo: popupView.leadingAnchor).isActive = true
        selectButton.widthAnchor.constraint(equalTo: popupView.widthAnchor, multiplier: 0.5).isActive = true
        selectButton.bottomAnchor.constraint(equalTo: popupView.bottomAnchor).isActive = true
        
        //CancelButton Constraints
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.heightAnchor.constraint(equalTo: popupView.heightAnchor, multiplier: 0.2).isActive = true
        cancelButton.trailingAnchor.constraint(equalTo: popupView.trailingAnchor).isActive = true
        cancelButton.widthAnchor.constraint(equalTo: popupView.widthAnchor, multiplier: 0.5).isActive = true
        cancelButton.bottomAnchor.constraint(equalTo: popupView.bottomAnchor).isActive = true
        
        //SubjectTextView Constraints
        subjectTextField.translatesAutoresizingMaskIntoConstraints = false
        subjectTextField.heightAnchor.constraint(equalTo: popupView.heightAnchor, multiplier: 0.2).isActive = true
        subjectTextField.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant : -10).isActive = true
        subjectTextField.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant:10).isActive = true
        subjectTextField.centerYAnchor.constraint(equalTo: popupView.centerYAnchor).isActive = true
        
    }
    
    @IBAction func selectButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        let navVc = presentingViewController as! UINavigationController
        let vc = navVc.viewControllers.first as! OfferClassViewController
        if subjectTextField.text?.isEmpty ?? true{
            vc.subject = nil
        } else if let subject = subjectTextField.text{
            vc.subject = subject
        }
        vc.offerClassTableView.reloadData()
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        subject = nil
        let navVc = presentingViewController as! UINavigationController
        let vc = navVc.viewControllers.first as! OfferClassViewController
        vc.offerClassTableView.reloadData()
    }

}

extension SelectSubjectViewController : UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.2, delay: 0,options: UIView.AnimationOptions.curveEaseOut,animations: {
            self.view.frame.origin.y = -80 // If you want to restrict the button not to repeat animation..You can enable by setting into true
            
        },completion: nil)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.2, delay: 0,options: UIView.AnimationOptions.curveEaseOut,animations: {
            self.view.frame.origin.y = 0 // If you want to restrict the button not to repeat animation..You can enable by setting into true
            
        },completion: nil)
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
