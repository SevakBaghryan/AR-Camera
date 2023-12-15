import UIKit
import ARKit

class ARViewController: UIViewController, ARSCNViewDelegate {

    var arView: ARSCNView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Create AR view
        arView = ARSCNView()
        arView.delegate = self
        self.view = arView

        // Create a simple sphere
        let sphere = SCNSphere(radius: 0.1)
        let sphereNode = SCNNode(geometry: sphere)

        // Set the color of the sphere to deep purple with a metallic effect
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.purple
        material.metalness.contents = 1.0
        material.roughness.contents = 0.0
        sphere.materials = [material]

        sphereNode.position = SCNVector3(0, 0, -0.5)

        // Add a light source to emphasize the metallic effect
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.type = .omni
        lightNode.position = SCNVector3(0, 2, -2) // Adjust the position as needed
        arView.scene.rootNode.addChildNode(lightNode)

        // Add the sphere to the AR scene
        arView.scene.rootNode.addChildNode(sphereNode)

        // Configure AR session
        let configuration = ARWorldTrackingConfiguration()
        arView.session.run(configuration)
    }

    // Implement any additional ARSCNViewDelegate methods if needed
}
