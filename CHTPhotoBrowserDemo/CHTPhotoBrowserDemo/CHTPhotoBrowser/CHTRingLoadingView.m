//
//  CHTRingLoadingView.m
//  CHTGithub
//
//  Created by cht on 17/1/12.
//  Copyright © 2017年 cht. All rights reserved.
//

#import "CHTRingLoadingView.h"

//默认属性值
static NSString *const kAnimationKey = @"CHTRotateAnimationKey";
static const CGFloat kDefaultRadius = 20.0f;
static const CGFloat kDefaultRingWidth = 4.0f;
static const CGFloat kDefaultAnimationDuration = 1.0f;
static const CGFloat kDefaultTrackPercent = 0.3f;

@interface CHTRingLoadingView ()

/**
 圆环半径。default is 20.
 */
@property (nonatomic, assign) CGFloat radius;

/**
 背景圆环layer
 */
@property (nonatomic, strong) CAShapeLayer *bgRingLayer;

/**
 旋转圆弧layer
 */
@property (nonatomic, strong) CAShapeLayer *trackLayer;

/**
 圆环宽度。default is 4.
 */
@property (nonatomic, assign) CGFloat ringWidth;

/**
 旋转圆弧的弧长所占圆周的比例。default is 0.3 .
 */
@property (nonatomic, assign) CGFloat trackPercent;

@end

@implementation CHTRingLoadingView

- (instancetype)init
{
    return [self initWithFrame:CGRectMake(0, 0, kDefaultRadius*2, kDefaultRadius*2)];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    CGFloat x = (CGRectGetMaxX(frame) - CGRectGetMinX(frame) - kDefaultRadius) / 2;
    CGFloat y = (CGRectGetMinY(frame) - CGRectGetMinY(frame) - kDefaultRadius) / 2;
    self = [super initWithFrame:CGRectMake(x, y, kDefaultRadius*2, kDefaultRadius*2)];
    if (self) {
        
        [self initialize];
        
        [self setupBgRing];
        
        [self setupTrackLayer];
    }
    return self;
}

//初始化参数设置
- (void)initialize{
    
    _radius = kDefaultRadius;
    _bgRingColor = [UIColor colorWithRed:60/ 255.0 green:60/ 255.0 blue:60/ 255.0 alpha:1];
    _trackColor = [UIColor whiteColor];
    _ringWidth = kDefaultRingWidth;
    _animationDuration = kDefaultAnimationDuration;
    _trackPercent = kDefaultTrackPercent;
    _hidesWhenStopped = YES;
}

//背景圆环
- (void)setupBgRing{
    
    _bgRingLayer = [CAShapeLayer new];
    _bgRingLayer.frame = self.bounds;
    _bgRingLayer.lineWidth = _ringWidth;
    _bgRingLayer.strokeColor = _bgRingColor.CGColor;
    _bgRingLayer.fillColor = nil;
    _bgRingLayer.lineCap = kCALineCapRound;
    
    CGPoint center = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2);
    UIBezierPath *bgPath = [UIBezierPath bezierPathWithArcCenter:center radius:_radius-_ringWidth/2 startAngle:-0.5f * M_PI endAngle:1.5f * M_PI clockwise:YES];
    _bgRingLayer.path = [bgPath CGPath];
    
    [self.layer addSublayer:_bgRingLayer];
}

//旋转的圆弧
- (void)setupTrackLayer{
    
    _trackLayer = [CAShapeLayer new];
    _trackLayer.frame = self.bounds;
    _trackLayer.lineWidth = _ringWidth;
    _trackLayer.strokeColor = _trackColor.CGColor;
    _trackLayer.fillColor = nil;
    _trackLayer.lineCap = kCALineCapRound;
    
    CGPoint center = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2);
    UIBezierPath *trackPath = [UIBezierPath bezierPathWithArcCenter:center radius:_radius-_ringWidth/2 startAngle:-0.5f * M_PI endAngle:(-0.5+2*_trackPercent) * M_PI clockwise:YES];
    _trackLayer.path = [trackPath CGPath];
    
    [self.layer addSublayer:_trackLayer];
    
    [self startLoading];
}

//animation
- (void)startLoading{
    
    if (_isAnimating == YES) {
        return;
    }
    self.hidden = NO;
    
    CABasicAnimation *ani = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    ani.fromValue = @(0.0f);
    ani.toValue = @(2*M_PI);
    ani.duration = _animationDuration;
    ani.repeatCount = HUGE_VALF;
    [_trackLayer addAnimation:ani forKey:kAnimationKey];
    
    _isAnimating = YES;
}

- (void)stopLoading{
    
    [_trackLayer removeAnimationForKey:kAnimationKey];
    self.hidden = _hidesWhenStopped;
    _isAnimating = NO;
}

- (void)restartAnimation{
    
    self.hidden = NO;
    
    [_trackLayer removeAnimationForKey:kAnimationKey];
    
    CABasicAnimation *ani = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    ani.fromValue = @(0.0f);
    ani.toValue = @(2*M_PI);
    ani.duration = _animationDuration;
    ani.repeatCount = HUGE_VALF;
    [_trackLayer addAnimation:ani forKey:kAnimationKey];
    
    _isAnimating = YES;
}

#pragma mark - setters
- (void)setBgRingColor:(UIColor *)bgRingColor{
    
    _bgRingColor = bgRingColor;
    _bgRingLayer.strokeColor = _bgRingColor.CGColor;
}

- (void)setTrackColor:(UIColor *)trackColor{
    
    _trackColor = trackColor;
    _trackLayer.strokeColor = _trackColor.CGColor;
}

- (void)setAnimationDuration:(CGFloat)animationDuration{
    
    if (_animationDuration == animationDuration) {
        return;
    }
    _animationDuration = animationDuration;
    [self restartAnimation];
}

- (void)setHidesWhenStopped:(BOOL)hidesWhenStopped{
    
    if (_hidesWhenStopped == hidesWhenStopped) {
        return;
    }
    @synchronized (self) {
        _hidesWhenStopped = hidesWhenStopped;
    }
}

@end
