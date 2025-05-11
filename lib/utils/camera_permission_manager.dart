import 'dart:io';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraPermissionManager {
  static const MethodChannel _channel = MethodChannel('camera_permission_channel');
  
  /// iOS'ta kamera iznini doğrudan talep eder
  static Future<bool> requestCameraPermission() async {
    try {
      // Önce permission_handler ile kontrol et
      final status = await Permission.camera.status;
      if (status.isGranted) {
        return true;
      }
      
      final result = await Permission.camera.request();
      
      if (Platform.isIOS) {
        // iOS'ta ek olarak kamera erişimini denemek için
        await Future.delayed(const Duration(seconds: 1));
        await _forceIOSPermission();
      }
      
      return result.isGranted;
    } catch (e) {
      print('Kamera izni isteme hatası: $e');
      return false;
    }
  }

  /// iOS kamera iznini zorlamak için
  static Future<void> _forceIOSPermission() async {
    try {
      // Bu metot direkt AVCaptureDevice çağrıyor
      if (Platform.isIOS) {
        // Native kamera çağrısı ile izni zorlayalım
        await _channel.invokeMethod('checkCameraPermission');
      }
    } catch (e) {
      print('iOS kamera izni zorlanamadı: $e');
    }
  }
  
  /// Kamera izni varsa true döner
  static Future<bool> hasCameraPermission() async {
    final status = await Permission.camera.status;
    return status.isGranted;
  }
  
  /// Uygulama ayarlarını açar
  static Future<void> openAppSettings() async {
    await Permission.camera.request();
  }
} 