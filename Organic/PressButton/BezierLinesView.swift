//
//  BezierLinesView.swift
//  Organic
//
//  Created by Mime on 2019/08/02.
//  Copyright © 2019 Mikael. All rights reserved.
//

import UIKit

@IBDesignable
final class BezierLinesView: UIView {

    @IBInspectable var angle: CGFloat = 0 {
        didSet { updateLayer() }
    }

    lazy var shapeLayer: CAShapeLayer = {
        let caLayer = CAShapeLayer()
        let offset:CGFloat = 100 //bounds.height * tan(angle)
        let nbLines = 4
        let finalPath = UIBezierPath()
        let spacer = bounds.width / CGFloat(nbLines)
        for i in 0...nbLines {
            let aLine = line(startX: spacer * CGFloat(i), offset: offset)
            finalPath.append(aLine)
        }

        caLayer.path = finalPath.cgPath
        //caLayer.masksToBounds = true
        //caLayer.fillColor = UIColor(red: 40, green: 30, blue: 40, alpha: 0.5).cgColor
        caLayer.strokeColor = UIColor.blue.cgColor
        caLayer.lineWidth = 2

        //layer.mask = caLayer
        layer.addSublayer(caLayer)
        return caLayer
    }()

    func line(startX: CGFloat, offset: CGFloat) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: startX, y: 0)) //top left
        path.addLine(to: CGPoint(x: startX + offset, y: bounds.height)) //bot right
        path.close()
        return path
    }

    func updateLayer() {
        let shape = shapeLayer
    }
}
