//
//  CHTRingLoadingView.h
//  CHTGithub
//
//  Created by cht on 17/1/12.
//  Copyright © 2017年 cht. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 图片加载提示动画
 */
@interface CHTRingLoadingView : UIControl

/**
 背景圆环颜色
 */
@property (nonatomic, strong) UIColor *bgRingColor;

/**
 旋转的圆弧颜色
 */
@property (nonatomic, strong) UIColor *trackColor;

/**
 旋转一圈的时间，控制旋转速度.default is 1 sec.
 */
@property (nonatomic, assign) CGFloat animationDuration;

/**
 只读属性，是否正在执行动画。
 */
@property (nonatomic, assign, readonly) BOOL isAnimating;

/**
 模仿系统控件UIActivityIndicatorView，当动画停止时隐藏。默认为YES
 */
@property (nonatomic, assign) BOOL hidesWhenStopped;

- (instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;

/**
 初始化方法

 @return 实例
 */
- (instancetype)initWithFrame:(CGRect)frame NS_DESIGNATED_INITIALIZER;
- (instancetype)init;

/**
 开始旋转动画
 */
- (void)startLoading;

/**
 停止旋转动画
 */
- (void)stopLoading;

@end
