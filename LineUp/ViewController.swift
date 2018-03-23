//
//  ViewController.swift
//  LineUp
//
//  Created by Bjarne Møller Lundgren on 23/03/2018.
//  Copyright © 2018 Bjarne Møller Lundgren. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    var fieldNode:SCNNode? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.scene = SCNScene()
        sceneView.overlaySKScene = SKScene(size: view.frame.size)
        
        let tapGest = UITapGestureRecognizer(target: self,
                                             action: #selector(didTap))
        sceneView.addGestureRecognizer(tapGest)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        configuration.isLightEstimationEnabled = true
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        sceneView.overlaySKScene?.size = view.frame.size
    }
    
    private func anyPlaneFrom(location:CGPoint, usingExtent:Bool = true) -> (SCNNode, SCNVector3, ARPlaneAnchor)? {
        let results = sceneView.hitTest(location,
                                        types: usingExtent ? ARHitTestResult.ResultType.existingPlaneUsingExtent : ARHitTestResult.ResultType.existingPlane)
        
        guard results.count > 0,
              let anchor = results[0].anchor as? ARPlaneAnchor,
              let node = sceneView.node(for: anchor) else { return nil }
        
        return (node,
                SCNVector3Make(results[0].worldTransform.columns.3.x, results[0].worldTransform.columns.3.y, results[0].worldTransform.columns.3.z),
                anchor)
    }
    
    @objc func didTap(_ sender:UITapGestureRecognizer) {
        let location = sender.location(in: sceneView)
        
        guard fieldNode == nil,
              let planeData = anyPlaneFrom(location: location) else { return }
        
        let node = FieldNode.node()
        node.position = planeData.1
        fieldNode = node
        
        sceneView.scene.rootNode.addChildNode(node)
    }

    // MARK: - ARSCNViewDelegate
    
}

