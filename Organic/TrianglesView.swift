//
//  TrianglesView.swift
//  Organic
//
//  Created by Mime on 2019/08/02.
//  Copyright © 2019 Mikael. All rights reserved.
//

import UIKit
import SpriteKit

final class TrianglesView: UIView {
    @IBOutlet weak var spriteLeft: SKView!
    @IBOutlet weak var spriteRight: SKView!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

    }

    func config() {
        configLeft()
        configRight()
        spriteLeft.alpha = 0
        spriteRight.alpha = 0
    }

}

private extension TrianglesView {
    func configLeft() {
        let skScene  = SKScene(size: spriteLeft.frame.size)
        skScene.scaleMode = .aspectFill
        skScene.backgroundColor = .clear
        if let emitter = SKEmitterNode(fileNamed: "triangles.sks") {
            emitter.position = CGPoint(x: spriteLeft.frame.origin.x, y: spriteLeft.frame.origin.y)
            skScene.addChild(emitter)
            spriteLeft.presentScene(skScene)
        }
    }

    func configRight() {
        let skScene  = SKScene(size: spriteRight.frame.size)
        skScene.scaleMode = .aspectFill
        skScene.backgroundColor = .clear
        if let emitter = SKEmitterNode(fileNamed: "triangles.sks") {
            emitter.position = CGPoint(x: spriteRight.frame.origin.x, y: spriteRight.frame.origin.y)
            skScene.addChild(emitter)
            spriteRight.presentScene(skScene)
        }
    }

    func animateLeft(_ duration: TimeInterval,
                     afterDelay delay: TimeInterval,
                     completion: ((UIViewAnimatingPosition) -> Void)?) {
        fadeIn(0.8, completion: nil)
        let animator = UIViewPropertyAnimator(duration: duration, curve: .linear) {
            self.spriteLeft.transform = CGAffineTransform(translationX: -self.bounds.width/2, y: self.bounds.height/2)
        }
        if let completion = completion {
            animator.addCompletion(completion)
        }
        animator.startAnimation(afterDelay: delay)
    }

    func animateRight(_ duration: TimeInterval,
                      afterDelay delay: TimeInterval,
                      completion: ((UIViewAnimatingPosition) -> Void)?) {
        let animator = UIViewPropertyAnimator(duration: duration, curve: .linear) {
            self.spriteRight.transform = CGAffineTransform(translationX: self.bounds.width/2, y: -self.bounds.height/2)
        }
        if let completion = completion {
            animator.addCompletion(completion)
        }
        animator.startAnimation(afterDelay: delay)
    }

    func fadeIn(_ duration: TimeInterval,
                completion: ((UIViewAnimatingPosition) -> Void)?) {
        spriteLeft.alpha = 0
        spriteRight.alpha = 0
        let animator = UIViewPropertyAnimator(duration: duration, curve: .linear) {
            self.spriteLeft.alpha = 1
            self.spriteRight.alpha = 1
        }
        if let completion = completion {
            animator.addCompletion(completion)
        }
        animator.startAnimation()
    }
}

extension TrianglesView {
    func resetPosition() {
        spriteLeft.transform = CGAffineTransform.identity
        spriteRight.transform = CGAffineTransform.identity
        //layer.removeAllAnimations()
    }

    func animate(_ completion: ((UIViewAnimatingPosition) -> Void)?) {
        animateLeft(2.0, afterDelay: 0) { pos in

        }
        animateRight(2.0, afterDelay: 0) { pos in
            completion?(pos)
        }
    }
}
