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

    override func viewDidLoad() {
        super.viewDidLoad()
        testView.layer.borderColor = UIColor.lightGray.cgColor
        testView.layer.borderWidth = 1
        trianglesView.config()
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
        gradiantView.resetPosition()
        gradiantView.animateLeft(1, afterDelay: 2) { pos in
            self.trianglesView.animate({ pos in
                print("finished at pos: \(pos.rawValue)")
            })
        }
    }
}

