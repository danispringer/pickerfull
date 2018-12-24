//
//  UIImage+Extensions.swift
//  ColorFull
//
//  Created by Daniel Springer on 11/26/18.
//  Copyright © 2018 Daniel Springer. All rights reserved.
//

import UIKit


extension UIImage {

    class func from(color: UIColor) -> UIImage {
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 1, height: 1))
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }

}
