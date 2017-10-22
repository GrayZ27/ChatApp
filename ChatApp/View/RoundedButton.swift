//
//  RoundedButton.swift
//  ChatApp
//
//  Created by Gray Zhen on 10/22/17.
//  Copyright © 2017 GrayStudio. All rights reserved.
//

import UIKit

//@IBDesignable
class RoundedButton: UIButton {

    @IBInspectable var cornerRadius: CGFloat = 5.0 {
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
    }
    
    func setupView(){
        self.layer.cornerRadius = cornerRadius
    }

}
