#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "CameraFocusSquare.h"

@class RCTCameraManager;

@interface RCTCamera : UIView<AVCaptureMetadataOutputObjectsDelegate, AVCaptureFileOutputRecordingDelegate>

@property (nonatomic, strong) dispatch_queue_t sessionQueue;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureDeviceInput *audioCaptureDeviceInput;
@property (nonatomic, strong) AVCaptureDeviceInput *videoCaptureDeviceInput;
@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;
@property (nonatomic, strong) AVCaptureMovieFileOutput *movieFileOutput;
@property (nonatomic, strong) AVCaptureMetadataOutput *metadataOutput;
@property (nonatomic, strong) id runtimeErrorHandlingObserver;
@property (nonatomic, assign) NSInteger presetCamera;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, assign) NSInteger videoTarget;
@property (nonatomic, assign) NSInteger orientation;
@property (nonatomic, assign) BOOL mirrorImage;
@property (nonatomic, strong) NSArray* barCodeTypes;
@property (nonatomic, strong) RCTPromiseResolveBlock videoResolve;
@property (nonatomic, strong) RCTPromiseRejectBlock videoReject;
@property (assign, nonatomic) NSInteger flashMode;

- (id)initWithBridge:(RCTBridge *)bridge props:(NSDictionary*)props;

- (void)setFlashMode;
- (void)setCaptureQuality:(NSString *)quality;

- (void)initializeCaptureSessionInput:(NSString *)type;

- (void)captureStill:(NSInteger)target options:(NSDictionary *)options resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject;
- (void)captureVideo:(NSInteger)target options:(NSDictionary *)options resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject;

- (AVCaptureDevice *)deviceWithMediaType:(NSString *)mediaType preferringPosition:(AVCaptureDevicePosition)position;

- (void)subjectAreaDidChange;

@end
