//
//  SelectCategoryViewController.swift
//  ProjectX
//
//  Created by Anthony Lee on 11/18/18.
//  Copyright © 2018 projectX. All rights reserved.
//

import UIKit

class SelectCategoryViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var category : Category?
    var titles = Constants.categories
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        popupView.layer.cornerRadius = 20
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        let vc = presentingViewController as! OfferClassViewController
        vc.category = nil
        vc.offerClassTableView.reloadData()
    }
    
    @IBOutlet weak var popupView: UIView!
    
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
