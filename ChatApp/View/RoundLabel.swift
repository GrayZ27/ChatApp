//
//  RoundLabel.swift
//  ChatApp
//
//  Created by Gray Zhen on 11/10/17.
//  Copyright © 2017 GrayStudio. All rights reserved.
//

import UIKit

class RoundLabel: UILabel {

    @IBInspectable var topInset: CGFloat = 7.0
    @IBInspectable var bottomInset: CGFloat = 7.0
    @IBInspectable var leftInset: CGFloat = 7.0
    @IBInspectable var rightInset: CGFloat = 7.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 5
        self.clipsToBounds = true
        
    }
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
    
    override var intrinsicContentSize : CGSize {
        var intrinsicSuperViewContentSize = super.intrinsicContentSize
        intrinsicSuperViewContentSize.width += leftInset + rightInset
        intrinsicSuperViewContentSize.height += topInset + bottomInset
        return intrinsicSuperViewContentSize
    }
    

}
