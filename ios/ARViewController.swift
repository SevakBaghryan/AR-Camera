import UIKit
import ARKit

class ARViewController: UIViewController, ARSCNViewDelegate {

    var arView: ARSCNView!
    var currentColor: UIColor = .blue {
        didSet {
            colorIndicatorView.backgroundColor = currentColor
        }
    }
    var touchPoints: [SCNVector3] = []
    var isPaintingEnabled: Bool = true  

    lazy var colorIndicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = currentColor
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        arView = ARSCNView()
        arView.delegate = self
        self.view = arView

        arView.autoenablesDefaultLighting = true
        arView.automaticallyUpdatesLighting = true
        arView.scene = SCNScene()

        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal  
        arView.session.run(configuration)

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        arView.addGestureRecognizer(panGesture)

        let randomColorButton = UIButton(type: .system)
        randomColorButton.setTitle("Random Color", for: .normal)
        randomColorButton.addTarget(self, action: #selector(changeToRandomColor), for: .touchUpInside)

        let clearButton = UIButton(type: .system)
        clearButton.setTitle("Clear", for: .normal)
        clearButton.addTarget(self, action: #selector(clearDrawings), for: .touchUpInside)
        
        let stackView = UIStackView(arrangedSubviews: [randomColorButton, colorIndicatorView])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            colorIndicatorView.widthAnchor.constraint(equalToConstant: 20),
            colorIndicatorView.heightAnchor.constraint(equalToConstant: 20)
        ])

        view.addSubview(clearButton)
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            clearButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            clearButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    @objc func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        guard isPaintingEnabled else { return }

        switch gestureRecognizer.state {
        case .began, .changed:
            let touchLocation = gestureRecognizer.location(in: arView)
            if let hitResult = arView.hitTest(touchLocation, types: .existingPlane).first {
                let newPoint = SCNVector3(hitResult.worldTransform.columns.3.x,
                                          hitResult.worldTransform.columns.3.y,
                                          hitResult.worldTransform.columns.3.z)
                touchPoints.append(newPoint)

                let sphere = SCNSphere(radius: 0.03)
                let sphereNode = SCNNode(geometry: sphere)
                sphereNode.position = newPoint
                sphereNode.geometry?.firstMaterial?.diffuse.contents = currentColor
                arView.scene.rootNode.addChildNode(sphereNode)

                if touchPoints.count > 1 {
                    let line = SCNGeometry.lineBetween(points: touchPoints, color: currentColor)
                    let lineNode = SCNNode(geometry: line)
                    arView.scene.rootNode.addChildNode(lineNode)
                }
            }
        default:
            touchPoints.removeAll()
        }
    }

    @objc func changeToRandomColor() {
        currentColor = UIColor.random
    }

    @objc func clearDrawings() {
        arView.scene.rootNode.enumerateChildNodes { (node, _) in
            node.removeFromParentNode()
        }
    }
}

extension UIColor {
    static var random: UIColor {
        return UIColor(red: CGFloat(drand48()),
                       green: CGFloat(drand48()),
                       blue: CGFloat(drand48()),
                       alpha: 1.0)
    }
}

extension SCNGeometry {
    static func lineBetween(points: [SCNVector3], color: UIColor) -> SCNGeometry {
        let sources = SCNGeometrySource(vertices: points)
        var indices: [Int32] = []
        for i in 0..<points.count {
            indices.append(Int32(i))
        }

        let elements = SCNGeometryElement(indices: indices, primitiveType: .line)

        let line = SCNGeometry(sources: [sources], elements: [elements])
        let material = SCNMaterial()
        material.diffuse.contents = color
        line.materials = [material]

        return line
    }
}
