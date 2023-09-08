//
//  ProductModel.swift
//  test
//
//  Created by macbook pro on 12.07.2023.
//

import Foundation

struct UploadedPost: Codable {
    let userEmail: String
    let id: String
    let imageURL: String
    let postDescription: String
    var prodAnnotations: [ImageAnnotation]
    let date: Date
    let category: String // Kategori alanını ekleyin
    var likes: Int
    var isLiked: Bool
    var isSaved: Bool
    
    // DictionaryRepresentation'ı ekleyin
    var dictionaryRepresentation: [String: Any] {
        var dict: [String: Any] = [
            "userEmail": userEmail,
            "id": id,
            "imageURL": imageURL,
            "postDescription": postDescription,
            "category": category, // Kategori alanını ekleyin
            "date": date,
            "likes": likes,
            "isLiked": isLiked,
            "isSaved": isSaved
        ]
        if !prodAnnotations.isEmpty {
            dict["prodAnnotations"] = prodAnnotations.map { $0.dictionaryRepresentation }
        }
        return dict
    }
    
    // Codable için CodingKeys ekleyin
    enum CodingKeys: String, CodingKey {
        case userEmail
        case id
        case imageURL
        case postDescription
        case prodAnnotations
        case category // Kategori alanını ekleyin
        case date
        case likes
        case isLiked
        case isSaved
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

struct User {
    let name: String
    let surname: String
    let bio: String
    let userProfileImageURL: String
}
