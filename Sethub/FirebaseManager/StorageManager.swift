//
//  F.swift
//  InstagramClone
//
//  Created by macbook pro on 7.03.2023.
//

import FirebaseStorage
import UIKit

public class StorageManager {
    static let shared = StorageManager()
    private let storageReference = Storage.storage().reference()
    
    public enum IGStorageManagerError: Error {
        case failedToDownload
    }
    
    public func uploadUserPost(model: UserPost, completion: @escaping (Result<URL, IGStorageManagerError>) -> Void) {
        
        

        
        
    }
    
    public func downloadImage(with reference: String, completion: @escaping (Result<URL, IGStorageManagerError>) -> Void) {
        storageReference.child(reference).downloadURL(completion: { url, error in
            guard let url = url,
                  error == nil else {
                completion(.failure(.failedToDownload))
                return
                
            }
            let url2 = url
        })
    }
    
}

public struct UserPost {
    let data: UploadedPost?
}
