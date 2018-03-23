//
//  FieldNode.swift
//  LineUp
//
//  Created by Bjarne Møller Lundgren on 23/03/2018.
//  Copyright © 2018 Bjarne Møller Lundgren. All rights reserved.
//

import Foundation
import SceneKit
import SpriteKit

final class FieldNode{
    static let size = CGSize(width: 1463.0, height: 1024.0)
    static let lengthOfField = 100.0    // meters scale
    static let scale = 0.01 // == 1 meter = 100 meter
    
    class func material() -> SCNMaterial {
        let m = SCNMaterial()
        m.diffuse.contents = UIImage(named: "art.scnassets/s/soccerfield.png")!
        
        return m
    }
    
    class func node() -> SCNNode {
        let width = lengthOfField * scale
        let height = ((Double(size.height) * lengthOfField) / Double(size.width)) * scale
        
        let plane = SCNPlane(width: CGFloat(width),
                             height: CGFloat(height))
        plane.firstMaterial = material()
        let innerNode = SCNNode(geometry: plane)
        innerNode.eulerAngles = SCNVector3(-90.0.degreesToRadians, 0, 0)
        
        let node = SCNNode()
        node.addChildNode(innerNode)

        return node
    }
    
    
}
