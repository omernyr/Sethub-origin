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
    let db = Firestore.firestore()
    
    public func registerNewUser(email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            guard error == nil, let user = result?.user else {
                completion(false)
                return
            }
            
            let uid = user.uid // Kullanıcının UID'sini alıyoruz
            
            // Firestore veritabanı referansını al
            let db = Firestore.firestore()
            
            // Kullanıcı verilerini Firestore "users" koleksiyonuna eklemek için aşağıdaki işlemi gerçekleştirin
            
            // Yeni kullanıcı için rastgele bir isim ve soyisim oluştur (örnek amaçlı)
            let defaultName = "John"
            let defaultSurname = "Doe"
            
            // Rastgele bir bio oluştur (isteğe bağlı)
            let defaultBio = "Im a developer"
            
            // Boş bir kaydedilmiş gönderi listesi oluştur
            let savedPosts: [String] = []
            
            // Rastgele bir profil resmi URL'si oluştur (isteğe bağlı)
            let defaultProfileImageURL = "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_640.png"
            
            // Kullanıcı verilerini Firestore "users" koleksiyonuna ekleyin
            let userData: [String: Any] = [
                "id": uid,
                "name": defaultName,
                "surname": defaultSurname,
                "bio": defaultBio,
                "savedPosts": savedPosts,
                "userProfileImageURL": defaultProfileImageURL,
                "email": email
            ]
            
            // Firestore koleksiyon referansını al
            let usersCollection = db.collection("users")
            
            // Kullanıcı verilerini belirtilen UID ile belirtilen koleksiyona ekle
            usersCollection.document(uid).setData(userData) { error in
                if let error = error {
                    print("Kullanıcı verileri Firestore'a eklenirken hata oluştu: \(error)")
                    completion(false)
                } else {
                    print("Kullanıcı verileri başarıyla Firestore'a eklendi")
                    completion(true)
                }
            }
        }
    }

    
    public func loginUser(email: String?, password: String, completion: @escaping (Bool) -> Void) {
        
        if let email = email {
            
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                guard authResult != nil, error == nil else {
                    print("BIG ERROR --------->", error?.localizedDescription ?? "error auth")
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
