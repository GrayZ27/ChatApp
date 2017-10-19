//
//  ChannelVC.swift
//  ChatApp
//
//  Created by Gray Zhen on 10/12/17.
//  Copyright © 2017 GrayStudio. All rights reserved.
//

import UIKit

class ChannelVC: UIViewController {

    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.revealViewController().rearViewRevealWidth = view.self.frame.size.width - 60
        
    }

    @IBAction func loginBtnPressed(_ sender: Any) {
   
        performSegue(withIdentifier: TO_LOGIN, sender: nil)
    
    }
    
}
