//
//  BezierPath+Extension.swift
//  Organic
//
//  Created by Mime on 2019/08/05.
//  Copyright © 2019 Mikael. All rights reserved.
//

import UIKit

extension UIBezierPath {
    func sizeIncludingLineWidth() -> CGSize {
        return CGSize(width: bounds.size.width + self.lineWidth * 2,
                      height: bounds.size.width + self.lineWidth * 2)
    }

    func strokeImage(strokeColor: UIColor? = .black, fillColor: UIColor? = .clear) -> UIImage? {
        let finalStrokeColor: UIColor
        let finalFillColor: UIColor

        // get your bounds
        UIGraphicsBeginImageContextWithOptions(sizeIncludingLineWidth(),
                                               false,
                                               UIScreen.main.scale)
        // get reference to the graphics context
        let reference = UIGraphicsGetCurrentContext()!
        // translate matrix so that path will be centered in bounds
        reference.translateBy(x: self.lineWidth, y: self.lineWidth)

        if strokeColor == nil {
            finalStrokeColor = fillColor!
            finalFillColor = fillColor!
        } else if fillColor == nil {
            finalFillColor = strokeColor!
            finalStrokeColor = strokeColor!
        } else {
            finalFillColor = fillColor!
            finalStrokeColor = strokeColor!
        }

        // set the color
        finalFillColor.setFill()
        finalStrokeColor.setStroke()

        // draw the path
        fill()
        stroke()

        // grab an image of the context
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }
}
