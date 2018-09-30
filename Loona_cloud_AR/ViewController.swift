//
//  ViewController.swift
//  Loona_cloud_AR
//
//  Created by Royalty on 27/09/2018.
//  Copyright © 2018 Royalty Inc. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import AVFoundation
import SpriteKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        
        guard let arImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else { return }
        
        configuration.trackingImages = arImages
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARImageAnchor else { return }
        
        //Container
        guard let container = sceneView.scene.rootNode.childNode(withName: "container", recursively: false) else { return }
        
        container.removeFromParentNode()
        node.addChildNode(container)
        container.isHidden = false
        
        // Video
        let videoURL = Bundle.main.url(forResource: "video", withExtension: "mp4")!
        let videoPlayer = AVPlayer(url: videoURL)
        let videoScene = SKScene(size: CGSize(width: 720.0, height: 1280.0))
        let videoNode = SKVideoNode(avPlayer: videoPlayer)
        
        videoNode.position = CGPoint(x: videoScene.size.width / 2, y: videoScene.size.height / 2)
        videoNode.size = videoScene.size
        videoNode.yScale = -1
        videoNode.play()
        videoScene.addChild(videoNode)
        
        guard let video = container.childNode(withName: "video", recursively: false) else { return }
        video.geometry?.firstMaterial?.diffuse.contents = videoScene
        
        // Animations
    }
}
