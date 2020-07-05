//
//  ColorWheelViewController.swift
//  WheelyCoolApp
//
//  Created by Simon Italia on 7/3/20.
//  Copyright © 2020 SDI Group Inc. All rights reserved.
//

import UIKit
import SpriteKit

class ColorWheelViewController: UIViewController {
    
    //MARK: - Class Properties
    
    var colors: [Color]? //property passed in from senderVC
    
    //UI objects
    private lazy var wheelView = SKView()
    private lazy var spinButton = UIButton()
    
    //SKScene objets
    private lazy var scene = SKScene()
    
    private lazy var wheel: SKShapeNode = {
        return createWheelContainer()
    }()
    
    private var rect: CGRect {
        return CGRect(origin: scene.position, size: scene.size)
    }
 
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureWheelView()
        configureSpinWheelButton()
        createWheel()
    }

    
    //MARK: - ViewController Configuration
    
    private func configureNavigationBar() {
        title = "COLOR WHEEL"
    }
    
    
    private func configureSpinWheelButton() {
        view.addSubview(spinButton)
        
        spinButton.setTitle("SPIN", for: .normal)
        spinButton.backgroundColor = .systemBlue
        spinButton.titleLabel?.textColor = .white
        spinButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        
        //constraints
        spinButton.translatesAutoresizingMaskIntoConstraints = false
        let padding: CGFloat = 20
        NSLayoutConstraint.activate([
            spinButton.heightAnchor.constraint(equalToConstant: 50),
            spinButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -padding),
            spinButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            spinButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
        ])
        
        //button action
        spinButton.addTarget(self, action: #selector(spinButtonTapped), for: .touchUpInside)
    }
    
    
    private func configureWheelView() {
        view.addSubview(wheelView)
        
        //configure SKView
        let dimension = view.frame.width * 0.9
        let size = CGSize(width: dimension, height: dimension)
        wheelView.frame.size = size
        wheelView.center.x = view.frame.midX
        wheelView.center.y = view.frame.midY - 50

        //configure SKScene
        if wheelView.scene == nil {
            scene.size = wheelView.frame.size
            scene.backgroundColor = .white
            scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            wheelView.presentScene(scene)
        }
    }
}


//MARK: - Wheel Maker Factory

extension ColorWheelViewController {
    
    private func createWheel() {
        createWheelSegments()
        createWheelPointer()
    }
    
    
    private func createWheelPointer() {
        let image = UIImage(systemName: "play.fill")
        
        var texture: SKTexture?
        if let image = image {
            texture = SKTexture(image: image)
        }
        
        let dimension: CGFloat = 15
        let pointer = SKSpriteNode()
        pointer.texture = texture
        pointer.size = CGSize(width: dimension, height: dimension)
        
        let positionX = scene.frame.maxX - dimension / 2
        let positionY = scene.frame.midY
        pointer.position = CGPoint(x: positionX, y: positionY)
        pointer.zRotation = .pi
        scene.addChild(pointer)
    }
    
    
    private func createWheelContainer() -> SKShapeNode {
        let inset: CGFloat = 90
        let lineWidth: CGFloat = 25
        let rectInset = rect.insetBy(dx: inset, dy: inset)
        let radius = rectInset.size.width / 2
        
        let container = SKShapeNode(circleOfRadius: radius)
        container.fillColor = .systemBlue
        container.strokeColor = .white
        container.lineWidth = lineWidth
        return container
    }
    
    
    //create colored wheel segements
    private func createWheelSegments() {
        guard let colors = self.colors else { fatalError("Colors should not be nil!") }
        
        let lineWidth: CGFloat = 90
        let inset = lineWidth / 2 + 5

        let center = CGPoint(x: rect.minX, y: rect.minY)
        let rectInset = rect.insetBy(dx: inset, dy: inset)
        let radius = rectInset.size.width / 2

        let segments = CGFloat(colors.count)
        let segmentGap: CGFloat = 0.0
        let segmentAngleSize: CGFloat = (2.0 * .pi - CGFloat(segments) * segmentGap) / CGFloat(segments)
        
        //create each color segment
        for (index, color) in colors.enumerated() {
            let start = CGFloat(index) * (segmentAngleSize + segmentGap) - .pi / 2.0
            let end = start + segmentAngleSize
            
            let segmentPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: start, endAngle: end, clockwise: true)
            let colorSegment = SKShapeNode(path: segmentPath.cgPath)
            colorSegment.strokeColor = color.shade
            colorSegment.lineWidth = lineWidth
            wheel.addChild(colorSegment)
        }
        
        scene.addChild(wheel)
    }
}


//MARK: - Spin Wheel Logic

extension ColorWheelViewController {
    @objc private func spinButtonTapped() {
        spin(wheel)
    }
    
    
    private func spin(_ wheel: SKShapeNode) {
        let rotations = Int.random(in: 3...5)
        let degrees = 360 * rotations
        let randomDegrees = Int.random(in: 360...degrees)
        let radians = randomDegrees.degreesToRadians()
        
        let rotate = SKAction.rotate(byAngle: -radians, duration: 1.25) //negative radians = rotate clockwise
        wheel.run(rotate)
    }
}
