//
//  ChatVC.swift
//  ChatApp
//
//  Created by Gray Zhen on 10/12/17.
//  Copyright © 2017 GrayStudio. All rights reserved.
//

import UIKit

class ChatVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //IBOutlets
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var channelNameLbl: UILabel!
    @IBOutlet weak var messageTxtBox: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendBtn: UIButton!
    
    //IBAction
    @IBAction func sentMsgBtnPressed(_ sender: Any) {
        
        if AuthService.instance.isLoggedIn {
        
            guard let channelId = MessageService.instance.selectedChannel?.id else { return }
            guard let message = messageTxtBox.text else { return }
            
            SocketService.instance.addMessage(messageBody: message, userId: UserDataService.instance.id, channelId: channelId, completion: { (success) in
                if success {
                    self.messageTxtBox.text = ""
                    self.messageTxtBox.resignFirstResponder()
                }
            })
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        if AuthService.instance.isLoggedIn {
            AuthService.instance.findUserByEmail(completion: { (success) in
                if success {
                    NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                }
            })
        }
    }
    
    @objc func userDataDidChanged(_ notif: Notification) {
        
        if AuthService.instance.isLoggedIn {
            onLoginGetMessage()
        }else {
            channelNameLbl.text = "Please Login"
        }
        
    }
    
    @objc func channelChanged(_ notif: Notification) {
        updateWithChannelSelected()
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    //changed table view and textfield positions when keyboard shows up
    @objc func keyboardWillShow(notification: NSNotification) {

        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue

        messageTxtBox.frame.origin.y = -(keyboardFrame.size.height)
        sendBtn.frame.origin.y = -(keyboardFrame.size.height - 5)
        
        let originFrame = self.tableView.frame
        let newHeight: CGFloat = originFrame.size.height - keyboardFrame.size.height
        self.tableView.frame = CGRect(x: originFrame.origin.x, y: originFrame.origin.y, width: originFrame.size.width, height: newHeight)
        
    }
    
    //reset when keyboard disappears
    @objc func keyboardWillHide(notification: NSNotification) {
        messageTxtBox.frame.origin.y = 0
        sendBtn.frame.origin.y = 5
    }
    
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
            }
        }
        
    }
    
    //table view functions
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
    
    
    
    
    
    
    
    
    
    
    
    
    

}
