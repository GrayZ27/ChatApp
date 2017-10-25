//
//  circleImage.swift
//  ChatApp
//
//  Created by Gray Zhen on 10/25/17.
//  Copyright © 2017 GrayStudio. All rights reserved.
//

import UIKit

class circleImage: UIImageView {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
        
    }
    
    func setupView() {
        self.layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true
    }

}
