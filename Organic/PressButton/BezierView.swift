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

    @IBInspectable var asMask: Bool = false {
        didSet { updateLayer() }
    }

    @IBInspectable var hasLeftLine: Bool = false {
        didSet { updateLayer() }
    }

    private var theShapeLayer: CAShapeLayer?
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
        caLayer.masksToBounds = false
        caLayer.strokeColor = nil

        if let line = theShapeLayer {
            line.removeFromSuperlayer()
            theShapeLayer = nil
        }

        if asMask {
            layer.mask = caLayer
        } else {
            caLayer.fillColor = UIColor(red: 181/255, green: 163/255, blue: 225/255, alpha: 0.32).cgColor
            layer.addSublayer(caLayer)
        }
        layer.masksToBounds = false

        theShapeLayer = caLayer
        return caLayer
    }

    private var theLeftLine: CAShapeLayer?
    var leftLine: CALayer {
        let caLayer = CAShapeLayer()
        let path = UIBezierPath()
        let offset:CGFloat = bounds.height * tan(angle * .pi / 180)
        path.move(to: CGPoint(x: 0, y: bounds.height)) //bot left
        path.addLine(to: CGPoint(x: offset, y: 0))

        if let line = theLeftLine {
            line.removeFromSuperlayer()
            theLeftLine = nil
        }

        caLayer.path = path.cgPath
        caLayer.strokeColor = UIColor.white.cgColor
        caLayer.lineWidth = 3
        caLayer.lineCap = .round
        caLayer.cornerRadius = 1.5
        let shadowColor = UIColor(red: 130/255, green: 200/255, blue: 245/255, alpha: 1).cgColor
        caLayer.shadowColor = shadowColor
        caLayer.shadowOffset = CGSize(width: 0, height: 0)
        caLayer.shadowOpacity = 1
        caLayer.shadowRadius = 6

        if hasLeftLine {
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
