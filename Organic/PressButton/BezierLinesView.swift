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
        let shadowLayer = CAShapeLayer()
        let offset:CGFloat = 120 //bounds.height * tan(angle)
        let nbLines = 4
        let finalPath = UIBezierPath()
        let shadowPath = UIBezierPath()
        let spacer = bounds.width / CGFloat(nbLines)
        for i in 0...nbLines {
            let aLine = line(startX: spacer * CGFloat(i), offset: offset)
            finalPath.append(aLine)
            shadowPath.append(aLine)
        }

        shadowLayer.path = shadowPath.cgPath
        shadowLayer.lineCap = .round
        shadowLayer.strokeColor = UIColor.white.cgColor
        shadowLayer.lineWidth = 2
        shadowLayer.shadowColor = UIColor.white.cgColor
        shadowLayer.shadowOpacity = 0.9
        shadowLayer.shadowRadius = 5
        shadowLayer.shadowOffset = CGSize(width: 0, height: 0)

        caLayer.path = finalPath.cgPath
        caLayer.lineCap = .round
        caLayer.strokeColor = UIColor.clear.cgColor
        caLayer.lineWidth = 1

        layer.addSublayer(shadowLayer)
        layer.addSublayer(caLayer)
        return caLayer
    }()

    func line(startX: CGFloat, offset: CGFloat) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: startX, y: 0)) //top left
        path.addLine(to: CGPoint(x: startX + offset, y: bounds.height)) //bot right
        return path
    }

    func updateLayer() {
        let _ = shapeLayer
    }
}
