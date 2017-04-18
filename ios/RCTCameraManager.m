#import "RCTCameraManager.h"
#import "RCTCamera.h"
#import <React/RCTBridge.h>
#import <React/RCTUIManager.h>
#import <React/RCTEventDispatcher.h>
#import <React/RCTUtils.h>
#import <React/RCTLog.h>
#import <React/UIView+React.h>
#import "NSMutableDictionary+ImageMetadata.m"
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <ImageIO/ImageIO.h>


@implementation RCTCameraManager

RCT_EXPORT_MODULE();

- (UIView *)viewWithProps:(__unused NSDictionary *)props
{
    return [[RCTCamera alloc] initWithBridge:self.bridge props:props];
}

- (UIView *)view
{
    return [self viewWithProps:nil];
}

- (NSDictionary *)constantsToExport
{
  return @{
           @"Aspect": @{
               @"stretch": @(RCTCameraAspectStretch),
               @"fit": @(RCTCameraAspectFit),
               @"fill": @(RCTCameraAspectFill)
               },
           @"BarCodeType": @{
               @"upce": AVMetadataObjectTypeUPCECode,
               @"code39": AVMetadataObjectTypeCode39Code,
               @"code39mod43": AVMetadataObjectTypeCode39Mod43Code,
               @"ean13": AVMetadataObjectTypeEAN13Code,
               @"ean8":  AVMetadataObjectTypeEAN8Code,
               @"code93": AVMetadataObjectTypeCode93Code,
               @"code128": AVMetadataObjectTypeCode128Code,
               @"pdf417": AVMetadataObjectTypePDF417Code,
               @"qr": AVMetadataObjectTypeQRCode,
               @"aztec": AVMetadataObjectTypeAztecCode
               #ifdef AVMetadataObjectTypeInterleaved2of5Code
               ,@"interleaved2of5": AVMetadataObjectTypeInterleaved2of5Code
               # endif
               #ifdef AVMetadataObjectTypeITF14Code
               ,@"itf14": AVMetadataObjectTypeITF14Code
               # endif
               #ifdef AVMetadataObjectTypeDataMatrixCode
               ,@"datamatrix": AVMetadataObjectTypeDataMatrixCode
               # endif
               },
           @"Type": @{
               @"front": @(RCTCameraTypeFront),
               @"back": @(RCTCameraTypeBack)
               },
           @"CaptureMode": @{
               @"still": @(RCTCameraCaptureModeStill),
               @"video": @(RCTCameraCaptureModeVideo)
               },
           @"CaptureQuality": @{
               @"low": @(RCTCameraCaptureSessionPresetLow),
               @"AVCaptureSessionPresetLow": @(RCTCameraCaptureSessionPresetLow),
               @"medium": @(RCTCameraCaptureSessionPresetMedium),
               @"AVCaptureSessionPresetMedium": @(RCTCameraCaptureSessionPresetMedium),
               @"high": @(RCTCameraCaptureSessionPresetHigh),
               @"AVCaptureSessionPresetHigh": @(RCTCameraCaptureSessionPresetHigh),
               @"photo": @(RCTCameraCaptureSessionPresetPhoto),
               @"AVCaptureSessionPresetPhoto": @(RCTCameraCaptureSessionPresetPhoto),
               @"480p": @(RCTCameraCaptureSessionPreset480p),
               @"AVCaptureSessionPreset640x480": @(RCTCameraCaptureSessionPreset480p),
               @"720p": @(RCTCameraCaptureSessionPreset720p),
               @"AVCaptureSessionPreset1280x720": @(RCTCameraCaptureSessionPreset720p),
               @"1080p": @(RCTCameraCaptureSessionPreset1080p),
               @"AVCaptureSessionPreset1920x1080": @(RCTCameraCaptureSessionPreset1080p)
               },
           @"CaptureTarget": @{
               @"memory": @(RCTCameraCaptureTargetMemory),
               @"disk": @(RCTCameraCaptureTargetDisk),
               @"temp": @(RCTCameraCaptureTargetTemp),
               @"cameraRoll": @(RCTCameraCaptureTargetCameraRoll)
               },
           @"Orientation": @{
               @"auto": @(RCTCameraOrientationAuto),
               @"landscapeLeft": @(RCTCameraOrientationLandscapeLeft),
               @"landscapeRight": @(RCTCameraOrientationLandscapeRight),
               @"portrait": @(RCTCameraOrientationPortrait),
               @"portraitUpsideDown": @(RCTCameraOrientationPortraitUpsideDown)
               },
           @"FlashMode": @{
               @"off": @(RCTCameraFlashModeOff),
               @"on": @(RCTCameraFlashModeOn),
               @"auto": @(RCTCameraFlashModeAuto)
               },
           @"TorchMode": @{
               @"off": @(RCTCameraTorchModeOff),
               @"on": @(RCTCameraTorchModeOn),
               @"auto": @(RCTCameraTorchModeAuto)
               }
           };
}

