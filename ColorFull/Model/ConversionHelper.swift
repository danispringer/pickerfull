//
//  ConversionHelper.swift
//  ColorFull
//
//  Created by Daniel Springer on 8/23/19.
//  Copyright © 2019 Dani Springer. All rights reserved.
//


import UIKit


extension UIViewController {


    func rgbFrom(hex: String) -> String {

        var rgbString = ""

        let redString = hex[0...1]
        let greenString = hex[2...3]
        let blueString = hex[4...5]

        rgbString = String(Int(redString, radix: 16)!) +
                    ", " +
                    String(Int(greenString, radix: 16)!) +
                    ", " +
                    String(Int(blueString, radix: 16)!)

        return rgbString
    }


    func uiColorFrom(hex: String) -> UIColor {

        var myColor: UIColor

        let redString = hex[0...1]
        let greenString = hex[2...3]
        let blueString = hex[4...5]

        myColor = UIColor(
            red: CGFloat(Int(redString, radix: 16)!),
            green: CGFloat(Int(greenString, radix: 16)!),
            blue: CGFloat(Int(blueString, radix: 16)!),
            alpha: 1.0)


        return myColor
    }


    // RGB HEX ?
    // RGB UICOLOR ?
    // UICOLOR HEX ?
    // UICOLOR RGB ?






}
