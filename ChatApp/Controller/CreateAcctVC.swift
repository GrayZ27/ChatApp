//
//  CreateAcctVC.swift
//  ChatApp
//
//  Created by Gray Zhen on 10/19/17.
//  Copyright © 2017 GrayStudio. All rights reserved.
//

import UIKit

class CreateAcctVC: UIViewController {

    //IBOutlets
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passTxt: UITextField!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var createAcctBtn: UIButton!
    
    //variables
    var avatarName = "profileDefault"
    var avatarColor = "[0.5, 0.5, 0.5, 1]"
    var bgColor: UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDataService.instance.avatarName != "" {
            userImg.image = UIImage(named: UserDataService.instance.avatarName)
            avatarName = UserDataService.instance.avatarName
            if avatarName.contains("light") && bgColor == nil{
                userImg.backgroundColor = UIColor.lightGray
            }
        }
        
    }
    
    func setupView() {
        spinner.isHidden = true
        usernameTxt.attributedPlaceholder = NSAttributedString(string: "username", attributes: [NSAttributedStringKey.foregroundColor : PLACEHOLDER_COLOR])
        emailTxt.attributedPlaceholder = NSAttributedString(string: "email", attributes: [NSAttributedStringKey.foregroundColor : PLACEHOLDER_COLOR])
        passTxt.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedStringKey.foregroundColor : PLACEHOLDER_COLOR])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(CreateAcctVC.handleTap))
        view.addGestureRecognizer(tap)
        
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    //IBActions
    @IBAction func chooseAvatarBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_AVATAR_CHOOSE, sender: nil)
    }
    
    @IBAction func chooseBGColorBtnPressed(_ sender: Any) {
        let r = CGFloat(arc4random_uniform(255)) / 255
        let g = CGFloat(arc4random_uniform(255)) / 255
        let b = CGFloat(arc4random_uniform(255)) / 255
        
        bgColor = UIColor(red: r, green: g, blue: b, alpha: 1)
        UIView.animate(withDuration: 0.3){
            self.userImg.backgroundColor = self.bgColor
        }
        
        avatarColor = "[\(r), \(g), \(b), 1]"
        
    }
    
    @IBAction func createAcctBtnPressed(_ sender: Any) {
        createAcctBtn.isEnabled = false
        spinner.isHidden = false
        spinner.startAnimating()
        guard let name = usernameTxt.text, usernameTxt.text != "" else {return}
        guard let email = emailTxt.text , emailTxt.text != "" else { return }
        guard let pass = passTxt.text , passTxt.text != "" else { return }
        
        AuthService.instance.registerUser(email: email, password: pass) { (success) in
            if success {
                AuthService.instance.loginUser(email: email, password: pass, completion: { (success) in
                    if success {
                        AuthService.instance.createUser(name: name, email: email, avatarColor: self.avatarColor, avatarName: self.avatarName, completion: { (success) in
                            if success {
                                self.createAcctBtn.isEnabled = true
                                self.spinner.isHidden = true
                                self.spinner.stopAnimating()
                                self.performSegue(withIdentifier: UNWIND_TO_CHANNEL, sender: nil)
                                NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                            }
                        })
                    }
                })
            }
        }
        
    }
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: UNWIND_TO_CHANNEL, sender: nil)
    }
    
}
