//
//  ViewController.m
//  CHTPhotoBrowserDemo
//
//  Created by cht on 2017/3/20.
//  Copyright © 2017年 cht. All rights reserved.
//

#import "ViewController.h"
#import "CHTPhotoBrowser.h"
#import "UIImageView+WebCache.h"

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<CHTPhotoBrowserDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *urlStrs = @[
                         @"http://img.mp.itc.cn/upload/20160826/9ac726cfdd3f480cb0bfaa34e6d62bf7_th.png",
                         @"http://img.mp.itc.cn/upload/20160826/440bbbaf33bd40e2b3707834ff85347e_th.jpg",
                         @"http://img.mp.itc.cn/upload/20160826/776dbf927f9c416487f1ba0378211144_th.jpg",
                         @"http://img.mp.itc.cn/upload/20160826/e5b3787c69074e86bc43a68772089c89_th.jpg"
                         ];
    
    NSMutableArray *photos = [NSMutableArray new];
    for (NSUInteger i = 0; i < 4; i ++) {
        
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld.jpg",i+1]];
        [photos addObject:image];
    }
    
//    CHTPhotoBrowser *photoBrowser = [[CHTPhotoBrowser alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) imageUrls:urlStrs placeholderImage:[UIImage imageNamed:@"placePhoto"]];
    
    CHTPhotoBrowser *photoBrowser = [[CHTPhotoBrowser alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) images:photos];
    photoBrowser.delegate = self;
    photoBrowser.showPageControl = YES;
    [self.view addSubview:photoBrowser];
    
}

#pragma mark - photoBrowser delegate
- (void)photoBrowser:(CHTPhotoBrowser *)photoBrowser didSelectItemAtIndex:(NSInteger)index{
    
    NSLog(@"didSelectItemAtIndex : %ld", index);
}

- (void)photoBrowser:(CHTPhotoBrowser *)photoBrowser didScrollToIndex:(NSInteger)index{
    
    NSLog(@"didScrollToIndex : %ld", index);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
