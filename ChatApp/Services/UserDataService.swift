//
//  UserDataService.swift
//  ChatApp
//
//  Created by Gray Zhen on 10/22/17.
//  Copyright © 2017 GrayStudio. All rights reserved.
//

import Foundation

class UserDataService {
    
    static let instance = UserDataService()
    
    public private(set) var id = ""
    public private(set) var name = ""
    public private(set) var email = ""
    public private(set) var avatarColor = ""
    public private(set) var avatarName = ""
    
    func setUserData(id: String, name: String, email: String, avatarColor: String, avatarName: String) {
        self.id = id
        self.name = name
        self.email = email
        self.avatarColor = avatarColor
        self.avatarName = avatarName
    }
    
    func setAvatarName(avatarName: String) {
        self.avatarName = avatarName
    }
    
}
