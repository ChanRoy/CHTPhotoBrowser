//
//  CHTPhotoBrowser.h
//  CHTPhotoBrowserDemo
//
//  Created by cht on 2017/3/20.
//  Copyright © 2017年 cht. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHTPhotoBrowser : UIView

@property (nonatomic, assign, getter=isShowPageControl) BOOL showPageControl;

@property (nonatomic, strong) NSArray *imageUrls;

@property (nonatomic, strong) NSArray *images;

@property (nonatomic, strong) UIImage *placeholderImage;

- (instancetype)initWithFrame:(CGRect)frame imageUrls:(NSArray *)imageUrls placeholderImage:(UIImage *)placeholderImage;

@end
