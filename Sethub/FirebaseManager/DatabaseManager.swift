//
//  DatabaseManager.swift
//  InstagramClone
//
//  Created by macbook pro on 7.03.2023.
//

import FirebaseDatabase
import FirebaseStorage
import Firebase

public class DatabaseManager {
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
    //MARK: Public
    
    public func canCreateNewUser(with email: String, completion: (Bool) -> Void) {
        completion(true)
    }
    
//    public func insertNewUser(with email: String, username: String, completion: @escaping (Bool) -> Void) {
//
//            let key = email.safeDatabaseKey()
//            print(key)
//
//            self.database.child(key).setValue(["username": username]) { error, _ in
//                if error == nil {
//                    // successed
//                    completion(true)
//                    return
//                } else {
//                    // failed
//                    completion(false)
//                    return
//                }
//            }
//        }
    
    public func insertNewUser(with email: String, uid: String, completion: @escaping (Bool) -> Void) {
        
        let storage = Storage.storage().reference().child("user/\(uid)")
        
//        self.database.child("users").setValue(user) { error, _ in
//            if error == nil {
//                // Başarılı
//                completion(true)
//            } else {
//                // Başarısız
//                completion(false)
//            }
//        }
    }

}
