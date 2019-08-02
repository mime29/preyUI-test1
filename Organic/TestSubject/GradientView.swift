//
//  GradientView.swift
//  Organic
//
//  Created by Mime on 2019/08/01.
//  Copyright © 2019 Mikael. All rights reserved.
//

import UIKit

@IBDesignable
final class GradientView: UIView {

    @IBInspectable var startColor: UIColor = .red {
        didSet { updateLayer() }
    }

    @IBInspectable var endColor: UIColor = .green {
        didSet { updateLayer() }
    }

    @IBInspectable var angle: CGFloat = 0 {
        didSet { updateLayer() }
    }

    lazy var gradientLayer: CAGradientLayer = {
        let grad = CAGradientLayer()
        grad.frame = self.bounds
        grad.colors = [startColor.cgColor,endColor.cgColor]
        grad.masksToBounds = true
        layer.addSublayer(grad)
        return grad
    }()

    private func updateLayer() {
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        let radians = angle * CGFloat.pi / 180
        let dx = 0.5 * cos(radians)
        let dy = 0.5 * sin(radians)
        gradientLayer.startPoint = CGPoint(x: 0.5 - dx, y: 0.5 + dy)
        gradientLayer.endPoint = CGPoint(x: 0.5 + dx, y: 0.5 - dy)
    }
}

extension GradientView {
    func resetPosition() {
        transform = CGAffineTransform.identity
        layer.removeAllAnimations()
    }

    func animateLeft(_ duration: TimeInterval,
                     afterDelay delay: TimeInterval,
                     completion: ((UIViewAnimatingPosition) -> Void)?) {
        let animator = UIViewPropertyAnimator(duration: duration, curve: .linear) {
            self.transform = CGAffineTransform(translationX: -self.bounds.width/2, y: 0)
        }
        if let completion = completion {
            animator.addCompletion(completion)
        }
        animator.startAnimation(afterDelay: delay)
    }

    func animateReset(_ duration: TimeInterval,
                     afterDelay delay: TimeInterval,
                     completion: ((UIViewAnimatingPosition) -> Void)?) {
        let animator = UIViewPropertyAnimator(duration: duration, curve: .linear) {
            self.transform = CGAffineTransform.identity
        }
        if let completion = completion {
            animator.addCompletion(completion)
        }
        animator.startAnimation(afterDelay: delay)
    }
}
