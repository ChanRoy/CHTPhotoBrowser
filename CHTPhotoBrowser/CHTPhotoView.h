//
//  CHTPhotoView.h
//  CHTPhotoViewDemo
//
//  Created by cht on 17/2/7.
//  Copyright © 2017年 Roy Chan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CHTPhotoView;

@protocol CHTPhotoViewDelegate <NSObject>

- (void)photoViewDidOnceTap:(CHTPhotoView *)photoView;

@end

@interface CHTPhotoView : UIScrollView

@property (nonatomic, weak) id<CHTPhotoViewDelegate> photoViewDelegate;

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, assign) BOOL isShowLoadingView;

- (instancetype)initWithFrame:(CGRect)frame NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE; 

//set image from net
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage;


@end
