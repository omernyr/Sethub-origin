//
//  UploaProductVC+CategoryCollectionView.swift
//  Sethub
//
//  Created by macbook pro on 30.07.2023.
//

import UIKit

extension UploadPostViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoriesWithEmojis.count
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 5 // Hücreler arası boşluk
//    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell

        cell.configureCell(categoryWithEmoji: categoriesWithEmojis[indexPath.item])
        cell.backgroundColor = (selectedCategoryIndex == indexPath.item) ? UIColor.init(hexString: "000000") : .clear
        cell.label.textColor = (selectedCategoryIndex == indexPath.item) ? UIColor.init(hexString: "ffffff") : UIColor.black

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           let categoryWithEmoji = categoriesWithEmojis[indexPath.item]
           let textWidth = categoryWithEmoji.size(withAttributes: [
               NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)
           ]).width
           
           let cellWidth = textWidth + 20 // Metin genişliği + boşluklar
           let cellHeight: CGFloat = 40
           
           return CGSize(width: cellWidth, height: cellHeight)
       }

    // MARK: UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCategory = categoriesWithEmojis[indexPath.item]

        print("Selected Category: \(selectedCategory)")
        selectedCategoryIndex = indexPath.item

        collectionView.reloadData()
    }
}
