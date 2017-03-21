//
//  CHTPhotoBrowser.h
//  CHTPhotoBrowserDemo
//
//  Created by cht on 2017/3/20.
//  Copyright © 2017年 cht. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CHTPhotoBrowser;

@protocol CHTPhotoBrowserDelegate <NSObject>

@optional
- (void)photoBrowser:(CHTPhotoBrowser *)photoBrowser didSelectItemAtIndex:(NSInteger)index;

- (void)photoBrowser:(CHTPhotoBrowser *)photoBrowser didScrollToIndex:(NSInteger)index;

@end

@interface CHTPhotoBrowser : UIView

@property (nonatomic, assign, getter=isShowPageControl) BOOL showPageControl;

@property (nonatomic, weak) id <CHTPhotoBrowserDelegate> delegate;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

- (instancetype)initWithFrame:(CGRect)frame imageUrls:(NSArray <NSString *>*)imageUrls placeholderImage:(UIImage *)placeholderImage;

- (instancetype)initWithFrame:(CGRect)frame images:(NSArray <UIImage *>*)images;

@end
