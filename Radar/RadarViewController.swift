//
//  RadarViewController.swift
//  Radar
//
//  Created by Руслан Акберов on 19/10/2018.
//  Copyright © 2018 Ruslan Akberov. All rights reserved.
//

import UIKit

class RadarViewController: UIViewController {
    
    let maxRadius = UIScreen.main.bounds.width / 2 - 8
    let randomCirclesCount = Int.random(in: 1...20)
    let randomPlanesCount = Int.random(in: 0...100)
    var radiusOffset: CGFloat!

    override func viewDidLoad() {
        super.viewDidLoad()
        drawCircles(count: randomCirclesCount)
        addPlanes(count: randomPlanesCount)
    }

    func drawCircles(count: Int) {
        radiusOffset = maxRadius / CGFloat(count)
        guard var currentRadius = radiusOffset else { return }
        for _ in 1...count {
            let circlePath = UIBezierPath(arcCenter: CGPoint(x: view.center.x, y: view.center.y), radius: currentRadius, startAngle: 0, endAngle:CGFloat(Double.pi * 2), clockwise: true)
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = circlePath.cgPath
            shapeLayer.fillColor = UIColor.clear.cgColor
            shapeLayer.strokeColor = UIColor.gray.cgColor
            shapeLayer.lineWidth = 1.0
            view.layer.addSublayer(shapeLayer)
            currentRadius += radiusOffset
        }
    }
    
    func addPlanes(count: Int) {
        let planeRadiusOffset = radiusOffset / 2
        var currentOffset = planeRadiusOffset
        var validRadiuses = [CGFloat]()
        for _ in 1...randomCirclesCount {
            validRadiuses.append(currentOffset)
            currentOffset += radiusOffset
        }
        for _ in 1...count {
            let randomRadius = validRadiuses[Int.random(in: 0...(validRadiuses.count - 1))]
            let randomAngle = CGFloat(Double.random(in: -3.14...3.14))
            let imageViewSide = radiusOffset - 4
            let point = CGPoint(x: view.center.x - imageViewSide / 2 + cos(randomAngle) * randomRadius, y: view.center.y - imageViewSide / 2 + sin(randomAngle) * randomRadius)
            let imageView = UIImageView(image: UIImage(named: "falcon"))
            view.addSubview(imageView)
            imageView.frame = CGRect(x: point.x, y: point.y, width: radiusOffset - 4, height: radiusOffset - 4)
        }
    }

}

