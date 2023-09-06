//
//  ProductModel.swift
//  test
//
//  Created by macbook pro on 12.07.2023.
//

import Foundation

struct UploadedPost: Codable {
    let userEmail: String
    let imageURL: String
    let postDescription: String
    var prodAnnotations: [ImageAnnotation]
    let date: Date
    let category: String // Kategori alanını ekleyin
    var likes: Int
    var isLiked: Bool
    
    // DictionaryRepresentation'ı ekleyin
    var dictionaryRepresentation: [String: Any] {
        var dict: [String: Any] = [
            "userEmail": userEmail,
            "imageURL": imageURL,
            "postDescription": postDescription,
            "category": category, // Kategori alanını ekleyin
            "date": date,
            "likes": likes,
            "isLiked": isLiked
        ]
        if !prodAnnotations.isEmpty {
            dict["prodAnnotations"] = prodAnnotations.map { $0.dictionaryRepresentation }
        }
        return dict
    }
    
    // Codable için CodingKeys ekleyin
    enum CodingKeys: String, CodingKey {
        case userEmail
        case imageURL
        case postDescription
        case prodAnnotations
        case category // Kategori alanını ekleyin
        case date
        case likes
        case isLiked
    }
}



struct ImageAnnotation: Codable {
    let xPosition: Double?
    let yPosition: Double?
    let product: Product?

    // DictionaryRepresentation'ı ekleyin
    var dictionaryRepresentation: [String: Any] {
        var dict: [String: Any] = [
            "xPosition": xPosition ?? 0.0,
            "yPosition": yPosition ?? 0.0
        ]
        if let product = product {
            dict["product"] = product.dictionaryRepresentation
        }
        return dict
    }

    // Codable için CodingKeys ekleyin
    enum CodingKeys: String, CodingKey {
        case xPosition
        case yPosition
        case product
    }
}

struct Product: Codable {
    let name: String
    let description: String
    let link: String

    // DictionaryRepresentation'ı ekleyin
    var dictionaryRepresentation: [String: Any] {
        return [
            "name": name,
            "description": description,
            "link": link
        ]
    }

    // Codable için CodingKeys ekleyin
    enum CodingKeys: String, CodingKey {
        case name
        case description
        case link
    }
}

struct User: Codable {
    let id: String
    let username: String
    var bio: String?
    var profileImageURL: String?

    // DictionaryRepresentation'ı ekleyin
    var dictionaryRepresentation: [String: Any] {
        var dictionary: [String: Any] = [
            "id": id,
            "username": username
        ]
        
        if let bio = bio {
            dictionary["bio"] = bio
        }
        
        if let profileImageURL = profileImageURL {
            dictionary["profileImageURL"] = profileImageURL
        }
        
        return dictionary
    }

    // Codable için CodingKeys ekleyin
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case bio
        case profileImageURL
    }
}
