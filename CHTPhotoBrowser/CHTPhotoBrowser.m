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

typedef enum : NSUInteger {
    
    CHTImageTypeLocal   = 0,
    CHTImageTypeFromNet = 1,
} CHTImageType;

@interface CHTPhotoBrowser ()<UIScrollViewDelegate,CHTPhotoViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) NSArray *imageUrls;

@property (nonatomic, strong) NSArray *images;

@property (nonatomic, strong) UIImage *placeholderImage;

@property (nonatomic, strong) NSMutableArray <CHTPhotoView *>*photoViewArr;

@property (nonatomic, assign) NSInteger imageCount;

@property (nonatomic, assign) CHTImageType imageType;

@end

@implementation CHTPhotoBrowser{
    
    CGFloat _viewWidth;
    CGFloat _viewHeight;
    BOOL _showPageControl;
    BOOL _infiniteScroll;
}

#pragma mark - init method
- (instancetype)initWithFrame:(CGRect)frame imageUrls:(NSArray <NSString *>*)imageUrls placeholderImage:(UIImage *)placeholderImage{
    
    if (self = [super initWithFrame:frame]) {
        
        _imageUrls = imageUrls;
        _placeholderImage = placeholderImage;
        _imageType = CHTImageTypeFromNet;
        _imageCount = _imageUrls.count;
        
        [self initialize];
        
        [self setupScrollView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame images:(NSArray<UIImage *> *)images{
    
    if (self = [super initWithFrame:frame]) {
        
        _images = images;
        _imageType = CHTImageTypeLocal;
        _imageCount = _images.count;
        
        [self initialize];
        
        [self setupScrollView];
    }
    return self;
}

- (void)initialize{
    
    self.backgroundColor = [UIColor blackColor];
    _viewWidth = CGRectGetWidth(self.frame);
    _viewHeight = CGRectGetHeight(self.frame);
    _infiniteScroll = YES;
}

#pragma mark - getter
- (BOOL)isShowPageControl{
    
    return _showPageControl;
}

- (BOOL)isInfiniteScroll{
    
    return _infiniteScroll;
}

- (UIImage *)currentImage {
    
    NSInteger index = _scrollView.contentOffset.x / _scrollView.bounds.size.width;
    
    if (_photoViewArr.count > index) {
        
        CHTPhotoView *currentPhotoView = _photoViewArr[index];
        return currentPhotoView.image;
    }
    return nil;
}

#pragma mark - setter
- (void)setShowPageControl:(BOOL)showPageControl{
    
    _showPageControl = showPageControl;
    _pageControl.hidden = !_showPageControl;
}

- (void)setCurrentIndex:(NSInteger)currentIndex{
    
    _currentIndex = currentIndex;
    [self setupScrollView];
}

- (void)setInfiniteScroll:(BOOL)infiniteScroll{
    
    if (_infiniteScroll == infiniteScroll) {
        
        return;
    }
    _infiniteScroll = infiniteScroll;
    [self setupScrollView];
}

#pragma mark - UI

- (void)setupScrollView{
    
    if (_scrollView) [_scrollView removeFromSuperview];
    if (_pageControl) [_pageControl removeFromSuperview];
    
    if (!_infiniteScroll && _imageCount < 3) {
        
        [self setupScrollViewWithFewImages];
        return;
    }
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, _viewWidth, _viewHeight)];
    _scrollView.contentSize = CGSizeMake(_viewWidth * 3, 0);
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    [self addSubview:_scrollView];
    
    _photoViewArr = [NSMutableArray new];
    
    if (_imageCount == 0) return;
    
    //setup three photoViews in the _scrollView
    for (NSInteger i = 0; i < 3; i ++) {
        
        CHTPhotoView *photoView = [[CHTPhotoView alloc]initWithFrame:CGRectMake(_viewWidth*i, 0, _viewWidth, _viewHeight)];
        photoView.photoViewDelegate = self;
        
        NSInteger index = 0;
        if (!_infiniteScroll && _currentIndex == 0) {
            
            if (i == 0) index = 0;
            if (i == 1) index = 1;
            if (i == 2) index = 2;
        }
        else if (!_infiniteScroll && _currentIndex == _imageCount-1){
            
            if (i == 0) index = _imageCount-3;
            if (i == 1) index = _imageCount-2;
            if (i == 2) index = _imageCount-1;
        }
        else{
            
            if (i == 0) index = _currentIndex==0? _imageCount-1: _currentIndex-1;
            if (i == 1) index = _currentIndex;
            if (i == 2) index = _currentIndex+1 == _imageCount? 0: _currentIndex+1;
        }
        
        
        photoView.tag = index + START_TAG;

        
        [self setImageForPhotoView:photoView atIndex:index];
        [_photoViewArr addObject:photoView];
        [_scrollView addSubview:photoView];
        
    }
    
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, _viewHeight - 30, _viewWidth, 30)];
    _pageControl.numberOfPages = _imageCount;
    _pageControl.currentPage = _currentIndex;
    _pageControl.hidesForSinglePage = YES;
    [self addSubview:_pageControl];
    _pageControl.hidden = !_showPageControl;
    
    if (_imageCount == 1) {
        _scrollView.scrollEnabled = NO;
    }
    
    NSInteger flag = 1;
    if (!_infiniteScroll) {
        
        if (_currentIndex == 0) {
            
            flag = 0;
            _currentIndex = 1;
        }
        else if (_currentIndex == _imageCount-1) {
            
            flag = 2;
            _currentIndex = _imageCount-2;
        }
        else flag = 1;
    }
    
    _scrollView.contentOffset = CGPointMake(_viewWidth * flag, 0);
}

