import Flutter
import UIKit
import AVFoundation

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    setupCameraPermissionChannel(controller: controller)
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  private func setupCameraPermissionChannel(controller: FlutterViewController) {
    let channel = FlutterMethodChannel(name: "camera_permission_channel", binaryMessenger: controller.binaryMessenger)
    
    channel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      switch call.method {
      case "checkCameraPermission":
        self.checkCameraPermission(result: result)
      default:
        result(FlutterMethodNotImplemented)
      }
    })
  }
  
  private func checkCameraPermission(result: @escaping FlutterResult) {
    AVCaptureDevice.requestAccess(for: .video) { granted in
      DispatchQueue.main.async {
        if granted {
          // Kamera izni verildi
          result(true)
        } else {
          // Kamera izni verilmedi
          result(false)
        }
      }
    }
  }
}
