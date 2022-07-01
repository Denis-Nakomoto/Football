//
//  UILabel+Extension.swift
//  Football
//
//  Created by Denis Svetlakov on 01.07.2022.
//

import UIKit

extension UILabel {
    
    convenience init(text: String, font: UIFont? = .systemFont(ofSize: 14), color: UIColor = .black) {
        self.init()
        
        self.text = text
        self.font = font
        self.textColor = color
        self.numberOfLines = 1
        self.adjustsFontSizeToFitWidth = true
        self.minimumScaleFactor = 0.5
    }
}
