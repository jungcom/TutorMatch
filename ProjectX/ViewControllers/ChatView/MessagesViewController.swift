//
//  MessagesViewController.swift
//  ProjectX
//
//  Created by Anthony Lee on 12/3/18.
//  Copyright © 2018 projectX. All rights reserved.
//

import UIKit
import Firebase

class MessagesViewController: UITableViewController {

    let cellId = "cellId"
    var messages = [Message]()
    var messagesDictionary = [String:Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        tableView.rowHeight = 72
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //observeMessages()
        observeUserMessages()
        
        //Show tab bar
        self.tabBarController?.tabBar.isHidden = false
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func observeUserMessages(){
        
        messages.removeAll()
        messagesDictionary.removeAll()
        tableView.reloadData()
        
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        
        let ref = Database.database().reference(fromURL: Constants.databaseURL).child("user-messages").child(userId)
        
        ref.observe(.childAdded, with: { (snapshot) in
            let messageId = snapshot.key
            let messageRef = Database.database().reference(fromURL: Constants.databaseURL).child("Messages").child(messageId)
            
            messageRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String:AnyObject]{
                    let message = Message()
                    message.setValuesForKeys(dictionary)
                    
                    if let chatPartnerId = message.chatPartnerId(){
                        self.messagesDictionary[chatPartnerId] = message
                        self.messages = Array(self.messagesDictionary.values)
                        
                        //sort array in terms of time
                        self.messages.sort(by: { (m1, m2) -> Bool in
                            //descending time order
                            return m1.timestamp?.intValue > m2.timestamp?.intValue
                        })
                    }
                    
                    //handle reloading tableview with a delay
                    self.timer?.invalidate()
                    self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
                }
                
            }, withCancel: nil)
        }, withCancel: nil)
    }
    
    //Handle reloading tableview Bug
    var timer: Timer?
    
    @objc func handleReloadTable() {
        //this will crash because of background thread, so lets call this on main thread
        DispatchQueue.main.async(execute: {
            print("we reloaded the table")
            self.tableView.reloadData()
        })
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesDictionary.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        let message = messages[indexPath.row]
        cell.message = message
        cell.profileImageView.image = UIImage(named: "mockPerson")
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //showChatLog(Post)
        let message = messages[indexPath.row]
        
        guard let chatPartnerId = message.chatPartnerId() else {
            return
        }
        
        let ref = Database.database().reference(fromURL: Constants.databaseURL).child("users").child(chatPartnerId)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot)
            guard let dictionary = snapshot.value as? [String:AnyObject] else {
                return
            }
            let user = User()
            user.uid = chatPartnerId
            user.setValuesForKeys(dictionary)
            self.showChatLog(user)
        }, withCancel: nil)
    }
    
    func showChatLog(_ user:User){
        let chatlogVC = ChatLogViewController(collectionViewLayout:UICollectionViewFlowLayout())
        chatlogVC.user = user
        self.navigationController?.pushViewController(chatlogVC, animated: true)
    }
}

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}
