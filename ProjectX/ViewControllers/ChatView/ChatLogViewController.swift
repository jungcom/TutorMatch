//
//  ChatLogViewController.swift
//  ProjectX
//
//  Created by Anthony Lee on 12/1/18.
//  Copyright © 2018 projectX. All rights reserved.
//

import UIKit
import Firebase

class ChatLogViewController: UICollectionViewController, UITextFieldDelegate {
    
    var post :Post?{
        didSet{
            navigationItem.title = post?.userFirstName
        }
    }
    
    lazy var inputTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter message..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView.backgroundColor = UIColor.white
        
        setupUI()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func setupUI(){
        self.tabBarController?.tabBar.isHidden = true
        
        let containerView = UIView()
        containerView.backgroundColor = UIColor.white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(containerView)
        
        //Constraints
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        //Send button
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        containerView.addSubview(sendButton)
        
        //x,y,w,h
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        //TextField
        containerView.addSubview(inputTextField)
        //x,y,w,h
        inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant:8).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        
        //Separator line
        let separatorLine = UIView()
        separatorLine.backgroundColor = UIColor.init(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(separatorLine)
        //x,y,w,h
        separatorLine.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        separatorLine.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        separatorLine.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        separatorLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    @objc func handleSend(){
        let ref = Database.database(url: Constants.databaseURL).reference().child("Messages")
        let childRef = ref.childByAutoId()
        
        //message values
        let toId = self.post!.user!
        let fromId = Auth.auth().currentUser!.uid
        let timestamp = Int(NSDate().timeIntervalSince1970)
        let values = ["text": inputTextField.text!, "toId": toId, "fromId": fromId, "timestamp":timestamp] as [String : Any]
        
        childRef.updateChildValues(values, withCompletionBlock: { (error, ref) in
            if error != nil{
                print(error!)
                return
            }
            
            guard let messageId = childRef.key else { return }
            
            let userMessagesRef = Database.database().reference(fromURL: Constants.databaseURL).child("user-messages").child(fromId).child(messageId)
            userMessagesRef.setValue(1)
            
            let recipientUserMessagesRef = Database.database().reference(fromURL: Constants.databaseURL).child("user-messages").child(toId).child(messageId)
            recipientUserMessagesRef.setValue(1)
            
        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
}
