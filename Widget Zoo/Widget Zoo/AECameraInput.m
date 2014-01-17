//
//  AECameraInput.m
//  Custom Controls
//
//  Created by Drew on 10/11/13.
//  Copyright (c) 2013 Atoms-Express. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "AECameraInput.h"
#import "UIColor+Utilities.h"

@interface AECameraInput ()

@property (nonatomic, strong) CALayer *blueMeterLayer;
@property (nonatomic, strong) CALayer *greenMeterLayer;
@property (nonatomic, strong) UIImageView *cameraView;
@property (nonatomic, strong) UIImage *cameraOnImage;
@property (nonatomic, strong) UIImage *cameraOffImage;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureConnection *connection;
@property (nonatomic, strong) AVCaptureStillImageOutput *imageOutput;
@property (nonatomic, strong) NSArray *captureDevices;
@property (nonatomic, assign) AVCaptureDevicePosition position;
@property (nonatomic, strong) AVCaptureDeviceInput *backCameraInput;
@property (nonatomic, strong) AVCaptureDeviceInput *frontCameraInput;
@property (nonatomic, assign) BOOL imageTaken;
@property (nonatomic, strong) UIButton *changeCameraButton;

@end

const CGFloat kMinX = 5;
const CGFloat kSpan = 62;
const CGFloat kThresholdX = 50;

@implementation AECameraInput

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.editable = YES;
        self.clipsToBounds = NO;
        self.controlID = AEControlIDCameraInput;
        
        // Image Output
        self.imageOutput = [[AVCaptureStillImageOutput alloc] init];
        
        // Capture Session
        self.session = [[AVCaptureSession alloc] init];
        [self.session addOutput:self.imageOutput];
        
        self.cameraView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 2, self.bounds.size.width, self.bounds.size.height)];
        
        // Camera Input
        self.captureDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
        if ([self.captureDevices count] > 0) {
            for (AVCaptureDevice *device in self.captureDevices) {
                if (device.position == AVCaptureDevicePositionFront) {
                    self.frontCameraInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
                } else if (device.position == AVCaptureDevicePositionBack) {
                    self.backCameraInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
                }
            }
            if (self.frontCameraInput) {
                [self.session addInput:self.frontCameraInput];
                self.position = AVCaptureDevicePositionFront;
                self.cameraOnImage = [[AEControlTheme currentTheme] cameraFrontActive];
                self.cameraOffImage = [[AEControlTheme currentTheme] cameraFrontInactive];
                self.cameraView.image = self.cameraOffImage;
            }
            else if (self.backCameraInput) {
                [self.session addInput:self.backCameraInput];
                self.position = AVCaptureDevicePositionBack;
                self.cameraOnImage = [[AEControlTheme currentTheme] cameraRearActive];
                self.cameraOffImage = [[AEControlTheme currentTheme] cameraRearInactive];
                self.cameraView.image = self.cameraOffImage;
            }
        }
        
        // Base
        UIImageView *baseImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        baseImageView.image = [[AEControlTheme currentTheme] cameraBase];
        [self addSubview:baseImageView];
        
        // Preview layer
        AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
        self.connection = previewLayer.connection;
        self.connection.videoOrientation = AVCaptureVideoOrientationLandscapeLeft;
        
        [self.session startRunning];
        
        self.controlType = AEControlTypeInput;
        
        UIView *previewView = [[UIView alloc] initWithFrame:CGRectMake(1, 1, self.bounds.size.width - 3, self.bounds.size.height - 3)];
//        CGRectMake(1, 1, 102, 55)
        previewView.exclusiveTouch = NO;
        previewLayer.frame = previewView.bounds;
        previewLayer.cornerRadius = 5;
        [previewView.layer addSublayer:previewLayer];
        [self addSubview:previewView];
        
        CALayer *aLayer = [CALayer layer];
        [aLayer setFrame:CGRectMake(4, 43, 64, 9)];
        [aLayer setBackgroundColor:[[UIColor colorWithHexString:@"2a2a2a"] CGColor]];
        [aLayer setBorderWidth:1.0f];
        [aLayer setBorderColor:[[UIColor colorWithHexString:@"dbe3e7"] CGColor]];
        [previewLayer addSublayer:aLayer];
        
        self.blueMeterLayer = aLayer;
        
        UIColor *blue = [UIColor colorWithHexString:@"00a0d2"];
        self.blueMeterLayer = [CALayer layer];
        [self.blueMeterLayer setFrame:CGRectMake(kMinX, 44, 1, 7)];
        [self.blueMeterLayer setBackgroundColor:[blue CGColor]];
        [previewLayer addSublayer:self.blueMeterLayer];
        
        UIColor *green = [UIColor colorWithHexString:@"5fc33c"];
        CALayer *greenLayer = [CALayer layer];
        [greenLayer setBackgroundColor:[green CGColor]];
        [greenLayer setFrame:CGRectMake(kThresholdX, 44, 2, 7)];
        [previewLayer addSublayer:greenLayer];
        self.greenMeterLayer = greenLayer;
        
        [self addSubview:self.cameraView];
        
