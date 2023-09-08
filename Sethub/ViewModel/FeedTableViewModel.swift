import Foundation
import FirebaseAuth
import Firebase

final class FeedTableViewModel {
    
    public var products: [UploadedPost] = []
    
    func parseJSON(completion: @escaping () -> Void) {
        let db = Firestore.firestore()
        let postsRef = db.collection("uploadedPosts")

        // "date" alanına göre sıralı bir sorgu yapın
        postsRef.order(by: "date", descending: true).addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print("Firestore'dan verileri alırken hata oluştu: \(error.localizedDescription)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("Firestore'dan hiçbir belge bulunamadı.")
                return
            }
            
            // Firestore'dan gelen belgeleri çevirip "products" dizisine atayın
            var uploadedPosts: [UploadedPost] = []
            
            for document in documents {
                let data = document.data()
                if let imageURL = data["imageURL"] as? String,
                   let email = data["userEmail"] as? String,
                   let id = data["id"] as? String,
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
                    
                    let uploadedPost = UploadedPost(userEmail: email, id: id, imageURL: imageURL, postDescription: postDescription, prodAnnotations: prodAnnotations,
                                                    date: date.dateValue(), category: category, likes: 3, isLiked: false, isSaved: false)
                    
                    uploadedPosts.append(uploadedPost)
                }
            }
            
            self.products = uploadedPosts
            completion() // Veriler çekildiğinde completion bloğunu çağır
        }
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        return self.products.count
    }
    
    func configureCell(_ cell: FeedProductViewCell, at indexPath: IndexPath) {
        let post = self.products[indexPath.row]
        cell.post = post
    }
    
}