RCT_EXPORT_VIEW_PROPERTY(orientation, NSInteger);
RCT_EXPORT_VIEW_PROPERTY(defaultOnFocusComponent, BOOL);
RCT_EXPORT_VIEW_PROPERTY(onFocusChanged, BOOL);
RCT_EXPORT_VIEW_PROPERTY(onZoomChanged, BOOL);

RCT_CUSTOM_VIEW_PROPERTY(captureQuality, NSInteger, RCTCamera) {
  NSInteger quality = [RCTConvert NSInteger:json];
  NSString *qualityString;
  switch (quality) {
    default:
    case RCTCameraCaptureSessionPresetHigh:
      qualityString = AVCaptureSessionPresetHigh;
      break;
    case RCTCameraCaptureSessionPresetMedium:
      qualityString = AVCaptureSessionPresetMedium;
      break;
    case RCTCameraCaptureSessionPresetLow:
      qualityString = AVCaptureSessionPresetLow;
      break;
    case RCTCameraCaptureSessionPresetPhoto:
      qualityString = AVCaptureSessionPresetPhoto;
      break;
    case RCTCameraCaptureSessionPreset1080p:
      qualityString = AVCaptureSessionPreset1920x1080;
      break;
    case RCTCameraCaptureSessionPreset720p:
      qualityString = AVCaptureSessionPreset1280x720;
      break;
    case RCTCameraCaptureSessionPreset480p:
      qualityString = AVCaptureSessionPreset640x480;
      break;
  }

  [view setCaptureQuality:qualityString];
}

RCT_CUSTOM_VIEW_PROPERTY(aspect, NSInteger, RCTCamera) {
  NSInteger aspect = [RCTConvert NSInteger:json];
  NSString *aspectString;
  switch (aspect) {
    default:
    case RCTCameraAspectFill:
      aspectString = AVLayerVideoGravityResizeAspectFill;
      break;
    case RCTCameraAspectFit:
      aspectString = AVLayerVideoGravityResizeAspect;
      break;
    case RCTCameraAspectStretch:
      aspectString = AVLayerVideoGravityResize;
      break;
  }

  view.previewLayer.videoGravity = aspectString;
}

