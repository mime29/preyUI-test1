//
//  BezierView.swift
//  Organic
//
//  Created by Mime on 2019/08/02.
//  Copyright © 2019 Mikael. All rights reserved.
//

import UIKit

@IBDesignable
final class BezierView: UIView {

    @IBInspectable var angle: CGFloat = 0 {
        didSet { updateLayer() }
    }

    lazy var shapeLayer: CAShapeLayer = {
        let caLayer = CAShapeLayer()
        let path = UIBezierPath()
        let offset:CGFloat = 15 //bounds.height * tan(angle)
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
    }()

    lazy var leftLine: CAShapeLayer = {
        let caLayer = CAShapeLayer()
        let path = UIBezierPath()
        let offset:CGFloat = 15 //bounds.height * tan(angle)
        path.move(to: CGPoint(x: 0, y: bounds.height)) //bot left
        path.addLine(to: CGPoint(x: offset, y: 0))
        path.close()

        caLayer.path = path.cgPath
        //caLayer.fillColor = UIColor(red: 40, green: 30, blue: 40, alpha: 0.5).cgColor
        caLayer.strokeColor = UIColor.white.cgColor
        caLayer.lineWidth = 6

        //layer.mask = caLayer
        layer.addSublayer(caLayer)
        return caLayer
    }()

    private func updateLayer() {
        let shape = shapeLayer
        let left = leftLine
    }
}
