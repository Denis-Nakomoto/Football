//
//  UIView+Extension.swift
//  Football
//
//  Created by Denis Svetlakov on 01.07.2022.
//

import Foundation
import UIKit

extension UIView {
    static var reuseId: String {
        String(describing: self)
    }
}