//count of images is less than 3 and is not infinite
- (void)setupScrollViewWithFewImages{
    
    if (_scrollView) [_scrollView removeFromSuperview];
    if (_pageControl) [_pageControl removeFromSuperview];
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, _viewWidth, _viewHeight)];
    _scrollView.contentSize = CGSizeMake(_viewWidth * _imageCount, 0);
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    [self addSubview:_scrollView];
    
    _photoViewArr = [NSMutableArray new];
    
    if (_imageCount == 0) return;
    
    //setup photoViews in the _scrollView
    for (NSInteger i = 0; i < _imageCount; i ++) {
        
        CHTPhotoView *photoView = [[CHTPhotoView alloc]initWithFrame:CGRectMake(_viewWidth*i, 0, _viewWidth, _viewHeight)];
        photoView.photoViewDelegate = self;
        [self setImageForPhotoView:photoView atIndex:i];
        [_scrollView addSubview:photoView];
        [_photoViewArr addObject:photoView];
    }
    
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, _viewHeight - 30, _viewWidth, 30)];
    _pageControl.numberOfPages = _imageCount;
    _pageControl.currentPage = _currentIndex;
    _pageControl.hidesForSinglePage = YES;
    [self addSubview:_pageControl];
    _pageControl.hidden = !_showPageControl;
    _scrollView.contentOffset = CGPointMake(_viewWidth * _currentIndex, 0);
}

//setup image for photoView
- (void)setImageForPhotoView:(CHTPhotoView *)photoView atIndex:(NSUInteger)index{
    
    if (_imageType == CHTImageTypeFromNet) {
        
        NSURL *url = [NSURL URLWithString:_imageUrls[index]];
        [photoView setImageWithURL:url placeholderImage:_placeholderImage];
    }else{
        
        photoView.image = _images[index];
    }
}

- (void)updateUI{
    
    if (_imageCount == 0) {
        return;
    }
    
    int flag = 0;
    //slide to right
    if (_scrollView.contentOffset.x > _viewWidth) {
        flag = 1;
    }
    //slide to left
    else if (_scrollView.contentOffset.x == 0){
        flag = -1;
    }
    //no moving
    else{
        
        if (!_infiniteScroll){
            
            _pageControl.currentPage = _currentIndex;
            if (_delegate && [_delegate respondsToSelector:@selector(photoBrowser:didScrollToIndex:)]) {
                
                [_delegate photoBrowser:self didScrollToIndex:_currentIndex];
            }
        }
        return;
    }
    if (!_infiniteScroll) {
        
        if (_currentIndex == 1 && flag == -1) {
            
            if (_pageControl.currentPage == 0) {
                return;
            }
            _pageControl.currentPage = 0;
            
            if (_delegate && [_delegate respondsToSelector:@selector(photoBrowser:didScrollToIndex:)]) {
                
                [_delegate photoBrowser:self didScrollToIndex:0];
            }
            return;
        }
        if (_currentIndex == _imageCount-2 && flag == 1) {
            
            if (_pageControl.currentPage == _imageCount-1) {
                
                return;
            }
            _pageControl.currentPage = _imageCount-1;
            
            if (_delegate && [_delegate respondsToSelector:@selector(photoBrowser:didScrollToIndex:)]) {
                
                [_delegate photoBrowser:self didScrollToIndex:_imageCount-1];
            }
            return;
        }
    }
    //infinite
    //change the image in imageViews
    for (CHTPhotoView *photoView in _photoViewArr) {
        
        NSInteger index = photoView.tag - START_TAG + flag;
        
        if (index < 0) {
            index = _imageCount - 1;
        }else if (index >= _imageCount){
            index = 0;
        }
        
        photoView.tag = index + START_TAG;
        
        [self setImageForPhotoView:photoView atIndex:index];
    }
    //the imageView in the middle should be always in the middle
    _scrollView.contentOffset = CGPointMake(_viewWidth, 0);
    
    _pageControl.currentPage = _photoViewArr[1].tag - START_TAG;
    _currentIndex = _photoViewArr[1].tag - START_TAG;
    
    if (_delegate && [_delegate respondsToSelector:@selector(photoBrowser:didScrollToIndex:)]) {
        
        [_delegate photoBrowser:self didScrollToIndex:_photoViewArr[1].tag-START_TAG];
    }
}

#pragma mark - photoView delegate
- (void)photoViewDidOnceTap:(CHTPhotoView *)photoView{
    
    if (_delegate && [_delegate respondsToSelector:@selector(photoBrowser:didSelectItemAtIndex:)]) {
        
        [_delegate photoBrowser:self didSelectItemAtIndex:photoView.tag-START_TAG];
    }
}

#pragma mark - scrollview delegate

//when scrollView end decelerating, this method wiil be called. (by user)
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (!_infiniteScroll && _imageCount < 3) {
        
        NSInteger index = scrollView.contentOffset.x / _viewWidth;
        _currentIndex = index;
        _pageControl.currentPage = _currentIndex;
        
        if (_delegate && [_delegate respondsToSelector:@selector(photoBrowser:didScrollToIndex:)]) {
            
            [_delegate photoBrowser:self didScrollToIndex:_currentIndex];
        }
        
    }else{
    
        [self updateUI];
    }
}

@end
