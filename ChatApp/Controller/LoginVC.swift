//
//  LoginVC.swift
//  ChatApp
//
//  Created by Gray Zhen on 10/19/17.
//  Copyright © 2017 GrayStudio. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    //IBOutlets
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       setupView()
        
    }
    
    func setupView() {
        spinner.isHidden = true
        usernameTxt.attributedPlaceholder = NSAttributedString(string: "email", attributes: [NSAttributedStringKey.foregroundColor : PLACEHOLDER_COLOR])
        passwordTxt.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedStringKey.foregroundColor : PLACEHOLDER_COLOR])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(LoginVC.handleTap))
        view.addGestureRecognizer(tap)
        
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    func spinnerAndLoginBtn() {
        
        loginBtn.isEnabled = true
        spinner.isHidden = true
        spinner.stopAnimating()
        
    }
    
    //IBActions
    @IBAction func loginBtnPressed(_ sender: Any) {
        
        loginBtn.isEnabled = false
        spinner.isHidden = false
        spinner.startAnimating()
        
        guard let email = usernameTxt.text , usernameTxt.text != "" else {
            
            spinnerAndLoginBtn()
            return
            
        }
        guard let password = passwordTxt.text , passwordTxt.text != "" else {
            
            spinnerAndLoginBtn()
            return
            
        }
        
        AuthService.instance.loginUser(email: email, password: password) { (success) in
            if success {
                AuthService.instance.findUserByEmail(completion: { (success) in
                    if success {
                        
                        NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                        self.spinnerAndLoginBtn()
                        self.dismiss(animated: true, completion: nil)
                        
                    }
                })
            }
        }
        
    }

    @IBAction func closeBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func createAcctBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_CREATE_ACCOUNT, sender: nil)
    }
}
