//
//  SelectHourlyPayViewController.swift
//  ProjectX
//
//  Created by Anthony Lee on 11/20/18.
//  Copyright © 2018 projectX. All rights reserved.
//

import UIKit

class SelectHourlyPayViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var hourlyPay : String?
    var hourlyPayArray = Constants.hourlyPay
    
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
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
        pickerView.topAnchor.constraint(equalTo: popupView.topAnchor, constant:-20).isActive = true
        pickerView.leadingAnchor.constraint(equalTo: popupView.leadingAnchor).isActive = true
        pickerView.trailingAnchor.constraint(equalTo: popupView.trailingAnchor).isActive = true
        pickerView.heightAnchor.constraint(equalTo: popupView.heightAnchor, multiplier: 0.9).isActive = true
        
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        hourlyPay = nil
        let navVc = presentingViewController as! UINavigationController
        let vc = navVc.viewControllers.first as! OfferClassViewController
        vc.offerClassTableView.reloadData()
    }
    
    @IBAction func selectButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        let navVc = presentingViewController as! UINavigationController
        let vc = navVc.viewControllers.first as! OfferClassViewController
        
        vc.hourlyPay = hourlyPay

        vc.offerClassTableView.reloadData()
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return hourlyPayArray.count+1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == 0{
            return ""
        }else {
            return hourlyPayArray[row-1]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 0{
            hourlyPay = nil
        } else {
            hourlyPay = hourlyPayArray[row-1]
        }
    }
}
