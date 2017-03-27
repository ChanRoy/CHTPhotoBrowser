# CHTPhotoBrowser
A Photo Browser With High Quality

![CHTPhotoBrowser](https://github.com/ChanRoy/CHTPhotoBrowser/blob/master/CHTPhotoBrowser.gif)

## Introduction

*A Photo Browser With High Quality.*

*The images can be from local or web.*

*No matter how many photos there is, it will be three image container.*

*The image above shows the usage.*

## Usage

### init method

- web images

```
- (instancetype)initWithFrame:(CGRect)frame imageUrls:(NSArray <NSString *>*)imageUrls placeholderImage:(UIImage *)placeholderImage;
```

- local images

```
- (instancetype)initWithFrame:(CGRect)frame images:(NSArray <UIImage *>*)images;
```

### property

- set the pageControl hidden or showed

```
@property (nonatomic, assign, getter=isShowPageControl) BOOL showPageControl;
```
- set the current image to show

```
@property (nonatomic, assign) NSInteger currentIndex;
```

### delegate

```
@property (nonatomic, weak) id <CHTPhotoBrowserDelegate> delegate;
```

### protocol

```
@protocol CHTPhotoBrowserDelegate <NSObject>

@optional
- (void)photoBrowser:(CHTPhotoBrowser *)photoBrowser didSelectItemAtIndex:(NSInteger)index;

- (void)photoBrowser:(CHTPhotoBrowser *)photoBrowser didScrollToIndex:(NSInteger)index;

@end
```

## demo

- web images

```
//photo from internet
NSArray *urlStrs = @[
                     @"http://img.mp.itc.cn/upload/20160826/9ac726cfdd3f480cb0bfaa34e6d62bf7_th.png",
                     @"http://img.mp.itc.cn/upload/20160826/440bbbaf33bd40e2b3707834ff85347e_th.jpg",
                     @"http://img.mp.itc.cn/upload/20160826/776dbf927f9c416487f1ba0378211144_th.jpg",
                     @"http://img.mp.itc.cn/upload/20160826/e5b3787c69074e86bc43a68772089c89_th.jpg"
                     ];
    
CHTPhotoBrowser *photoBrowser = [[CHTPhotoBrowser alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) imageUrls:urlStrs placeholderImage:[UIImage imageNamed:@"placePhoto"]];
[self.view addSubview:photoBrowser];

```

- local images

```
//local image
NSMutableArray *photos = [NSMutableArray new];
for (NSUInteger i = 0; i < 4; i ++) {
    
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld.jpg",i+1]];
    [photos addObject:image];
}
    
CHTPhotoBrowser *photoBrowser = [[CHTPhotoBrowser alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) images:photos];
photoBrowser.delegate = self;
    
[self.view addSubview:photoBrowser];
```

More detail showed in the `CHTPhotoBrowserDemo Project`

## LICENSE

MIT