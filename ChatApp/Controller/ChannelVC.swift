//
//  ChannelVC.swift
//  ChatApp
//
//  Created by Gray Zhen on 10/12/17.
//  Copyright © 2017 GrayStudio. All rights reserved.
//

import UIKit

class ChannelVC: UIViewController {

    //IBOutlets
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var userImg: UIImageView!
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {}
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.revealViewController().rearViewRevealWidth = view.self.frame.size.width - 60
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelVC.userDataDidChanged(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
    }

    @IBAction func loginBtnPressed(_ sender: Any) {
   
        if AuthService.instance.isLoggedIn {
            let profile = ProfileVC()
            profile.modalPresentationStyle = .custom
            present(profile, animated: true, completion: nil)
        }else {
            performSegue(withIdentifier: TO_LOGIN, sender: nil)
        }
        
    }
    
    @objc func userDataDidChanged(_ notif: Notification) {
        
        if AuthService.instance.isLoggedIn {
            loginBtn.setTitle(UserDataService.instance.name, for: .normal)
            userImg.image = UIImage(named: UserDataService.instance.avatarName)
            userImg.backgroundColor = UserDataService.instance.returnUIColor(components: UserDataService.instance.avatarColor)
        }else {
            loginBtn.setTitle("Login", for: .normal)
            userImg.image = UIImage(named: "menuProfileIcon")
            userImg.backgroundColor = UIColor.clear
        }
        
    }
}
