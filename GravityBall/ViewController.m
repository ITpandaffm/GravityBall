//
//  ViewController.m
//  GravityBall
//
//  Created by ffm on 16/11/15.
//  Copyright © 2016年 ITPanda. All rights reserved.
//

#import "ViewController.h"
#import <CoreMotion/CoreMotion.h>

#define CURRENT_X self.ballPicView.frame.origin.x
#define CURRENT_Y self.ballPicView.frame.origin.y
#define WIDTH self.ballPicView.frame.size.width
#define HEIGHT self.ballPicView.frame.size.height
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define TRANSFORM self.ballPicView.transform


@interface ViewController ()

@property (nonatomic, strong) CMMotionManager *motionManager;

@property (nonatomic, strong) UIImageView *ballPicView;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation ViewController
{
    int beginSpeedX;
    int beginSpeedY;
    double acclerateX;
    double acclerateY;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    beginSpeedX = beginSpeedY = 3.0;
    self.view.backgroundColor = [UIColor yellowColor];
    [self ballPicView];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 repeats:YES block:^(NSTimer * _Nonnull timer) {
        
//        //边界判断问题
        if ((CURRENT_X >= SCREEN_WIDTH-WIDTH) || CURRENT_X <= 0)
        {
            beginSpeedX = -beginSpeedX;
        } else if ((CURRENT_Y >= SCREEN_HEIGHT-HEIGHT) || CURRENT_Y <= 0)
        {
            beginSpeedY = -beginSpeedY;
        }
        self.ballPicView.transform = CGAffineTransformTranslate(self.ballPicView.transform, beginSpeedX+0.1*acclerateX, beginSpeedY+0.1*acclerateY);
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.motionManager.accelerometerUpdateInterval = 1;
    if (self.motionManager.accelerometerAvailable)
    {
        [self.motionManager startAccelerometerUpdatesToQueue:[[NSOperationQueue alloc] init] withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
            
            CMAcceleration acceleration = accelerometerData.acceleration;
             acclerateX = acceleration.x;
             acclerateY = acceleration.y;
        }];
    } else
    {
        NSLog(@"加速度传感器不可用!");
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (self.motionManager.accelerometerActive)
    {
        [self.motionManager stopAccelerometerUpdates];
    }
}

- (IBAction)resetBallLocation:(id)sender
{
    self.ballPicView.frame = CGRectMake(200, 200, 44, 44);
}


#pragma mark 懒加载
- (CMMotionManager *)motionManager
{
    if (!_motionManager)
    {
        _motionManager = [[CMMotionManager alloc] init];
    }
    return _motionManager;
}

- (UIImageView *)ballPicView
{
    if (!_ballPicView)
    {
        _ballPicView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"potato"]];
        _ballPicView.frame = CGRectMake(200, 200, 44, 44);
        [self.view addSubview:_ballPicView];
    }
    return _ballPicView;
}


@end
