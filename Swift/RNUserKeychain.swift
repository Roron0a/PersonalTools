//
//  RNUserKeychain.swift
//  Hot-Hu
//
//  Created by mac on 4/14/17.
//  Copyright © 2017 R0R0N0A. All rights reserved.
//

import UIKit
import KeychainSwift


class RNUserKeychain {
    static let sharedInstance = RNUserKeychain()
    fileprivate let keychain = KeychainSwift()

    
    
    
    fileprivate(set) var  users:[String:LocalSecurityAccountModel] = [:]
    
    fileprivate init() {
        
    }
    
    
    func addUser(_ user:LocalSecurityAccountModel){
        if let username = user.username, let _ = user.password {
            self.users[username] = user
            self.saveUsersDict()
        } else {
            assert(false,"username & password must not be NIL")
        }
    }
    
    func addUser(_ username:String,password:String,avatar:String? = nil) {
        let user = LocalSecurityAccountModel()
        user.username = username
        user.password = password
        user.avatar = avatar
        self.addUser(user)
    }
    
    
    static let usersKey = "com.massivedynamic.testDict"
    
    func saveUsersDict() {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(self.users)
        archiver.finishEncoding()
        keychain.set(data as Data, forKey: RNUserKeychain.usersKey)
    }
    
    
    func loadUsersDict()-> [String:LocalSecurityAccountModel]{
        if users.count <= 0 {
            let data = keychain.getData(RNUserKeychain.usersKey)
            if let data = data {
                let archiver = NSKeyedUnarchiver(forReadingWith: data)
                let usersDict = archiver.decodeObject()
                archiver.finishDecoding()
                
                if let usersDict = usersDict as? [String:LocalSecurityAccountModel] {
                    self.users = usersDict
                }
            }
        }
        return self.users
    }
    
    func removeUser(_ username:String) {
        self.users.removeValue(forKey: username)
        self.saveUsersDict()
    }
    
    func removeAll() {
        self.users = [:]
        self.saveUsersDict()
    }
    
    func update(_ username:String,password:String? = nil,avatar:String? = nil) {
        if let user = self.users[username]{
            if let password = password {
                user.password = password
            }
            if let avatar = avatar {
                user.avatar = avatar
            }
            self.saveUsersDict()
        }
    }
    
    
    
    
}



//
class LocalSecurityAccountModel: NSObject,NSCoding {
    
    var username:String?
    var password:String?
    var avatar:String?
    
    override init() {
        
    }
    
    required init?(coder aDecoder:NSCoder){
        self.username = aDecoder.decodeObject(forKey: "username") as? String
        self.password = aDecoder.decodeObject(forKey: "password") as? String
        self.avatar = aDecoder.decodeObject(forKey: "avatar") as? String
        
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.username, forKey: "username")
        aCoder.encode(self.password, forKey: "password")
        aCoder.encode(self.avatar, forKey: "avatar")
    }
    
}
