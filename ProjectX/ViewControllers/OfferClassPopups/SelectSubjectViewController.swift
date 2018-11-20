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
    
    @IBAction func selectButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        let vc = presentingViewController as! OfferClassViewController
        if subjectTextField.text?.isEmpty ?? true{
            vc.subject = nil
        } else if let subject = subjectTextField.text{
            vc.subject = subject
        }
        vc.offerClassTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        popupView.layer.cornerRadius = 20
        
        subjectTextField.delegate = self
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
