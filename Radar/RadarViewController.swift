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
        addSpaceships(count: randomPlanesCount)
    }

    func drawCircles(count: Int) {
        radiusOffset = maxRadius / CGFloat(count)
        guard var currentRadius = radiusOffset else { return }
        for _ in 1...count {
            let circlePath = UIBezierPath(arcCenter: CGPoint(x: view.center.x, y: view.center.y), radius: currentRadius, startAngle: 0, endAngle:CGFloat(Double.pi * 2), clockwise: true)
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = circlePath.cgPath
            shapeLayer.fillColor = UIColor.clear.cgColor
            shapeLayer.strokeColor = UIColor.white.cgColor
            shapeLayer.lineWidth = 1.0
            view.layer.addSublayer(shapeLayer)
            currentRadius += radiusOffset
        }
    }
    
    func addSpaceships(count: Int) {
        
        // Calculate valid radiuses to place spaceships.
        let planeRadiusOffset = radiusOffset / 2
        var currentOffset = planeRadiusOffset
        var validRadiuses = [CGFloat]()
        var availableAngles = [CGFloat: [CGFloat]]()
        for _ in 1...randomCirclesCount {
            validRadiuses.append(currentOffset)
            availableAngles[currentOffset] = [CGFloat]()
            currentOffset += radiusOffset
        }
        
        // For each radius calculate available angles and add them to `availableAngles`. The first angle calculates randomly.
        for radius in validRadiuses {
            let anglesCount = Int(2 * .pi * radius / ((radiusOffset - 4) * 1.1))
            let angleStep = CGFloat(2 * .pi / Double(anglesCount))
            let randomAngle = CGFloat(Double.random(in: 0...(2 * .pi)))
            for i in 0...anglesCount - 1 {
                let angle = randomAngle + (angleStep * CGFloat(i))
                availableAngles[radius]?.append(angle)
            }
        }
        
        // Add spaceships image views to view. Place spaceship on the available angle and remove angle from the `availableAngles`. If `availableAngles` is empty, place spaceship randomly on that radius.
        for _ in 0...count - 1 {
            let randomRadius = validRadiuses[Int.random(in: 0...(validRadiuses.count - 1))]
            let randomAngle = availableAngles[randomRadius]!.randomElement() != nil ? availableAngles[randomRadius]!.randomElement()! : CGFloat(Double.random(in: 0...(2 * .pi)))
            let index = availableAngles[randomRadius]!.firstIndex(of: randomAngle)
            if !availableAngles[randomRadius]!.isEmpty {
                availableAngles[randomRadius]?.remove(at: index!)
            }
            let imageViewSide = radiusOffset - 4
            let point = CGPoint(x: view.center.x - imageViewSide / 2 + cos(randomAngle) * randomRadius, y: view.center.y - imageViewSide / 2 + sin(randomAngle) * randomRadius)
            let imageView = UIImageView(image: UIImage(named: "falcon"))
            view.addSubview(imageView)
            imageView.frame = CGRect(x: point.x, y: point.y, width: imageViewSide, height: imageViewSide)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
 }


