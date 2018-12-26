//
//  SelectCategoryViewController.swift
//  ProjectX
//
//  Created by Anthony Lee on 11/18/18.
//  Copyright © 2018 projectX. All rights reserved.
//

import UIKit

class SelectCategoryViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var category : Category?
    var titles = Constants.categories
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUIConstraints()
    }
    
    func setupUIConstraints(){
        
        //popUpView Constraints
        popupView.layer.cornerRadius = 20
        popupView.translatesAutoresizingMaskIntoConstraints = false
        popupView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        popupView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        popupView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        popupView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3).isActive = true
        
        //selectButton Constraints
        selectButton.translatesAutoresizingMaskIntoConstraints = false
        selectButton.topAnchor.constraint(equalTo: pickerView.bottomAnchor).isActive = true
        selectButton.leadingAnchor.constraint(equalTo: popupView.leadingAnchor).isActive = true
        selectButton.widthAnchor.constraint(equalTo: popupView.widthAnchor, multiplier: 0.5).isActive = true
        selectButton.bottomAnchor.constraint(equalTo: popupView.bottomAnchor).isActive = true
        
        //CancelButton Constraints
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.topAnchor.constraint(equalTo: pickerView.bottomAnchor).isActive = true
        cancelButton.trailingAnchor.constraint(equalTo: popupView.trailingAnchor).isActive = true
        cancelButton.widthAnchor.constraint(equalTo: popupView.widthAnchor, multiplier: 0.5).isActive = true
        cancelButton.bottomAnchor.constraint(equalTo: popupView.bottomAnchor).isActive = true
        
        //PickerView Constraints
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.topAnchor.constraint(equalTo: popupView.topAnchor).isActive = true
        pickerView.leadingAnchor.constraint(equalTo: popupView.leadingAnchor).isActive = true
        pickerView.trailingAnchor.constraint(equalTo: popupView.trailingAnchor).isActive = true
        pickerView.heightAnchor.constraint(equalTo: popupView.heightAnchor, multiplier: 0.85).isActive = true
        
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        category = nil
        let vc = presentingViewController as! OfferClassViewController
        vc.offerClassTableView.reloadData()
    }
    
    @IBAction func selectButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        let vc = presentingViewController as! OfferClassViewController
        vc.category = category
        vc.offerClassTableView.reloadData()
    }
 

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return titles.count+1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == 0{
            return ""
        }else {
            return titles[row-1].rawValue
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 0{
            category = nil
        } else {
            category = titles[row-1]
        }
    }
}
