//
//  CHTPhotoBrowser.m
//  CHTPhotoBrowserDemo
//
//  Created by cht on 2017/3/20.
//  Copyright © 2017年 cht. All rights reserved.
//

#import "CHTPhotoBrowser.h"
#import "CHTPhotoView.h"

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

#define START_TAG 100

@interface CHTPhotoBrowser ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) CHTPhotoView *tempPhotoView;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) NSMutableArray *photoViewArr;

@property (nonatomic, assign) NSInteger imageCount;


@end

@implementation CHTPhotoBrowser

- (instancetype)initWithFrame:(CGRect)frame imageUrls:(NSArray *)imageUrls placeholderImage:(UIImage *)placeholderImage{
    
    if (self = [super initWithFrame:frame]) {
        
        _imageUrls = imageUrls;
        
        [self initialize];
        
        [self setupScrollView];
    }
    return self;
}

- (void)initialize{
    
    _imageCount = _imageUrls.count;
}

- (void)setupScrollView{
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    _scrollView.delegate = self;
    [self addSubview:_scrollView];
    
    _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_scrollView.frame)*3, CGRectGetHeight(_scrollView.frame))];
    _contentView.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:_contentView];
    
    _photoViewArr = [NSMutableArray new];
    
    //setup three photoViews in the _scrollView
    for (NSInteger i = 0; i < 3; i ++) {
        
        CHTPhotoView *photoView = [[CHTPhotoView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        photoView.delegate = self;
        
        NSInteger index = 0;
        if (i == 0) index = _imageCount - 1;
        if (i == 1) index = 0;
        if (i == 2) index = _imageCount == 1 ? 0 : 1;
        
        photoView.tag = index + START_TAG;

        
        [self setImageForPhotoView:photoView atIndex:index];
        [_photoViewArr addObject:photoView];
        [_contentView addSubview:photoView];
        
        if (_tempView) {
            leftConstraint = [NSLayoutConstraint constraintWithItem:imageView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_tempView
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1
                                                           constant:0];
        }else{
            leftConstraint = [NSLayoutConstraint constraintWithItem:imageView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_contentView attribute:NSLayoutAttributeLeft
                                                         multiplier:1
                                                           constant:0];
        }
        
        [_contentView addConstraints:@[
                                       leftConstraint,
                                       [NSLayoutConstraint constraintWithItem:imageView
                                                                    attribute:NSLayoutAttributeWidth
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:_contentView
                                                                    attribute:NSLayoutAttributeWidth
                                                                   multiplier:1.0 / 3.0
                                                                     constant:0],
                                       [NSLayoutConstraint constraintWithItem:imageView
                                                                    attribute:NSLayoutAttributeTop
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:_contentView
                                                                    attribute:NSLayoutAttributeTop
                                                                   multiplier:1
                                                                     constant:0],
                                       [NSLayoutConstraint constraintWithItem:imageView
                                                                    attribute:NSLayoutAttributeHeight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:_contentView
                                                                    attribute:NSLayoutAttributeHeight
                                                                   multiplier:1
                                                                     constant:0]
                                       ]];
        
        _tempView = imageView;
    }
    
    _scrollView.contentOffset = CGPointMake(CGRectGetWidth(_scrollView.frame), 0);
}

- (void)setImageForPhotoView:(CHTPhotoView *)photoView atIndex:(NSUInteger)index{
    
    NSURL *url = [NSURL URLWithString:_imageUrls[index]];
    [photoView setImageWithURL:url placeholderImage:_placeholderImage];

}

@end
