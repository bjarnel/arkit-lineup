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
    static let height = 1.86        // height of character
    static let thickness = 0.351    // front to back
    static let width = 1.808        // hand to hand (yes its wide, because of the stupid posture!)
    static let scale = 0.1/*0.05*/ // not to scale! scale would be 0.01
    
    class func node() -> SCNNode {
        if _referenceNode == nil {
            guard let scene = SCNScene(named: "art.scnassets/LumberJack/lumberJack_triangulated"),
                  let node = scene.rootNode.childNode(withName: "lumberJack",
                                                      recursively: true) else { fatalError() }
            node.scale = SCNVector3(scale, scale, scale)
            _referenceNode = node
        }
        
        let innerNode = _referenceNode!.clone()
        // we need to copy the geomatry over as well, in order to enable distinct materials. yeah it makes it less
        // performant. It should use the same vertices.. I hope
        // https://forums.developer.apple.com/thread/47588
        innerNode.geometry = _referenceNode!.geometry!.copy() as? SCNGeometry
        
        
        let node = SCNNode()
        node.addChildNode(innerNode)
        node.position.y = Float(height * 0.5 * scale)
        
        return node
    }
}