RCT_CUSTOM_VIEW_PROPERTY(type, NSInteger, RCTCamera) {
  NSInteger type = [RCTConvert NSInteger:json];

  view.presetCamera = type;
  // TODO: Should me moved in a method in RCTCamera once we find out what the code does.
  if (view.session.isRunning) {
    dispatch_async(view.sessionQueue, ^{
      AVCaptureDevice *currentCaptureDevice = [view.videoCaptureDeviceInput device];
      AVCaptureDevicePosition position = (AVCaptureDevicePosition)type;
      AVCaptureDevice *captureDevice = [view deviceWithMediaType:AVMediaTypeVideo preferringPosition:(AVCaptureDevicePosition)position];

      if (captureDevice == nil) {
        return;
      }

      view.presetCamera = type;

      NSError *error = nil;
      AVCaptureDeviceInput *captureDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];

      if (error || captureDeviceInput == nil)
      {
        NSLog(@"%@", error);
        return;
      }

      [view.session beginConfiguration];

      [view.session removeInput:view.videoCaptureDeviceInput];

      if ([view.session canAddInput:captureDeviceInput])
      {
        [view.session addInput:captureDeviceInput];

        [NSNotificationCenter.defaultCenter removeObserver:view name:AVCaptureDeviceSubjectAreaDidChangeNotification object:currentCaptureDevice];

        [NSNotificationCenter.defaultCenter addObserver:view selector:@selector(subjectAreaDidChange) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:captureDevice];
        view.videoCaptureDeviceInput = captureDeviceInput;
        [view setFlashMode];
      }
      else
      {
        [view.session addInput:view.videoCaptureDeviceInput];
      }

      [view.session commitConfiguration];
    });
  }
  [view initializeCaptureSessionInput:AVMediaTypeVideo];
}

RCT_CUSTOM_VIEW_PROPERTY(flashMode, NSInteger, RCTCamera) {
    view.flashMode = [RCTConvert NSInteger:json];
    [view setFlashMode];
}

RCT_CUSTOM_VIEW_PROPERTY(torchMode, NSInteger, RCTCamera) {
  dispatch_async(view.sessionQueue, ^{
    NSInteger torchMode = [RCTConvert NSInteger:json];
    AVCaptureDevice *device = [view.videoCaptureDeviceInput device];
    NSError *error = nil;

    if (![device hasTorch]) return;
    if (![device lockForConfiguration:&error]) {
      NSLog(@"%@", error);
      return;
    }
    [device setTorchMode: torchMode];
    [device unlockForConfiguration];
  });
}

RCT_CUSTOM_VIEW_PROPERTY(keepAwake, BOOL, RCTCamera) {
  BOOL enabled = [RCTConvert BOOL:json];
  [UIApplication sharedApplication].idleTimerDisabled = enabled;
}

RCT_CUSTOM_VIEW_PROPERTY(mirrorImage, BOOL, RCTCamera) {
  view.mirrorImage = [RCTConvert BOOL:json];
}

RCT_CUSTOM_VIEW_PROPERTY(barCodeTypes, NSArray, RCTCamera) {
  view.barCodeTypes = [RCTConvert NSArray:json];
}

RCT_CUSTOM_VIEW_PROPERTY(captureAudio, BOOL, RCTCamera) {
  BOOL captureAudio = [RCTConvert BOOL:json];
  if (captureAudio) {
    RCTLog(@"capturing audio");
    [view initializeCaptureSessionInput:AVMediaTypeAudio];
  }
}

- (NSArray *)customDirectEventTypes
{
    return @[
      @"focusChanged",
      @"zoomChanged",
    ];
}

RCT_EXPORT_METHOD(checkDeviceAuthorizationStatus:(RCTPromiseResolveBlock)resolve
                  reject:(__unused RCTPromiseRejectBlock)reject) {
  __block NSString *mediaType = AVMediaTypeVideo;

  [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
    if (!granted) {
      resolve(@(granted));
    }
    else {
      mediaType = AVMediaTypeAudio;
      [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
        resolve(@(granted));
      }];
    }
  }];
}


RCT_EXPORT_METHOD(checkVideoAuthorizationStatus:(RCTPromiseResolveBlock)resolve
                  reject:(__unused RCTPromiseRejectBlock)reject) {
    __block NSString *mediaType = AVMediaTypeVideo;

    [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
        resolve(@(granted));
    }];
}

RCT_EXPORT_METHOD(checkAudioAuthorizationStatus:(RCTPromiseResolveBlock)resolve
                  reject:(__unused RCTPromiseRejectBlock)reject) {
    __block NSString *mediaType = AVMediaTypeAudio;

    [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
        resolve(@(granted));
    }];
}

