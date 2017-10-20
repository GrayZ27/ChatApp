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
let BASE_URL = "https://chatappgz.herokuapp.com/v1/"
let URL_REGISTER = "\(BASE_URL)account/register"

//segue
let TO_LOGIN = "toLoginView"
let TO_CREATE_ACCOUNT = "toCreateAcctVC"

let UNWIND_TO_CHANNEL = "unwindToChannelVC"


//user default
let TOKEN_KEY = "token"
let LOGGED_IN_KEY = "loggedIn"
let USER_EMAIL = "userEmail"
