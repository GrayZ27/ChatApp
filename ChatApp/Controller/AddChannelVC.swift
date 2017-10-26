//
//  AddChannelVC.swift
//  ChatApp
//
//  Created by Gray Zhen on 10/26/17.
//  Copyright © 2017 GrayStudio. All rights reserved.
//

import UIKit

class AddChannelVC: UIViewController {

    //IBOutlets
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var descriptionTxt: UITextField!
    
    //IBActions
    @IBAction func closeBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createChannelBtnPressed(_ sender: Any) {
        
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        
    }
    
    func setupView() {
        
        nameTxt.attributedPlaceholder = NSAttributedString(string: "channel name", attributes: [NSAttributedStringKey.foregroundColor : PLACEHOLDER_COLOR])
        descriptionTxt.attributedPlaceholder = NSAttributedString(string: "description", attributes: [NSAttributedStringKey.foregroundColor : PLACEHOLDER_COLOR])
        
        let closeTap = UITapGestureRecognizer(target: self, action: #selector(AddChannelVC.closeTap(_:)))
        view.addGestureRecognizer(closeTap)
        
    }
    
    @objc func closeTap(_ recognizer: UITapGestureRecognizer){
        dismiss(animated: true, completion: nil)
    }

}