RCT_EXPORT_METHOD(changeOrientation:(nonnull NSNumber *)reactTag orientation:(NSInteger)orientation) {
    [self.bridge.uiManager addUIBlock:^(__unused RCTUIManager *uiManager, NSDictionary<NSNumber *, RCTCamera *> *viewRegistry) {
        RCTCamera *view = viewRegistry[reactTag];
        if (![view isKindOfClass:[RCTCamera class]]) {
            RCTLogError(@"Invalid view returned from registry, expecting RCTCamera, got: %@", view);
        } else {
            [view setOrientation:orientation];
        }
    }];
}

RCT_EXPORT_METHOD(capture:(nonnull NSNumber *)reactTag
                  options:(NSDictionary *)options
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    [self.bridge.uiManager addUIBlock:^(__unused RCTUIManager *uiManager, NSDictionary<NSNumber *, RCTCamera *> *viewRegistry) {
        RCTCamera *view = viewRegistry[reactTag];
        if (![view isKindOfClass:[RCTCamera class]]) {
            RCTLogError(@"Invalid view returned from registry, expecting RCTCamera, got: %@", view);
        } else {
            NSInteger captureMode = [[options valueForKey:@"mode"] intValue];
            NSInteger captureTarget = [[options valueForKey:@"target"] intValue];
            
            if (captureMode == RCTCameraCaptureModeStill) {
                [view captureStill:captureTarget options:options resolve:resolve reject:reject];
            }
            else if (captureMode == RCTCameraCaptureModeVideo) {
                [view captureVideo:captureTarget options:options resolve:resolve reject:reject];
            }
        }
    }];
}

RCT_EXPORT_METHOD(stopCapture:(nonnull NSNumber *)reactTag) {
    [self.bridge.uiManager addUIBlock:^(__unused RCTUIManager *uiManager, NSDictionary<NSNumber *, RCTCamera *> *viewRegistry) {
        RCTCamera *view = viewRegistry[reactTag];
        if (![view isKindOfClass:[RCTCamera class]]) {
            RCTLogError(@"Invalid view returned from registry, expecting RCTCamera, got: %@", view);
        } else {
            if (view.movieFileOutput.recording) {
                [view.movieFileOutput stopRecording];
            }
        }
    }];
}

RCT_EXPORT_METHOD(getFOV:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
  NSArray *devices = [AVCaptureDevice devices];
  AVCaptureDevice *frontCamera;
  AVCaptureDevice *backCamera;
  double frontFov = 0.0;
  double backFov = 0.0;

  for (AVCaptureDevice *device in devices) {

      NSLog(@"Device name: %@", [device localizedName]);

      if ([device hasMediaType:AVMediaTypeVideo]) {

          if ([device position] == AVCaptureDevicePositionBack) {
              NSLog(@"Device position : back");
              backCamera = device;
              backFov = backCamera.activeFormat.videoFieldOfView;
          }
          else {
              NSLog(@"Device position : front");
              frontCamera = device;
              frontFov = frontCamera.activeFormat.videoFieldOfView;
          }
      }
  }

  resolve(@{
    [NSNumber numberWithInt:RCTCameraTypeBack]: [NSNumber numberWithDouble: backFov],
    [NSNumber numberWithInt:RCTCameraTypeFront]: [NSNumber numberWithDouble: frontFov]
  });
}

RCT_EXPORT_METHOD(hasFlash:(nonnull NSNumber *)reactTag resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
    [self.bridge.uiManager addUIBlock:^(__unused RCTUIManager *uiManager, NSDictionary<NSNumber *, RCTCamera *> *viewRegistry) {
        RCTCamera *view = viewRegistry[reactTag];
        if (![view isKindOfClass:[RCTCamera class]]) {
            RCTLogError(@"Invalid view returned from registry, expecting RCTCamera, got: %@", view);
        } else {
            AVCaptureDevice *device = [view.videoCaptureDeviceInput device];
            resolve(@(device.hasFlash));
        }
    }];
}

@end
