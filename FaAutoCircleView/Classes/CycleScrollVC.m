//
//  CycleScrollVC.m
//  iOSStudyDemo
//
//  Created by 赖灵发 on 2020/9/25.
//  Copyright © 2020 赖灵发. All rights reserved.
//

#import "CycleScrollVC.h"

@interface CycleScrollVC () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) NSArray *dataArr;

@property (nonatomic, assign) CGFloat w;

@property (nonatomic, assign) CGFloat h;

@end

@implementation CycleScrollVC

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    _timer.fireDate = [NSDate distantFuture];
    [_timer invalidate];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self setupSubview];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor darkGrayColor];
}

#pragma mark - layout
- (void)setupSubview {
    self.dataArr = @[@"1", @"2", @"3", @"4", @"5", @"6"];
    [self.view addSubview:self.scrollView];
    
    self.w = self.view.frame.size.width;
    self.h = self.view.frame.size.height;
    self.scrollView.contentSize = CGSizeMake(self.w * (self.dataArr.count + 2), 0);
    for (int i = 0; i < self.dataArr.count + 2; i++) {
        UILabel *lab = [self generateLabel];
        lab.frame =  CGRectMake(i * self.w, 0, self.w, self.h);
        if (i == 0) {
            lab.text = self.dataArr.lastObject;
        } else if (i == self.dataArr.count + 1) {
            lab.text = self.dataArr.firstObject;
        } else {
            lab.text = self.dataArr[i - 1];
        }
        [self.scrollView addSubview:lab];
    }
    [self.scrollView setContentOffset:CGPointMake(self.w, 0) animated:false];
    
    self.pageControl.frame = CGRectMake(0, self.h - 100, self.w, 50);
    self.pageControl.numberOfPages = self.dataArr.count;
    [self.view addSubview:self.pageControl];
    
    [self performSelector:@selector(startTimerAction) withObject:nil afterDelay:2];
}

- (UILabel *)generateLabel {
    UILabel *lab = [[UILabel alloc] init];
    lab.backgroundColor = [UIColor darkGrayColor];
    lab.font = [UIFont systemFontOfSize:60];
    lab.textColor = [UIColor yellowColor];
    lab.textAlignment = NSTextAlignmentCenter;
    return lab;
}

- (void)startTimerAction {
    self.timer.fireDate = [NSDate distantPast];
}

#pragma mark - event
- (void)timerAction {
    int index = self.scrollView.contentOffset.x / self.view.frame.size.width;
    [self.scrollView setContentOffset:CGPointMake((index + 1) * self.w, 0) animated:true];
    
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 0.5), dispatch_get_main_queue(), ^{
        [weakSelf scrollviewIndexHandle:index + 1];
    });
}

#pragma mark - scrollview delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int index = scrollView.contentOffset.x / self.view.frame.size.width;
    [self scrollviewIndexHandle:index];
}

- (void)scrollviewIndexHandle: (int)currentIndex {
    if (currentIndex == 0) {
        [self.scrollView setContentOffset:CGPointMake(self.dataArr.count * self.w, 0) animated:false];
        self.pageControl.currentPage = self.dataArr.count - 1;
    } else if (currentIndex == self.dataArr.count + 1) {
        [self.scrollView setContentOffset:CGPointMake(self.w, 0) animated:false];
        self.pageControl.currentPage = 0;
    } else {
        self.pageControl.currentPage = currentIndex - 1;
    }
}

#pragma mark - property
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _scrollView.pagingEnabled = true;
        _scrollView.delegate = self;
        _scrollView.backgroundColor = [UIColor blackColor];
    }
    return _scrollView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.pageIndicatorTintColor = [UIColor cyanColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor blueColor];
    }
    return _pageControl;
}

- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(timerAction) userInfo:nil repeats:true];
    }
    return _timer;
}

@end
