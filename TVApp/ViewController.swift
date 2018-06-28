//
//  ViewController.swift
//  TVApp
//
//  Created by James Rochabrun on 6/27/18.
//  Copyright © 2018 James Rochabrun. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import SpriteKit
import AVFoundation

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
        sceneView.isPlaying = true
        
        // 1 creat a spritekit video node and specify which video we want to play
        guard let spriteKitScene = createSpriteKitScene() else { return }
        // 2 Create a Scenkit plane and add the spritekit scene as its material
        let planes = createSceneKitPlane(in: spriteKitScene)
        // 3 add the tv and the black box to the scene
        planes.map { scene.rootNode.addChildNode($0) }
    }
    
    private func createSpriteKitScene() -> SKScene? {
        
        // 1.1 A SpriteKit scene to contain the Spritekit video node
        let spriteKitScene = SKScene(size: CGSize(width: sceneView.frame.width, height: sceneView.frame.height))
        spriteKitScene.scaleMode =  .aspectFit
        
        // 1.2 Create a video player, which will be responsible for the playback pf the video material
        guard let videoUrl = Bundle.main.url(forResource: "peru", withExtension: "mp4") else { return nil }
        let videoPlayer = AVPlayer(url: videoUrl)
        
        // 1.3 Create the Sprite kit video node, containing the video player
        let videoSpriteKitNode = SKVideoNode(avPlayer: videoPlayer)
        videoSpriteKitNode.position = CGPoint(x: spriteKitScene.size.width / 2.0, y: spriteKitScene.size.height / 2.0)
        videoSpriteKitNode.size = spriteKitScene.size
        videoSpriteKitNode.yScale = -1.0 // this will help to not be upside down
        videoSpriteKitNode.play()
        spriteKitScene.addChild(videoSpriteKitNode)
        
        return spriteKitScene
    }
    
    func createSceneKitPlane(in scene: SKScene) -> [SCNNode] {
        
        let backGround = SCNPlane(width: CGFloat(0.288*2), height: CGFloat(0.18*2))
        backGround.firstMaterial?.diffuse.contents = scene
        let backGroundNode = SCNNode(geometry: backGround)
        backGroundNode.position = SCNVector3(0,0,-1) // 3D one meter in front of us
        
        /// do the box for the tv
        let backGroundBox = SCNBox.init(width: backGround.width*1.1, height: backGround.height*1.1, length: 0.025, chamferRadius: 0)
        backGroundBox.firstMaterial?.diffuse.contents = UIColor.black
        let backGroundBoxNode = SCNNode(geometry: backGroundBox)
        backGroundBoxNode.position = SCNVector3(0,0,-1.013) // 3D one meter in front of us
        
        return [backGroundNode, backGroundBoxNode]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
}
