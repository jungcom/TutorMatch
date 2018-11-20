//
//  OfferClassViewController.swift
//  ProjectX
//
//  Created by Anthony Lee on 10/28/18.
//  Copyright © 2018 projectX. All rights reserved.
//

import UIKit

class OfferClassViewController: UIViewController {
    @IBOutlet weak var offerClassTableView: UITableView!
    
    var category:Category?
    var subject:String?
    var subjectDescription:String?
    var hourlyPay:Int?
    
    var titles = ["Category","Subject","Description","Hourly Pay"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    func setupUI(){
        self.offerClassTableView.rowHeight = offerClassTableView.bounds.height/5
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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

extension OfferClassViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OfferClassTableViewCell", for: indexPath) as! OfferClassTableViewCell
        cell.titleLabel.text = titles[indexPath.row]
        switch indexPath.row {
        case 0:
            if let category = category{
                cell.selectedLabel.text = category.rawValue
            }
            break
        default: break
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            performSegue(withIdentifier: "SelectCategory", sender: nil)
        }
    }
    
    
}
