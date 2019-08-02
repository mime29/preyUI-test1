//
//  ViewController.swift
//  Organic
//
//  Created by Mime on 2019/08/01.
//  Copyright © 2019 Mikael. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
//TOP VIEW
    @IBOutlet weak var whiteBezier: BezierView!
    @IBOutlet weak var linesBezier: BezierLinesView!



//BOTTOM VIEW
    @IBOutlet weak var testView: UIView!
    @IBOutlet weak var gradiantView: GradientView!
    @IBOutlet weak var trianglesView: TrianglesView!
    @IBOutlet weak var bubblesView: BubblesView!


    override func viewDidLoad() {
        super.viewDidLoad()
        testView.layer.borderColor = UIColor.lightGray.cgColor
        testView.layer.borderWidth = 1
        initTopView()
        trianglesView.config()
        bubblesView.config()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startTopLoop()
        startBottomLoop()
    }
}

// MARK: - Private methods
private extension ViewController {

    func initTopView(){
        linesBezier.alpha = 0
        whiteBezier.alpha = 0
    }

    func animateTopLeftLines(afterDelay delay: TimeInterval, completion: ((UIViewAnimatingPosition) -> Void)?) {
        showTopLeftLines(afterDelay: delay) { pos in
            self.hideTopLeftLines(afterDelay: 0, completion: completion)
        }
    }

    func showTopLeftLines(afterDelay delay: TimeInterval, completion: ((UIViewAnimatingPosition) -> Void)?) {
        let animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeOut) {
            self.linesBezier.alpha = 1
            self.linesBezier.transform = CGAffineTransform(translationX: 150, y: 150)
        }
        animator.addCompletion { pos in
            completion?(pos)
        }
        animator.startAnimation(afterDelay: delay)
    }

    func hideTopLeftLines(afterDelay delay: TimeInterval, completion: ((UIViewAnimatingPosition) -> Void)?) {
        let animator = UIViewPropertyAnimator(duration: 1, curve: .easeOut) {
            self.linesBezier.alpha = 0
            self.linesBezier.transform = CGAffineTransform(translationX: 250, y: 250)
        }
        animator.addCompletion { pos in
            completion?(pos)
        }
        animator.startAnimation(afterDelay: delay)
    }

    func blink(afterDelay delay: TimeInterval, completion: ((UIViewAnimatingPosition) -> Void)?) {
        let animator = UIViewPropertyAnimator(duration: 0.1, curve: .easeIn) {
            self.whiteBezier.alpha = 1
        }
        animator.addCompletion { pos in
            self.whiteBezier.alpha = 0
            completion?(pos)
        }
        animator.startAnimation(afterDelay: delay)
    }

    func startTopLoop() {
        animateTopLeftLines(afterDelay: 1) { _ in
            self.blink(afterDelay: 0) { _ in
                self.blink(afterDelay: 0.1, completion: { _ in
                    self.resetTopLoop()
                })
            }
        }
    }

    func resetTopLoop() {
        linesBezier.transform = .identity
        linesBezier.alpha = 0
        startTopLoop()
    }


    func startBottomLoop() {
        gradiantView.animateLeft(0.8, afterDelay: 1) { pos in
            self.bubblesView.animate(2.5, afterDelay: 0.3, completion: { pos in
                print("finished bubble as pos: \(pos.rawValue)")
                self.gradiantView.animateReset(0.8, afterDelay: 0, completion: { pos in
                    self.restartBottomLoop()
                })
            })
            self.trianglesView.animate(1.2, { pos in
                print("finished at pos: \(pos.rawValue)")
            })
        }
    }

    func restartBottomLoop() {
        gradiantView.resetPosition()
        bubblesView.resetPosition()
        trianglesView.resetPosition()
        startBottomLoop()
    }
}

