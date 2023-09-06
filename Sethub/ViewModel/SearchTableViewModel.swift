//
//  SearchTableViewModel.swift
//  Sethub
//
//  Created by macbook pro on 30.08.2023.
//

import Foundation
import FirebaseFirestore
import Firebase

final class SearchTableViewModel {
    
    var allPosts: [UploadedPost] = []
    var filteredPosts: [UploadedPost] = [] // Filtrelenmiş sonuçları tutmak için dizi
    var categories: [String] = [] // Ürün kategorilerini tutmak için dizi
    
    func fetchAllPosts(completion: @escaping () -> Void) {
        let db = Firestore.firestore()
        let postsRef = db.collection("uploadedPosts")
        
        postsRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Firestore'dan verileri alırken hata oluştu: \(error.localizedDescription)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("Firestore'dan hiçbir belge bulunamadı.")
                return
            }
            
            var allPosts: [UploadedPost] = []
            var categories: [String] = []
            
            for document in documents {
                let data = document.data()
                if let imageURL = data["imageURL"] as? String,
                   let email = data["userEmail"] as? String,
                   let postDescription = data["postDescription"] as? String,
                   let prodAnnotationsData = data["prodAnnotations"] as? [[String: Any]],
                   let category = data["category"] as? String,
                   let date = data["date"] as? Timestamp {
                    
                    var prodAnnotations: [ImageAnnotation] = []
                    for annotationData in prodAnnotationsData {
                        if let xPosition = annotationData["xPosition"] as? Double,
                           let yPosition = annotationData["yPosition"] as? Double,
                           let productData = annotationData["product"] as? [String: Any],
                           let name = productData["name"] as? String,
                           let description = productData["description"] as? String,
                           let link = productData["link"] as? String {
                            
                            let product = Product(name: name, description: description, link: link)
                            let annotation = ImageAnnotation(xPosition: xPosition, yPosition: yPosition, product: product)
                            prodAnnotations.append(annotation)
                        }
                    }
                    
//                    UploadedPost(userEmail: email, imageURL: imageURL, postDescription: postDescription, prodAnnotations: prodAnnotations, date: date.dateValue(), category: category) // Timestamp'ı Date türüne çevirin
                    
                    let uploadedPost = UploadedPost(userEmail: email,imageURL: imageURL,postDescription: postDescription, prodAnnotations: prodAnnotations,
                                                    date: date.dateValue(), category: category, likes: 0, isLiked: false)
                    allPosts.append(uploadedPost)
                    
                    // Kategorileri ekleyin
                    if !categories.contains(category) {
                        categories.append(category)
                    }
                }
            }
            
            self.allPosts = allPosts
            self.categories = categories
            completion()
        }
    }
    
    // MARK: For Posts
    func numberOfRowInSectionForPosts(in section: Int) -> Int {
        self.filteredPosts.count
    }
    
    // MARK: For Categories
    func numberOfRowInSectionForCategories(in section: Int) -> Int {
        self.categories.count
    }
    
    // MARK: Search funcs
    func searchPosts(userEmail: String) {
        filteredPosts = allPosts.filter { $0.userEmail.lowercased().contains(userEmail.lowercased()) }
    }
    
    func searchPostsByCategory(category: String, completion: @escaping () -> Void) {
        filteredPosts = allPosts.filter { $0.category == category }
        completion()
    }
    
    func configureCellForPosts(_ cell: FeedProductViewCell, at indexPath: IndexPath) {
        let post = filteredPosts[indexPath.row]
        cell.post = post
    }
    
    func configureCellForCategories(_ cell: UITableViewCell, at indexPath: IndexPath) {
        let category = categories[indexPath.row]
        cell.textLabel?.text = category
    }
    
}
