//
//  ChatVC.swift
//  ChatApp
//
//  Created by Gray Zhen on 10/12/17.
//  Copyright © 2017 GrayStudio. All rights reserved.
//

import UIKit

class ChatVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    //IBOutlets
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var channelNameLbl: UILabel!
    @IBOutlet weak var messageTxtBox: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var typingUserLbl: UILabel!
    
    //variable
    var isTyping = false

    override func viewDidLoad() {
        super.viewDidLoad()
        messageTxtBox.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 90
        tableView.rowHeight = UITableViewAutomaticDimension
        let tap = UITapGestureRecognizer(target: self, action: #selector(ChatVC.handleTap))
        view.addGestureRecognizer(tap)
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.userDataDidChanged(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.channelChanged(_:)), name: NOTIF_CHANNEL_SELECTED, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.keyboardWillChange(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        if AuthService.instance.isLoggedIn {
            AuthService.instance.findUserByEmail(completion: { (success) in
                if success {
                    NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                }
            })
        }
        
        SocketService.instance.getChatMessage { (newMessage) in
            if newMessage.channelId == MessageService.instance.selectedChannel?.id && AuthService.instance.isLoggedIn {
                MessageService.instance.messages.append(newMessage)
                self.tableView.reloadData()
                self.scrollMessageOnTableView()
            }
        }
        
        SocketService.instance.getTypingUsers { (typingUsers) in
            
            guard let channelId = MessageService.instance.selectedChannel?.id else { return }
            var names = ""
            var numberOfTypers = 0
            
            for (typingUser, channel) in typingUsers {
                if channel == channelId && typingUser != UserDataService.instance.name {
                    if names == "" {
                        names = typingUser
                    }else {
                        names = "\(names), \(typingUser)"
                    }
                    numberOfTypers += 1
                }
            }
            
            if numberOfTypers > 0 && AuthService.instance.isLoggedIn {
                var verb = "is"
                if numberOfTypers > 1 {
                    verb = "are"
                }
                self.typingUserLbl.text = "\(names) \(verb) typing now"
            }else {
                self.typingUserLbl.text = ""
            }
            
        }
        
    }
  
    //functions for NotificationCenter #selector -------------------------------------------------------------
    @objc func userDataDidChanged(_ notif: Notification) {
        
        if AuthService.instance.isLoggedIn {
            onLoginGetMessage()
        }else {
            channelNameLbl.text = "Please Login"
            tableView.reloadData()
        }
        
    }
    
    @objc func channelChanged(_ notif: Notification) {
        updateWithChannelSelected()
    }
    
    @objc func keyboardWillChange(_ notification: Notification) {
        
        let userInfo = notification.userInfo!
        let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! Double
        let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as! UInt
        let curFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let targetFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let deltaY = targetFrame.origin.y - curFrame.origin.y
        
        UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: UIViewKeyframeAnimationOptions(rawValue: curve), animations: {
            self.view.frame.origin.y += deltaY
        }) { (success) in
            if success {
                self.view.layoutIfNeeded()
            }
        }
        
    }
    //functions for NotificationCenter #selector -------------------------------------------------------------
    
    //functions for dismiss the keyboard----------------------------------
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendMessageOut()
        view.endEditing(true)
        return true
    }
    //functions for dismiss the keyboard----------------------------------
   
    
    func updateWithChannelSelected() {
        let channelName = MessageService.instance.selectedChannel?.channelTitle ?? ""
        channelNameLbl.text = "#\(channelName)"
        getMessages()
    }
    
    func onLoginGetMessage() {
        MessageService.instance.findAllChannels { (success) in
            if success {
        
                if MessageService.instance.channels.count > 0 {
                    MessageService.instance.selectedChannel = MessageService.instance.channels[0]
                    self.updateWithChannelSelected()
                }else {
                    self.channelNameLbl.text = "No Channels Yet!"
                }
                
            }
        }
    }
    
    func getMessages() {
        
        guard let channelId = MessageService.instance.selectedChannel?.id else { return }
        MessageService.instance.findAllMessageForChannel(channelId: channelId) { (success) in
            if success {
                self.tableView.reloadData()
                self.scrollMessageOnTableView()
            }
        }
        
    }
    
    func sendMessageOut() {
        if AuthService.instance.isLoggedIn {
            
            guard let channelId = MessageService.instance.selectedChannel?.id else { return }
            guard let message = messageTxtBox.text else { return }
            
            SocketService.instance.addMessage(messageBody: message, userId: UserDataService.instance.id, channelId: channelId, completion: { (success) in
                if success {
                    self.messageTxtBox.text = ""
                    self.messageTxtBox.resignFirstResponder()
                    SocketService.instance.socket.emit("stopType", UserDataService.instance.name, channelId)
                }
            })
        }
    }
    
    //table view functions----------------------------------------------------------------------------------------------------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.instance.messages.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if MessageService.instance.messages[indexPath.row].userId == UserDataService.instance.id {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as? MessageCell {
                let message = MessageService.instance.messages[indexPath.row]
                cell.configureCell(message: message)
                return cell
            }else {
                return UITableViewCell()
            }
        }else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as? MessageCell {
                let message = MessageService.instance.messages[indexPath.row]
                cell.configureCell(message: message)
                return cell
            }else {
                return UITableViewCell()
            }
        }
    }

    func scrollMessageOnTableView() {
        if MessageService.instance.messages.count > 0 {
            let endIndex = IndexPath(row: MessageService.instance.messages.count - 1, section: 0)
            self.tableView.scrollToRow(at: endIndex, at: .bottom, animated: false)
        }
    }
    //table view functions----------------------------------------------------------------------------------------------------
    
    //IBAction
    @IBAction func sentMsgBtnPressed(_ sender: Any) {
        sendMessageOut()
    }
    
    @IBAction func messageBoxEditing(_ sender: Any) {
        
        guard let channelId = MessageService.instance.selectedChannel?.id else { return }
        
        if messageTxtBox.text == "" {
            isTyping = false
            SocketService.instance.socket.emit("stopType", UserDataService.instance.name, channelId)
        }else {
            if isTyping == false {
                SocketService.instance.socket.emit("startType", UserDataService.instance.name, channelId)
            }
            isTyping = true
        }
        
    }
    
}
