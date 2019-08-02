//
//  BubblesView.swift
//  Organic
//
//  Created by Mime on 2019/08/02.
//  Copyright © 2019 Mikael. All rights reserved.
//

import UIKit
import SpriteKit

final class BubblesView: UIView {
    @IBOutlet weak var spriteLeft: SKView!
    @IBOutlet weak var spriteRight: SKView!

    func config() {
        configLeft()
        configRight()
    }

    func configRight() {
        let skScene = SKScene(size: spriteRight.frame.size)
        skScene.scaleMode = .aspectFill
        skScene.backgroundColor = .clear
        if let emitter = SKEmitterNode(fileNamed: "Bokeh.sks") {
            emitter.position = CGPoint(x: spriteRight.frame.origin.x, y: spriteRight.frame.origin.y)
            skScene.addChild(emitter)
            spriteRight.ignoresSiblingOrder = true
            spriteRight.presentScene(skScene)
        }
        spriteRight.alpha = 0
    }

    func configLeft() {
        let skScene = SKScene(size: spriteLeft.frame.size)
        skScene.scaleMode = .aspectFill
        skScene.backgroundColor = .clear
        if let emitter = SKEmitterNode(fileNamed: "Bokeh.sks") {
            emitter.position = CGPoint(x: spriteLeft.frame.origin.x, y: spriteLeft.frame.origin.y)
            skScene.addChild(emitter)
            spriteLeft.ignoresSiblingOrder = true
            spriteLeft.presentScene(skScene)
        }
        spriteLeft.alpha = 0
    }

    fileprivate func animateLeft(_ delay: TimeInterval,
                                 _ duration: TimeInterval,
                                 _ completion: ((UIViewAnimatingPosition) -> Void)?) {
        fadeIn(0.4, afterDelay: delay, completion: nil)
        let animator = UIViewPropertyAnimator(duration: duration, curve: .linear) {
            let scroll = CGAffineTransform(translationX: -self.bounds.width/2, y: 0)
            let scale = CGAffineTransform(scaleX: 2, y: 2)
            self.spriteLeft.transform = scroll.concatenating(scale)
        }
        if let completion = completion {
            animator.addCompletion(completion)
        }
        animator.startAnimation(afterDelay: delay)
    }

    fileprivate func animateRight(_ delay: TimeInterval,
                                 _ duration: TimeInterval,
                                 _ completion: ((UIViewAnimatingPosition) -> Void)?) {
        let animator = UIViewPropertyAnimator(duration: duration, curve: .linear) {
            let scroll = CGAffineTransform(translationX: self.bounds.width/2, y: 0)
            let scale = CGAffineTransform(scaleX: 2, y: 2)
            self.spriteRight.transform = scroll.concatenating(scale)
        }
        if let completion = completion {
            animator.addCompletion(completion)
        }
        animator.startAnimation(afterDelay: delay)
    }

    func animate(_ duration: TimeInterval,
                      afterDelay delay: TimeInterval,
                      completion: ((UIViewAnimatingPosition) -> Void)?) {
        animateLeft(delay, duration, nil)
        animateRight(delay, duration, completion)
    }

    func fadeIn(_ duration: TimeInterval,
                afterDelay delay: TimeInterval,
                completion: ((UIViewAnimatingPosition) -> Void)?) {
        spriteLeft.alpha = 0
        spriteRight.alpha = 0
        let animator = UIViewPropertyAnimator(duration: duration, curve: .easeIn) {
            self.spriteLeft.alpha = 1
            self.spriteRight.alpha = 1
        }
        if let completion = completion {
            animator.addCompletion(completion)
        }
        animator.startAnimation(afterDelay: delay)
    }

    func resetPosition() {
        spriteLeft.transform = CGAffineTransform.identity
        spriteLeft.alpha = 0
        spriteRight.transform = CGAffineTransform.identity
        spriteRight.alpha = 0
    }
}
