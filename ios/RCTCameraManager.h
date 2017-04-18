#import <React/RCTViewManager.h>
#import <AVFoundation/AVFoundation.h>

@class RCTCamera;

typedef NS_ENUM(NSInteger, RCTCameraAspect) {
  RCTCameraAspectFill = 0,
  RCTCameraAspectFit = 1,
  RCTCameraAspectStretch = 2
};

typedef NS_ENUM(NSInteger, RCTCameraCaptureSessionPreset) {
  RCTCameraCaptureSessionPresetLow = 0,
  RCTCameraCaptureSessionPresetMedium = 1,
  RCTCameraCaptureSessionPresetHigh = 2,
  RCTCameraCaptureSessionPresetPhoto = 3,
  RCTCameraCaptureSessionPreset480p = 4,
  RCTCameraCaptureSessionPreset720p = 5,
  RCTCameraCaptureSessionPreset1080p = 6
};

typedef NS_ENUM(NSInteger, RCTCameraCaptureMode) {
  RCTCameraCaptureModeStill = 0,
  RCTCameraCaptureModeVideo = 1
};

typedef NS_ENUM(NSInteger, RCTCameraCaptureTarget) {
  RCTCameraCaptureTargetMemory = 0,
  RCTCameraCaptureTargetDisk = 1,
  RCTCameraCaptureTargetTemp = 2,
  RCTCameraCaptureTargetCameraRoll = 3
};

typedef NS_ENUM(NSInteger, RCTCameraOrientation) {
  RCTCameraOrientationAuto = 0,
  RCTCameraOrientationLandscapeLeft = AVCaptureVideoOrientationLandscapeLeft,
  RCTCameraOrientationLandscapeRight = AVCaptureVideoOrientationLandscapeRight,
  RCTCameraOrientationPortrait = AVCaptureVideoOrientationPortrait,
  RCTCameraOrientationPortraitUpsideDown = AVCaptureVideoOrientationPortraitUpsideDown
};

typedef NS_ENUM(NSInteger, RCTCameraType) {
  RCTCameraTypeFront = AVCaptureDevicePositionFront,
  RCTCameraTypeBack = AVCaptureDevicePositionBack
};

typedef NS_ENUM(NSInteger, RCTCameraFlashMode) {
  RCTCameraFlashModeOff = AVCaptureFlashModeOff,
  RCTCameraFlashModeOn = AVCaptureFlashModeOn,
  RCTCameraFlashModeAuto = AVCaptureFlashModeAuto
};

typedef NS_ENUM(NSInteger, RCTCameraTorchMode) {
  RCTCameraTorchModeOff = AVCaptureTorchModeOff,
  RCTCameraTorchModeOn = AVCaptureTorchModeOn,
  RCTCameraTorchModeAuto = AVCaptureTorchModeAuto
};

@interface RCTCameraManager : RCTViewManager

@end
