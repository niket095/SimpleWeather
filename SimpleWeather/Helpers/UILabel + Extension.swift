//
//  UILabel + Extension.swift
//  SimpleWeather
//
//  Created by Nikita Putilov on 14.11.2024.
//

import UIKit

extension UILabel {
    
    convenience init(text: String, color: UIColor, font: UIFont) {
        self.init()
        
        self.text = text
        self.font = font
        self.textColor = color

        self.numberOfLines = 2
        
        self.adjustsFontSizeToFitWidth = true
        self.textAlignment = .center
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
