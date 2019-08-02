//
//  ViewController.swift
//  Organic
//
//  Created by Mime on 2019/08/01.
//  Copyright © 2019 Mikael. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
    @IBOutlet weak var testView: UIView!
    @IBOutlet weak var gradiantView: GradientView!
    @IBOutlet weak var trianglesView: TrianglesView!
    @IBOutlet weak var bubblesView: BubblesView!

    override func viewDidLoad() {
        super.viewDidLoad()
        testView.layer.borderColor = UIColor.lightGray.cgColor
        testView.layer.borderWidth = 1
        trianglesView.config()
        bubblesView.config()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startLoop()
    }
}

// MARK: - Private methods
private extension ViewController {
    func startLoop() {
        gradiantView.animateLeft(0.8, afterDelay: 1) { pos in
            self.bubblesView.animate(2.5, afterDelay: 0.3, completion: { pos in
                print("finished bubble as pos: \(pos.rawValue)")
                self.gradiantView.animateReset(0.8, afterDelay: 0, completion: { pos in
                    self.restartloop()
                })
            })
            self.trianglesView.animate(1.2, { pos in
                print("finished at pos: \(pos.rawValue)")
            })
        }
    }

    func restartloop() {
        gradiantView.resetPosition()
        bubblesView.resetPosition()
        trianglesView.resetPosition()
        startLoop()
    }
}

