//
//  Extension+UIColor.swift
//  test
//
//  Created by macbook pro on 18.07.2023.
//
import UIKit

extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.currentIndex = hexString.index(after: hexString.startIndex)
        }
        
        var color: UInt64 = 0
        scanner.scanHexInt64(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    func toHexString() -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb: Int = (Int)(r * 255) << 16 | (Int)(g * 255) << 8 | (Int)(b * 255) << 0
        return String(format: "#%06x", rgb)
    }
}

extension UIView {
    func buildShadowForView(color: UIColor?, opacity: Float?, cgsizeWidth: CGFloat?, cgsizeHeight: CGFloat?, radius: CGFloat?) {
        self.layer.shadowColor = color?.cgColor
        self.layer.shadowOpacity = opacity!
        self.layer.shadowOffset = CGSize(width: cgsizeWidth!, height: cgsizeHeight!) // Gölge konumu
        self.layer.shadowRadius = radius!
    }
}
