//
//  CHTPhotoView.m
//  CHTPhotoViewDemo
//
//  Created by cht on 17/2/7.
//  Copyright © 2017年 Roy Chan. All rights reserved.
//

#import "CHTPhotoView.h"
#import "UIImageView+WebCache.h"
#import "CHTRingLoadingView.h"

@interface CHTPhotoView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UITapGestureRecognizer *doubleTap;
@property (nonatomic, strong) CHTRingLoadingView *loadingView;

@end

@implementation CHTPhotoView

- (void)dealloc{
    
    if (!_image) {
        
        [_imageView sd_cancelCurrentImageLoad];
    }
}

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initialize];
  
    }
    return self;
}

- (void)initialize{
    
    self.clipsToBounds = YES;
    _isShowLoadingView = YES;
    
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.center = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2);
    [self addSubview:_imageView];
    
    self.backgroundColor = [UIColor blackColor];
    self.delegate = self;
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    
    self.decelerationRate = UIScrollViewDecelerationRateFast;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    UITapGestureRecognizer *onceTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleOnceTap:)];
    onceTap.delaysTouchesBegan = YES;
    onceTap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:onceTap];
    
    _doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleDoubleTap:)];
    _doubleTap.numberOfTapsRequired = 2;
    [self addGestureRecognizer:_doubleTap];
    
    //onceTap is not enable when _doubleTap is responsed
    [onceTap requireGestureRecognizerToFail:_doubleTap];
}

- (void)setupLoadingView{
    
    _loadingView = [[CHTRingLoadingView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    _loadingView.center = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2);
    [self addSubview:_loadingView];
    [self bringSubviewToFront:_loadingView];
}

- (void)adjustFrame{
    
    if (_imageView.image == nil) {
        return;
    }
    
    CGSize boundsSize = self.bounds.size;
    CGFloat boundsWidth = boundsSize.width;
    CGFloat boundsHeight = boundsSize.height;
    
    CGSize imageSize = _imageView.image.size;
    CGFloat imageWidth = imageSize.width;
    CGFloat imageHeight = imageSize.height;
    
    CGFloat minScale = boundsWidth / imageWidth;
    if (minScale > 1.0) {
        minScale = 1.0;
    }
    CGFloat maxScale = 2.0;
    
    self.maximumZoomScale = maxScale;
    self.minimumZoomScale = minScale;
    self.zoomScale = minScale;
    
    CGRect imageFrame = CGRectMake(0, 0, boundsWidth, imageHeight * boundsWidth / imageWidth);
    self.contentSize = CGSizeMake(boundsWidth, imageFrame.size.height);
    
    if (imageFrame.size.height < boundsHeight) {
        
        imageFrame.origin.y = (boundsHeight - imageFrame.size.height)/2.0;
    }else{
        
        imageFrame.origin.y = 0;
    }
    
    _imageView.frame = imageFrame;
    _doubleTap.enabled = YES;
    
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage{
    
    _doubleTap.enabled = NO;
    
    if (!_loadingView && _isShowLoadingView) {
        
        [self setupLoadingView];
    }else{
        
        [self bringSubviewToFront:_loadingView];
    }
    
    __weak typeof(self) weakSelf = self;
    
    [_imageView sd_setImageWithURL:url placeholderImage:placeholderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if (error) {
            
            NSLog(@"****%@",error.description);
            strongSelf.image = placeholderImage;
            return;
        }
        strongSelf.image = image;
        
    }];
}

#pragma mark - set method
- (void)setImage:(UIImage *)image{
    
    _image = image;
    _imageView.image = image;
    _loadingView.hidden = YES;
    [self adjustFrame];
}

#pragma mark - Gesture
- (void)handleOnceTap:(UITapGestureRecognizer *)onceTap{
    
    if (_photoViewDelegate && [_photoViewDelegate respondsToSelector:@selector(photoViewDidOnceTap:)]) {
        
        [_photoViewDelegate photoViewDidOnceTap:self];
    }

}

- (void)handleDoubleTap:(UITapGestureRecognizer *)doubleTap{
    
    CGPoint tapPoint = [doubleTap locationInView:_imageView];
    if (self.zoomScale == self.maximumZoomScale) {
    
        [self setZoomScale:self.minimumZoomScale animated:YES];
    }else{
    
        [self zoomToRect:CGRectMake(tapPoint.x, tapPoint.y, self.maximumZoomScale, self.maximumZoomScale) animated:YES];
    }
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    return _imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    
    CGRect imageViewFrame = _imageView.frame;
    CGRect bounds = self.bounds;
    if (imageViewFrame.size.height > bounds.size.height) {
        
        imageViewFrame.origin.y = 0.0f;
    }else{
        
        imageViewFrame.origin.y = (bounds.size.height - imageViewFrame.size.height)/2.0f;
    }
    _imageView.frame = imageViewFrame;
}

@end
