//
//  CreateAcctVC.swift
//  ChatApp
//
//  Created by Gray Zhen on 10/19/17.
//  Copyright © 2017 GrayStudio. All rights reserved.
//

import UIKit

class CreateAcctVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    @IBAction func closeBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: UNWIND_TO_CHANNEL, sender: nil)
    }
    
}
