//
//  AutoBannerScrollView.m
//  CashLoan
//
//  Created by xia on 2017/8/9.
//  Copyright © 2017年 heycom.eongdu.xianjingdai. All rights reserved.
//

#import "AutoBannerScrollView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <Masonry/Masonry.h>
#import "BannerScroll.h"

@interface AutoBannerScrollView()<UIScrollViewDelegate>
{
    NSInteger pageCount;
    NSTimeInterval autoTimeInterval;
}
@property (nonatomic, strong) NSMutableArray *imageNameArray;
@property (nonatomic, strong) NSMutableArray *imageUrlArray;
@property (nonatomic, strong) BannerScroll *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, copy)   ClickWithBlock clickWithBlock;

@property (nonatomic, strong) NSTimer *timer;
@end

@implementation AutoBannerScrollView

-(id)initWithImageNames:(NSArray *)imageNames autoTimerInterval:(NSTimeInterval)timeInterval clickBlock:(ClickWithBlock)block {
    if (self = [super init]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.imageNameArray = [NSMutableArray arrayWithArray:imageNames];
        self.imageUrlArray = [NSMutableArray array];
        pageCount = _imageNameArray.count;
        
        self.clickWithBlock = block;
        
        autoTimeInterval = timeInterval;
        
        [self initUI];
    }
    return self;
}

-(id)initWithImageUrls:(NSArray *)imageUrls autoTimerInterval:(NSTimeInterval)timeInterval clickBlock:(ClickWithBlock)block {
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.imageUrlArray = [NSMutableArray arrayWithArray:imageUrls];
        self.imageNameArray = [NSMutableArray array];
        pageCount = _imageUrlArray.count;
        
        self.clickWithBlock = block;
        
        autoTimeInterval = timeInterval;
        
        [self initUI];
    }
    return self;
}

