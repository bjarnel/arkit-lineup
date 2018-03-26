//
//  BillboardUtil.swift
//  LineUp
//
//  Created by Bjarne Møller Lundgren on 26/03/2018.
//  Copyright © 2018 Bjarne Møller Lundgren. All rights reserved.
//

import UIKit
import SceneKit

class BillboardUtil {
    static let nodeSize = CGSize(width: 0.25,
                                 height: 0.1)
    static let textureSize = CGSize(width: 250.0,
                                    height: 100.0)
    
    class func billboardMaterial(forPlayer player:Player,
                                 inTeam team:Team) -> Any {
        let text = player.name + "\n" + team.name
        
        // create texture for billboard node (using code from tour de france hack)
        // create a custom material with text on it..
        // https://stackoverflow.com/questions/28387116/write-text-on-sphere-surface-scenekit
        let layer = CALayer()
        layer.frame = CGRect(x: 0,
                             y: 0,
                             width: textureSize.width,
                             height: textureSize.height)
        layer.backgroundColor = UIColor.orange.withAlphaComponent(0.8).cgColor
        
        let textLayer = CATextLayer()
        textLayer.frame = layer.bounds
        textLayer.fontSize = 20
        textLayer.string = text
        textLayer.alignmentMode = kCAAlignmentCenter
        textLayer.foregroundColor = UIColor.white.cgColor
        textLayer.display()
        layer.addSublayer(textLayer)
        
        return layer
    }
}
