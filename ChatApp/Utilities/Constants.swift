//
//  Constants.swift
//  ChatApp
//
//  Created by Gray Zhen on 10/19/17.
//  Copyright © 2017 GrayStudio. All rights reserved.
//

import Foundation

typealias CompletionHandler = (_ Success: Bool) -> ()

//URL Constants
let BASE_URL = "https://chatappgzv1.herokuapp.com/v1/"
let URL_REGISTER = "\(BASE_URL)account/register"
let URL_LOGIN = "\(BASE_URL)account/login"
let URL_ADDUSER = "\(BASE_URL)user/add"

//segue
let TO_LOGIN = "toLoginView"
let TO_CREATE_ACCOUNT = "toCreateAcctVC"
let TO_AVATAR_CHOOSE = "toAvatarChoose"
let UNWIND_TO_CHANNEL = "unwindToChannelVC"

//user default
let TOKEN_KEY = "token"
let LOGGED_IN_KEY = "loggedIn"
let USER_EMAIL = "userEmail"

//Header
let HEADER = ["Content-Type": "application/json; charset=utf-8"]

//Colors
let PLACEHOLDER_COLOR = #colorLiteral(red: 0.1984519475, green: 0.659694549, blue: 0.8852669373, alpha: 0.4)

//Notification
let NOTIF_USER_DATA_DID_CHANGE = Notification.Name("notifUserDataChanged")
