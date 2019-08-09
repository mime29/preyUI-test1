//
//  BezierView.swift
//  Organic
//
//  Created by Mime on 2019/08/02.
//  Copyright © 2019 Mikael. All rights reserved.
//

import UIKit
import CoreImage

@IBDesignable
final class BezierView: UIView {

    @IBInspectable var angle: CGFloat = 0 {
        didSet { updateLayer() }
    }

    var shapeLayer: CAShapeLayer {
        let caLayer = CAShapeLayer()
        let path = UIBezierPath()
        let offset:CGFloat = bounds.height * tan(angle * .pi / 180)
        path.move(to: CGPoint(x: 0, y: bounds.height)) //bot left
        path.addLine(to: CGPoint(x: offset, y: 0))
        path.addLine(to: CGPoint(x: bounds.width, y: 0)) //top right
        path.addLine(to: CGPoint(x: bounds.width - offset, y: bounds.height))
        path.close()

        caLayer.path = path.cgPath
        //caLayer.masksToBounds = true
        //caLayer.fillColor = UIColor(red: 40, green: 30, blue: 40, alpha: 0.5).cgColor
        caLayer.strokeColor = nil

        layer.mask = caLayer
        //layer.addSublayer(caLayer)
        return caLayer
    }

    private var theLeftLine: CALayer?
    var leftLine: CALayer {
        let caLayer = CALayer()
        let path = UIBezierPath()
        let offset:CGFloat = bounds.height * tan(angle * .pi / 180)
        path.move(to: CGPoint(x: 0, y: bounds.height)) //bot left
        path.addLine(to: CGPoint(x: offset, y: 0))
        path.close()

        if let line = theLeftLine {
            line.removeFromSuperlayer()
        }

        // Make an UIImage from BezierPath
        let image = path.strokeImage(strokeColor: UIColor.white, fillColor: UIColor.white)
        // get a blurry image
        if let blurryImage = image?.blurred(with: 30, tintColor: nil, saturationDeltaFactor: 2) {
            let myImage = blurryImage.cgImage
            let pathSize = path.sizeIncludingLineWidth()
            let scale: CGFloat = bounds.height / pathSize.height
            caLayer.frame = CGRect(x: -38,//pathSize.width * scale,
                                   y: 0,
                                   width: pathSize.width * scale,
                                   height: pathSize.height * scale)
            caLayer.contents = myImage
            layer.addSublayer(caLayer)
            theLeftLine = caLayer
        }

        return caLayer
    }

    private func updateLayer() {
        let _ = shapeLayer
        let _ = leftLine
    }
}
