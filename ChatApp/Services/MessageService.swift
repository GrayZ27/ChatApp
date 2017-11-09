//
//  MessageService.swift
//  ChatApp
//
//  Created by Gray Zhen on 10/26/17.
//  Copyright © 2017 GrayStudio. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class MessageService {
    
    static let instance = MessageService()
    
    var channels = [Channel]()
    var messages = [Message]()
    var selectedChannel : Channel?
    
    func findAllChannels(completion: @escaping CompletionHandler) {
        
        Alamofire.request(URL_GET_CHANNELS, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: HEADER_BEARER).responseJSON { (response) in
            
            if response.result.error == nil {
                
                guard let data = response.data else { return }
                
                //New Way on Swift 4, need change the variables on Channel.swift same as what the JSON return, also conform the struct Channel to Decodeable in Channel.swift
//                do {
//                    self.channels = try JSONDecoder().decode([Channel].self, from: data)
//                }catch let error {
//                    debugPrint(error)
//                }
//
//                print(self.channels)
     
                if let json = JSON(data: data).array {

                    for item in json {
                        let name = item["name"].stringValue
                        let description = item["description"].stringValue
                        let id = item["_id"].stringValue
                        let channel = Channel.init(channelTitle: name, channelDescription: description, id: id)
                        self.channels.append(channel)
                    }
                    NotificationCenter.default.post(name: NOTIF_CHANNEL_LOADED, object: nil)
                    completion(true)
                }
                
            }else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
            
        }
        
    }
    
    func findAllMessageForChannel(channelId: String, completion: @escaping CompletionHandler) {
        
        Alamofire.request("\(URL_GET_MESSAGES)\(channelId)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: HEADER_BEARER).responseJSON { (response) in
            
            if response.result.error == nil {
                self.clearMessages()
                
                guard let data = response.data else { return }
                if let json = JSON(data: data).array {
                    for item in json {
                        let messageBody = item["messageBody"].stringValue
                        let channelId = item["channelId"].stringValue
                        let userName = item["userName"].stringValue
                        let userAvatar = item["userAvatar"].stringValue
                        let userAvatarColor = item["userAvatarColor"].stringValue
                        let id = item["_id"].stringValue
                        let timeStamp = item["timeStamp"].stringValue
                        
                        let message = Message(message: messageBody, userName: userName, channelId: channelId, userAvatar: userAvatar, userAvatarColor: userAvatarColor, id: id, timeStamp: timeStamp)
                        self.messages.append(message)
                    }
                    print(self.messages)
                    completion(true)
                }
            }else{
                debugPrint(response.result.error as Any)
                completion(false)
            }
        }
    }
    
    func clearMessages() {
        messages.removeAll()
    }
    
    func clearChannels() {
        channels.removeAll()
    }
    
}