//        UIView *touchView = [[UIView alloc] initWithFrame:self.bounds];
//        [touchView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(controlTapped:)]];
//        [self addSubview:touchView];
        
        _changeCameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_changeCameraButton setFrame:CGRectMake(5, 50, 60, 60)];
        [_changeCameraButton setImage:[UIImage imageNamed:@"original.jpg"] forState:UIControlStateNormal];
        //[_changeCameraButton setBackgroundColor:[UIColor greenColor]];
        [_changeCameraButton addTarget:self
                                action:@selector(changeCameraPressed:)
                      forControlEvents:UIControlEventTouchUpInside];
        [self.configView addSubview:_changeCameraButton];
        
        [self bringSubviewToFront:self.editButton];
    }
    return self;
}

- (void)changeCameraPressed:(id)sender
{
    if (self.enabled) {
        if ([self.captureDevices count] > 1) {
            if (self.position == AVCaptureDevicePositionBack) {
                self.cameraOnImage = [[AEControlTheme currentTheme] cameraFrontActive];
                self.cameraOffImage = [[AEControlTheme currentTheme] cameraFrontInactive];
                [self.session removeInput:self.backCameraInput];
                [self.session addInput:self.frontCameraInput];
                self.position = AVCaptureDevicePositionFront;
            } else {
                self.cameraOnImage = [[AEControlTheme currentTheme] cameraRearActive];
                self.cameraOffImage = [[AEControlTheme currentTheme] cameraRearInactive];
                [self.session removeInput:self.frontCameraInput];
                [self.session addInput:self.backCameraInput];
                self.position = AVCaptureDevicePositionBack;
            }
        }
        [self.cameraView setImage:self.cameraOffImage];
    }
}

- (void)takePicture {
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in self.imageOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) {
            [self.imageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
                if (error) {
                    NSLog(@"ERROR taking picture: %@", [error localizedDescription]);
                }
                else {
                    NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
                    UIImage *image = [[UIImage alloc] initWithData:imageData];
                     ;
                    if (self.position == AVCaptureDevicePositionFront) {
                        UIImageWriteToSavedPhotosAlbum([UIImage imageWithCGImage:image.CGImage scale:image.scale orientation:UIImageOrientationUp], nil, nil, nil);
                    } else {
                        UIImageWriteToSavedPhotosAlbum([UIImage imageWithCGImage:image.CGImage scale:image.scale orientation:UIImageOrientationDown], nil, nil, nil);
                    }
                }
            }];
        }
    }
}



- (void)setAtomValue:(UInt16)atomValue
{
    CGFloat x = ((CGFloat)atomValue / UINT16_MAX) * kSpan + kMinX;
    CGFloat width = ((CGFloat)atomValue / UINT16_MAX) * kSpan;
    [self.blueMeterLayer setFrame:CGRectMake(kMinX, 44, width, 7)];
    if (x >= kThresholdX) {
        [self.greenMeterLayer setFrame:CGRectMake(kThresholdX, 44, fmaxf(2, width - kThresholdX + kMinX), 7)];
        self.cameraView.image = self.cameraOnImage;
        if (!self.imageTaken) {
            [self takePicture];
            self.imageTaken = YES;
        }
    } else {
        [self.greenMeterLayer setFrame:CGRectMake(kThresholdX, 44, 2, 7)];
        self.cameraView.image = self.cameraOffImage;
        self.imageTaken = NO;
    }
}

#pragma mark - Editing

- (void)setControlEditMode:(BOOL)editing {
    [super setControlEditMode:editing];
    NSLog(@"edit frame: %@", [NSValue valueWithCGRect:self.editButton.frame]);
}

- (void)expandControlWithCompletion:(void (^)(void))completion {
    [super expandControlWithCompletion:^{
        self.configView.frame = CGRectMake(0, 0, self.configView.frame.size.width, self.configView.frame.size.height);
        [self bringSubviewToFront:self.changeCameraButton];
        NSLog(@"edit frame 2: %@", [NSValue valueWithCGRect:self.editButton.frame]);
    }];
}

- (void)shrinkControlWithCompletion:(void (^)(void))completion {
    [super shrinkControlWithCompletion:^{
        
    }];
}

@end
