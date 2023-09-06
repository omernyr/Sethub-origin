//
//  AuthManager.swift
//  InstagramClone
//
//  Created by macbook pro on 7.03.2023.
//

import FirebaseAuth
import FirebaseFirestore

public class AuthManager {
    static let shared = AuthManager()
    
    public func registerNewUser(email: String, password: String, completion: @escaping (Bool) -> Void) {
        
//        DatabaseManager.shared.canCreateNewUser(with: email, username: username) { canCreate in
//                    if canCreate {
//                        Auth.auth().createUser(withEmail: email, password: password) { result, error in
//                            guard error == nil, result != nil else {
//                                completion(false)
//                                return
//                            }
//
//                            DatabaseManager.shared.insertNewUser(with: email, username: username, uid: ) { inserted in
//                                if inserted {
//                                    completion(true)
//                                    return
//                                } else {
//                                    // failed to insert databse
//                                    completion(false)
//                                    return
//                                }
//                            }
//
//                        }
//                    } else {
//                        completion(false)
//                    }
//                }
        
        // MARK: - şlgdög
        DatabaseManager.shared.canCreateNewUser(with: email) { canCreate in
            if canCreate {
                Auth.auth().createUser(withEmail: email, password: password) { result, error in
                    guard error == nil, let user = result?.user else {
                        completion(false)
                        return
                    }
                    
                    let uid = user.uid // Kullanıcının UID'sini alıyoruz
                    
                    DatabaseManager.shared.insertNewUser(with: email, uid: uid) { inserted in
                        if inserted {
                            completion(true)
                        } else {
                            // Veritabanına ekleme başarısız oldu
                            completion(false)
                        }
                    }
                    
                }
            } else {
                completion(false)
            }
        }
        
    }
    
    public func loginUser(email: String?, password: String, completion: @escaping (Bool) -> Void) {
        
        if let email = email {
            
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                guard authResult != nil, error == nil else {
                    print("BIG ERROR --------->", error?.localizedDescription)
                    completion(false)
                    return
                }
                
                completion(true)
            }
            
        }
    }
    
    public func logOut(compleiton: (Bool) -> Void) {
        
        do {
            print("success")
            try Auth.auth().signOut()
            compleiton(true)
            return
        } catch {
            print(error)
            compleiton(false)
            return
        }
        
    }
    
}
