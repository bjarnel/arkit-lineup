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
    var nodeToPlayer = [String : (team:Team,
                                  player:Player)]()
    var billboardNode:SCNNode? = nil
    
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
    
    private func initLineUp(location:CGPoint) {
        guard fieldNode == nil,
              let planeData = anyPlaneFrom(location: location) else { return }
        
        let node = FieldNode.node()
        node.position = planeData.1
        fieldNode = node
        
        sceneView.scene.rootNode.addChildNode(node)
        
        render(team:Test.denmark)
        render(team:Test.germany, side:1)
    }
    
    private func tap(location:CGPoint) {
        guard let fieldNode = fieldNode else { return }
            
        let hitResults = sceneView.hitTest(location, options: [SCNHitTestOption.firstFoundOnly:     true,
                                                               SCNHitTestOption.rootNode:           fieldNode/*,
                                                               SCNHitTestOption.boundingBoxOnly:    true*/])
        
        print(hitResults)
        guard let node = hitResults.first?.node.parent,
              let nodeName = node.name,
              let playerTeamInfo = nodeToPlayer[nodeName] else {
                hideAnyActiveBillboard()
                return
        }
        
        showBillboard(forPlayer: playerTeamInfo.player,
                      inTeam: playerTeamInfo.team,
                      above: node)
    }
    
    @objc func didTap(_ sender:UITapGestureRecognizer) {
        let location = sender.location(in: sceneView)
        
        if fieldNode == nil {
            initLineUp(location: location)
        } else {
            tap(location: location)
        }
    }
    
    private func hideAnyActiveBillboard() {
        billboardNode?.removeFromParentNode()
        billboardNode = nil
    }
    
    private func showBillboard(forPlayer player:Player,
                               inTeam team:Team,
                               above playerNode:SCNNode) {
        guard let fieldNode = fieldNode else { return }
        
        // create billboard node if doesnt exist already
        if billboardNode == nil {
            let planeGeometry = SCNPlane(width: BillboardUtil.nodeSize.width,
                                         height: BillboardUtil.nodeSize.height)
            planeGeometry.firstMaterial?.locksAmbientWithDiffuse = true
            billboardNode = SCNNode(geometry: planeGeometry)
            billboardNode!.constraints = [SCNBillboardConstraint()]
            fieldNode.addChildNode(billboardNode!)
        }
        
        billboardNode?.geometry?.firstMaterial?.diffuse.contents = BillboardUtil.billboardMaterial(forPlayer: player,
                                                                                                   inTeam: team)
        billboardNode!.position = playerNode.position
        billboardNode!.position.y += Float(LumberJack.height * LumberJack.scale)
    }
    
    private func render(team:Team, side:Int = 0) {
        guard let fieldNode = fieldNode else { return }
        
        // length of half of the field
        let halfLengthOfField = Double(FieldNode.nodeSize.width) * 0.5
        // width of field
        let widthOfField = Double(FieldNode.nodeSize.height)
        // offset between each "line" of players
        let positionOffset = halfLengthOfField / (Double(Position.all().count) - 0.5)
        
        for (index, position) in Position.all().enumerated() {
            var x = Double(index) * positionOffset
            if side == 0 {
                x -= halfLengthOfField
            } else {
                x = halfLengthOfField - x
            }
            
            let players = team.players.filter { $0.position == position }
            let sideOffset = widthOfField / Double(players.count + 1)
            
            // render players..
            for (pIndex, player) in players.enumerated() {
                let y = sideOffset + sideOffset * Double(pIndex) - (widthOfField * 0.5)
                
                let jumperJackNode = LumberJack.node()
                jumperJackNode.position.x = Float(x)
                jumperJackNode.position.z = Float(y)
                
                jumperJackNode.eulerAngles = SCNVector3(0, side == 0 ? 90.0.degreesToRadians : -90.0.degreesToRadians, 0)
                
                let playerNodeId = UUID().uuidString
                jumperJackNode.name = playerNodeId
                nodeToPlayer[playerNodeId] = (team: team,
                                              player: player)
                
                //TODO: colorize model!
                
                fieldNode.addChildNode(jumperJackNode)
            }
        }
    }

    // MARK: - ARSCNViewDelegate
    
}

