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
    static let textureSize = CGSize(width: 1463.0,     // length of field texture
                                    height: 1024.0)    // width of field texture
    static let textureInset = CGSize(width: 98.0,    //padding in texture behind goals
                                     height: 93.0)   // padding in texture on the sides of the field
    static let lengthOfField = 100.0    // meters scale
    static let scale = 0.02/*0.01*/ // == 1 meter = 100 meter
    static let nodeSize = CGSize(width: lengthOfField * scale * Double((textureSize.width - textureInset.width * 2.0) / textureSize.width),
                                 height: ((Double(textureSize.height - textureInset.height * 2.0) * lengthOfField) / Double(textureSize.width - textureInset.width * 2.0)) * scale)
    static let nodeSizeIncludingPadding = CGSize(width: lengthOfField * scale,
                                                 height: ((Double(textureSize.height) * lengthOfField) / Double(textureSize.width)) * scale)
    
    class func material() -> SCNMaterial {
        let m = SCNMaterial()
        m.diffuse.contents = UIImage(named: "art.scnassets/s/soccerfield.png")!
        
        return m
    }
    
    class func node() -> SCNNode {
        let plane = SCNPlane(width: nodeSizeIncludingPadding.width,
                             height: nodeSizeIncludingPadding.height)
        plane.firstMaterial = material()
        let innerNode = SCNNode(geometry: plane)
        innerNode.eulerAngles = SCNVector3(-90.0.degreesToRadians, 0, 0)
        
        let node = SCNNode()
        node.addChildNode(innerNode)

        return node
    }
    
    
}
