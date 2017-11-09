//
//  ChatVC.swift
//  ChatApp
//
//  Created by Gray Zhen on 10/12/17.
//  Copyright © 2017 GrayStudio. All rights reserved.
//

import UIKit

class ChatVC: UIViewController {

    //IBOutlets
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var channelNameLbl: UILabel!
    @IBOutlet weak var messageTxtBox: UITextField!
    
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
        
        view.bindToKeyboard()
        let tap = UITapGestureRecognizer(target: self, action: #selector(ChatVC.handleTap))
        view.addGestureRecognizer(tap)
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.userDataDidChanged(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.channelChanged(_:)), name: NOTIF_CHANNEL_SELECTED, object: nil)
        
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
            
            
            
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

}
