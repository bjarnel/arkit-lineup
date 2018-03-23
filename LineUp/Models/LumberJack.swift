//
//  LumberJack.swift
//  LineUp
//
//  Created by Bjarne Møller Lundgren on 23/03/2018.
//  Copyright © 2018 Bjarne Møller Lundgren. All rights reserved.
//

import Foundation
import SceneKit

final class LumberJack {
    private static var _referenceNode:SCNNode?
    static let height = 1.86
    // 0.351 w
    // 1.808 d
    static let scale = 0.05 // not to scale! scale would be 0.01
    
    class func node() -> SCNNode {
        if _referenceNode == nil {
            guard let scene = SCNScene(named: "art.scnassets/LumberJack/lumberJack_triangulated"),
                  let node = scene.rootNode.childNode(withName: "lumberJack",
                                                      recursively: true) else { fatalError() }
            node.scale = SCNVector3(scale, scale, scale)
            _referenceNode = node
        }
        
        let innerNode = _referenceNode!.clone()
        
        
        let node = SCNNode()
        node.addChildNode(innerNode)
        node.position.y = Float(height * 0.5 * scale)
        
        return node
    }
}
