import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller = window?.rootViewController as! FlutterViewController
    let arChannel = FlutterMethodChannel(name: "ar_view_channel", binaryMessenger: controller.binaryMessenger)

    arChannel.setMethodCallHandler { (call, result) in
        if call.method == "startAR" {
            let arViewController = ARViewController()
            controller.present(arViewController, animated: true, completion: nil)
            result(nil)
        } else {
            result(FlutterMethodNotImplemented)
        }
    }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
