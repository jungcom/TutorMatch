//
//  ChatLogViewController.swift
//  ProjectX
//
//  Created by Anthony Lee on 12/1/18.
//  Copyright © 2018 projectX. All rights reserved.
//

import UIKit
import Firebase

class ChatLogViewController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout {
    
    var messages = [Message]()
    
    var post :Post?{
        didSet{
            navigationItem.title = post?.userFirstName
            toId = post?.user
            
            observeMessages()
        }
    }
    
    func observeMessages(){
        guard let uid = Auth.auth().currentUser?.uid, let toId = toId else {
            return
        }
        let ref = Database.database().reference(fromURL: Constants.databaseURL).child("user-messages").child(uid).child(toId)
        
        ref.observe(.childAdded, with: { (snapshot) in
            
            let msgId = snapshot.key
            let msgRef = Database.database().reference(fromURL: Constants.databaseURL).child("Messages").child(msgId)
            msgRef.observeSingleEvent(of: .value, with: { (snapshot) in
                //Each message
                
                guard let dictionary = snapshot.value as? [String : AnyObject] else {
                    return
                }
                
                let message = Message()
                message.setValuesForKeys(dictionary)
                print(message.text)
                
                //messages on the right
                if message.chatPartnerId() == self.toId{
                    self.messages.append(message)
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
                
                
            }, withCancel: nil)
        }, withCancel: nil)
    }
    
    var user : User?{
        didSet{
            toId = user?.uid
            observeMessages()
        }
    }
    
    var toId : String?
    
    let cellId = "cellId"
    
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
        navigationItem.title = user?.firstName
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 58, right: 0)
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = UIColor.white
        collectionView.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        
        setupUI()
        
        setupKeyboardObservers()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupKeyboardObservers(){

        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
            
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc func handleKeyboardWillShow(_ notification: Notification) {
        
        let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        let keyboardDuration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        
        let bottomPadding = view.safeAreaInsets.bottom
        containerViewBottomAnchor?.constant = -(keyboardFrame!.height-bottomPadding)
        UIView.animate(withDuration: keyboardDuration!, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    @objc func handleKeyboardWillHide(_ notification: Notification) {
        let keyboardDuration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        
        containerViewBottomAnchor?.constant = 0
        UIView.animate(withDuration: keyboardDuration!, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        cell.backgroundColor = UIColor.white
        let message = messages[indexPath.item]
        cell.textView.text = message.text
        
        setupCell(message, cell)
        
        //Modify cell width
        if let txt = message.text{
            cell.bubbleWidthAnchor?.constant = estimateFrameForText(txt).width + 32
        }
        
        return cell
    }
    
    fileprivate func setupCell(_ message: Message, _ cell: ChatMessageCell) {
        
        if let profileImageUrl = self.user?.profileImageUrl {
            cell.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
        }
        
        if message.fromId == Auth.auth().currentUser?.uid{
            cell.bubbleView.backgroundColor = Constants.purple
            cell.textView.textColor = UIColor.white
            cell.profileImageView.isHidden = true
            cell.bubbleViewRightAnchor?.isActive = true
            cell.bubbleViewLeftAnchor?.isActive = false
        } else {
            cell.bubbleView.backgroundColor = Constants.lightGray
            cell.textView.textColor = UIColor.black
            cell.profileImageView.isHidden = false
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height : CGFloat = 80
        
        //get estimated height
        if let text = messages[indexPath.item].text {
            height = estimateFrameForText(text).height + 20
        }
        
        //estimated height
        return CGSize(width: view.frame.width, height: height)
    }
    
    private func estimateFrameForText(_ text:String) -> CGRect{
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont.systemFont(ofSize: 16)]), context: nil)
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    var containerViewBottomAnchor: NSLayoutConstraint?
    
    func setupUI(){
        let tabBarHeight = self.tabBarController?.tabBar.frame.height
        print(tabBarHeight!)
        self.tabBarController?.tabBar.barTintColor = .white
        self.tabBarController?.tabBar.backgroundColor = .white
        self.tabBarController?.tabBar.isHidden = true
        self.tabBarController?.tabBar.isTranslucent = true
        
        
        let containerView = UIView()
        containerView.backgroundColor = UIColor.white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(containerView)
        
        //Constraints
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerViewBottomAnchor = containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
//        containerViewBottomAnchor = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)

        containerViewBottomAnchor?.isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.08).isActive = true
        
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
        inputTextField.returnKeyType = .send
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
        
        if inputTextField.text == ""{
            return
        }
        
        let ref = Database.database(url: Constants.databaseURL).reference().child("Messages")
        let childRef = ref.childByAutoId()
        
        //message values
        let toId = self.toId!
        let fromId = Auth.auth().currentUser!.uid
        let timestamp = Int(NSDate().timeIntervalSince1970)
        let values = ["text": inputTextField.text!, "toId": toId, "fromId": fromId, "timestamp":timestamp] as [String : Any]
        
        childRef.updateChildValues(values, withCompletionBlock: { (error, ref) in
            if error != nil{
                print(error!)
                return
            }
            
            //clear textfield input
            self.inputTextField.text = nil
            
            guard let messageId = childRef.key else { return }
            
            let userMessagesRef = Database.database().reference(fromURL: Constants.databaseURL).child("user-messages").child(fromId).child(toId).child(messageId)
            userMessagesRef.setValue(1)
            
            let recipientUserMessagesRef = Database.database().reference(fromURL: Constants.databaseURL).child("user-messages").child(toId).child(fromId).child(messageId)
            recipientUserMessagesRef.setValue(1)
            
        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
    guard let input = input else { return nil }
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
    return input.rawValue
}