-(void)replaceImageUrls:(NSArray *)imageUrls clickBlock:(ClickWithBlock)block{
    self.imageUrlArray = [NSMutableArray arrayWithArray:imageUrls];
    self.imageNameArray = [NSMutableArray array];
    pageCount = _imageUrlArray.count;
    self.clickWithBlock = block;
    
    for (UIView *view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
    [self addImageViews];
    
    self.pageControl.numberOfPages = pageCount;
}

-(void)replaceImageNames:(NSArray *)imageNames clickBlock:(ClickWithBlock)block{
    self.imageNameArray = [NSMutableArray arrayWithArray:imageNames];
    self.imageUrlArray = [NSMutableArray array];
    pageCount = _imageNameArray.count;
    self.clickWithBlock = block;
    
    for (UIView *view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
    [self addImageViews];
    
    self.pageControl.numberOfPages = pageCount;
}
-(UIScrollView *)scrollView
{
    if (_scrollView != nil) {
        return _scrollView;
    }
    
    self.scrollView = [[BannerScroll alloc] initWithFrame:self.bounds];
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.bounces = NO;
    _scrollView.alwaysBounceHorizontal = NO;
    _scrollView.alwaysBounceVertical = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    
    return _scrollView;
}
-(UIPageControl *)pageControl
{
    if (_pageControl != nil) {
        return _pageControl;
    }
    
    self.pageControl = [[UIPageControl alloc] init];
    _pageControl.numberOfPages = pageCount;
    _pageControl.hidden = pageCount <= 1;
    [_pageControl addTarget:self action:@selector(pageChange:) forControlEvents:UIControlEventValueChanged];
    return _pageControl;
}
-(void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor
{
    _pageIndicatorTintColor = pageIndicatorTintColor;
    self.pageControl.pageIndicatorTintColor = pageIndicatorTintColor;
}

-(void)setCurrentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor
{
    _currentPageIndicatorTintColor = currentPageIndicatorTintColor;
    self.pageControl.currentPageIndicatorTintColor = currentPageIndicatorTintColor;
}
//点击 索引改变
-(void)pageChange:(UIPageControl *)pageControl
{
    //        NSInteger page = pageControl.currentPage;
    //
    //        [self.scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width * page, 0) animated:YES];
    //
    //        [self endAutoChange];
    //        [self beginAutoChange];
}
-(void)initUI
{
    [self addSubview:self.scrollView];
    self.contentView = UIView.new;
    [self.scrollView addSubview:_contentView];
    [self addImageViews];
    [self addSubview:self.pageControl];
    
    self.pageIndicatorTintColor = [UIColor grayColor];
    self.currentPageIndicatorTintColor = [UIColor whiteColor];
    
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(30);
        make.bottom.equalTo(self).offset(0);
        make.centerX.equalTo(self);
    }];
    
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.height.equalTo(self.scrollView);
    }];
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.offset(0);
    }];
    
    if (pageCount > 1) {
        //默认显示第二页(第一页为最后一张，主要为了可以循环滚动)
        [self.scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width * 1, 0) animated:NO];
        //分页view显示第一页
        self.pageControl.currentPage = 0;
    }
    
    [self beginAutoChange];
}
//开始自动切换
-(void)beginAutoChange
{
    if (pageCount <= 1) {
        return;
    }
    
    if (autoTimeInterval == 0) {
        return;
    }
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:autoTimeInterval target:self selector:@selector(changeScrollPage) userInfo:nil repeats:YES];
}
-(void)changeScrollPage
{
    NSInteger currentIndex = (int)_scrollView.contentOffset.x/_scrollView.frame.size.width;
    
    if (currentIndex < pageCount + 1) {
        currentIndex ++;
    }
    
    [UIView animateWithDuration:0.3f animations:^{
        [self.scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width * currentIndex, 0)];
    } completion:^(BOOL finished) {
        if (currentIndex == pageCount + 1) {
            [self.scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0)];
        }
    }];
    
    if (currentIndex==0)
    {
        currentIndex = pageCount - 1;
    }
    else if (currentIndex == (pageCount+1))
    {
        currentIndex = 0;
    }else{
        currentIndex --;
    }
    
    self.pageControl.currentPage = currentIndex;
}
-(void)addImageViews
{
    //显示逻辑：3,1,2,3,1
    //第一屏显示最后一张
    UIImageView *lastImageView = [self addImageViewIndex:pageCount-1 lastView:nil];
    
    //其余正常顺序显示
    for (int i=0; i<pageCount; i++) {
        lastImageView = [self addImageViewIndex:i lastView:lastImageView];
    }
    
    //最后一屏显示第一张
    lastImageView = [self addImageViewIndex:0 lastView:lastImageView];
    
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lastImageView.mas_right);
    }];
}
//返回图片
-(UIImageView *)addImageViewIndex:(NSInteger)i lastView:(UIImageView *)lastImageView
{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_contentView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lastImageView ? lastImageView.mas_right : @0);
        make.top.equalTo(_contentView).offset(0);
        make.centerY.equalTo(_contentView);
        make.height.equalTo(self.scrollView.mas_height);
        make.width.equalTo(self.scrollView.mas_width);
    }];
    
    if (_imageNameArray.count > 0) {
        [imageView setImage:[UIImage imageNamed:[_imageNameArray objectAtIndex:i]]];
    }else if (_imageUrlArray.count > 0){
        [imageView sd_setImageWithURL:[NSURL URLWithString:[_imageUrlArray objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"banner"]];
    }
    
    return imageView;
}
//滚动视图滑动
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self endAutoChange];
}


//滚动视图释放滚动
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger currentIndex = scrollView.contentOffset.x/self.scrollView.frame.size.width;
    
    if (currentIndex==0)
    {
        currentIndex = pageCount - 1;
        [self.scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width * pageCount, 0) animated:NO];// 序号0 最后1页
    }
    else if (currentIndex == (pageCount+1))
    {
        currentIndex = 0;
        [self.scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0) animated:NO]; // 最后+1,循环第1页
    }else{
        currentIndex --;
    }
    
    self.pageControl.currentPage = currentIndex;
    
    [self beginAutoChange];
}
//停止自动切换
-(void)endAutoChange
{
    if (self.timer != nil) {
        [self.timer invalidate];
        self.timer = nil;
    }
}
//点击
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSInteger currentIndex = self.scrollView.contentOffset.x/self.scrollView.frame.size.width;
    
    if (currentIndex==0)
    {
        currentIndex = pageCount - 1;
    }
    else if (currentIndex == (pageCount+1))
    {
        currentIndex = 0;
    }else{
        currentIndex --;
    }
    if (self.clickWithBlock) {
        self.clickWithBlock(currentIndex);
    }
}
@end
