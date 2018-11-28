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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        popupView.layer.cornerRadius = 20
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        hourlyPay = nil
        let vc = presentingViewController as! OfferClassViewController
        vc.offerClassTableView.reloadData()
    }
    
    @IBOutlet weak var popupView: UIView!
    
    @IBAction func selectButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        let vc = presentingViewController as! OfferClassViewController
        
        vc.hourlyPay = hourlyPay

        vc.offerClassTableView.reloadData()
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
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
