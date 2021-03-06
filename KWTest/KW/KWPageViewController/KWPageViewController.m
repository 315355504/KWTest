//
//  KWPageViewController.m
//  RDSPageViewController
//
//  Created by Nico Arqueros on 10/17/14.
//  Copyright (c) 2014 Moblox. All rights reserved.
//
// Based in the Work of : cwRichardKim https://github.com/cwRichardKim/RKSwipeBetweenViewControllers

#import "KWPageViewController.h"

@interface KWPageViewController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *viewControllerArray;
@property (nonatomic, strong) UIPageViewController *pageController;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, strong) UIScrollView *scrollNavigationView;
@property (nonatomic, assign) NSInteger buttonPressed;

@property (nonatomic, strong) UIScrollView *pageScrollView;
@property (nonatomic, assign) NSInteger currentPageIndex;
@property (nonatomic, strong) NSArray *connectedButtons;
@end

@implementation KWPageViewController

#pragma mark - Init

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [[KWPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                            navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                          options:nil];
    
    if (self) {
        
        _viewControllerArray = [[NSMutableArray alloc] init];
        _currentPageIndex = 0;
        
        _pageMode = KW_FreeButtons;
    }
    return self;
}

#pragma mark - Public

- (void)reloadPages {
    [self reloadPagesToCurrentPageIndex:0];
}

- (void)reloadPagesToCurrentPageIndex:(NSInteger)currentPageIndex {
    // Initialize/ Refresh everything
    self.currentPageIndex = currentPageIndex;
    [self loadControllerAndView];
    [self loadControllers];
    [self connectButtons];
    if([[self KWDataSource] respondsToSelector:@selector(otherConfiguration)]) {
        [[self KWDataSource] otherConfiguration];
    }
}

#pragma mark - Setup

- (void)otherConfiguration {
  // Replace me   
}

- (void)moveToViewNumber:(NSInteger)viewNumber {
    [self moveToViewNumber:viewNumber animated:YES];
}

- (void)moveToViewNumber:(NSInteger)viewNumber animated:(BOOL)animated {
    NSAssert([_viewControllerArray count] > viewNumber, @"viewNumber exceeds the number of current viewcontrollers");
    id viewController = _viewControllerArray[viewNumber];
    [self KWPageChangedToIndex:_currentPageIndex];
    
    __weak __typeof(self)weakSelf = self;
    UIPageViewControllerNavigationDirection direction = UIPageViewControllerNavigationDirectionForward;
    if (_currentPageIndex > viewNumber) {
        direction = UIPageViewControllerNavigationDirectionReverse;
    }
    [self setViewControllers:@[viewController]
                   direction:direction
                    animated:animated
                  completion:^(BOOL finished) {
                      
                      if (!weakSelf) return;
                      __strong __typeof(weakSelf)strongSelf = weakSelf;
                      
                      dispatch_async(dispatch_get_main_queue(), ^{
                          
                          [strongSelf updateCurrentPageIndex:viewNumber];
                          [strongSelf setViewControllers:@[viewController]
                                               direction:direction
                                                animated:NO completion:nil];
                      });
                  }];
}

#pragma mark - Setup

- (void)loadControllerAndView
{
    NSAssert([[self KWDataSource] isKindOfClass:[UIViewController class]], @"This needs to be implemented in a class that inherits from UIViewController");
    [(UIViewController *)[self KWDataSource] addChildViewController:self];
    [[[self KWDataSource] KWPageContainer] addSubview:self.view];
}

- (void)loadControllers
{
    [_viewControllerArray removeAllObjects];
    NSArray* controllers = [[self KWDataSource] KWPageControllers];
    NSAssert(controllers, @"KWPageControllers Array need to be non empty");
    [_viewControllerArray addObjectsFromArray:controllers];
    [self setupPageViewController];
}


- (void)connectButtons
{
    NSArray* buttons = [[self KWDataSource] KWPageButtons];
    NSAssert([buttons count] > 0, @"Buttons needs to be at least 1");
    
    if (_pageMode == KW_SegmentController) {
//        NSAssert([buttons count] == 1, @"Only one segmentcontroller can be used");
//        NSAssert([[buttons objectAtIndex:0] isKindOfClass:[UISegmentedControl class]], @"The Object needs to be or inherit from UISegmentedControl");
        UISegmentedControl* segmentController = (UISegmentedControl*)[buttons objectAtIndex:0];
//        NSAssert(segmentController.numberOfSegments == [_viewControllerArray count], @"The number of segments needs to be the same as the number of controllers");
        [segmentController addTarget:self
                              action:@selector(segmentControllerMode:)
                    forControlEvents:UIControlEventValueChanged];
        
        _connectedButtons = @[segmentController];
        return;
    }
    
    NSAssert(_viewControllerArray, @"addButtonsToSegmentPage Array need to be non empty");
    int i = 0;
    for (UIButton* button in buttons){
        NSAssert([button isKindOfClass:[UIButton class]], @"Add buttons to KWPageButtons Array need to contain only UIButton elements");
        button.tag = i;
        
        switch (_pageMode) {
            case KW_FreeButtons:
                [button addTarget:self action:@selector(freeButtonsMode:) forControlEvents:UIControlEventTouchUpInside];
                break;
            case KW_LeftRightArrows:
                [button addTarget:self action:@selector(leftRightMode:) forControlEvents:UIControlEventTouchUpInside];
                break;
            default:
                break;
        }
        i++;
    }
     _connectedButtons = buttons;
}


- (void)setupPageViewController
{
    NSAssert(_viewControllerArray, @"pageview controller need to have at last one controller");
    
    _pageController = self;
    
    _pageController.delegate = self;
    _pageController.dataSource = self;
    [_pageController setViewControllers:@[[_viewControllerArray objectAtIndex:_currentPageIndex]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    [self syncScrollView];
}

- (void)setupScrollNavigationController
{
    _scrollNavigationView.delegate = self;
}

-  (void)syncScrollView
{
    for (UIView* view in _pageController.view.subviews){
        if([view isKindOfClass:[UIScrollView class]])
        {
            _pageScrollView = (UIScrollView *)view;
            _pageScrollView.delegate = self;
        }
    }
}

- (void)viewWillLayoutSubviews
{
    UIView* container = [[self KWDataSource] KWPageContainer];
    self.view.frame = CGRectMake(0.0, 0.0, container.frame.size.width, container.frame.size.height);
    [super viewWillLayoutSubviews];
}

#pragma mark -
#pragma mark - Button and Controller Interactions
#pragma mark - Free Buttons Mode

- (void)freeButtonsMode:(UIButton *)button
{
    NSInteger destination = button.tag;
    [self controllerModeLogicForDestination:destination];
}

#pragma mark - Left Right Buttons Mode

- (void)leftRightMode:(UIButton *)button
{
    NSInteger tempIndex = _currentPageIndex;
    __weak __typeof(&*self)weakSelf = self;
    // Check to see which way are you going (Left -> Right or Right -> Left)
    if (button.tag == 1) {
        
        if (!(tempIndex + 1 < [_viewControllerArray count])) {
            return;
        }
        
        NSInteger newIndex = tempIndex + 1;
        [self setPageControllerForIndex:newIndex direction:UIPageViewControllerNavigationDirectionForward currentKWViewController:weakSelf];    }
    
    else if (button.tag == 0) {
        
        if (!(tempIndex > 0)) {
            return;
        }
        
        NSInteger newIndex = tempIndex - 1;
        [self setPageControllerForIndex:newIndex direction:UIPageViewControllerNavigationDirectionReverse currentKWViewController:weakSelf];
    }
}

#pragma mark - Segment Controller Mode

- (void)segmentControllerMode:(UISegmentedControl *)segmentController
{
    // segmentController.numberOfSegments
    // segmentController.selectedSegmentIndex

    NSInteger destination = segmentController.selectedSegmentIndex;
    [self controllerModeLogicForDestination:destination];
}

- (void)updateSegmentControllerWithDestination:(NSInteger)destination
{
    UISegmentedControl *segmentController = (UISegmentedControl *)self.connectedButtons[0];
    [segmentController setSelectedSegmentIndex:destination];
}

#pragma mark - Controller Mode Common Logic

- (void)controllerModeLogicForDestination:(NSInteger)destination
{
    __weak __typeof(&*self)weakSelf = self;
    NSInteger tempIndex = _currentPageIndex;
    // Check to see which way are you going (Left -> Right or Right -> Left)
    if (destination > tempIndex) {
        for (int i = (int)tempIndex+1; i<=destination; i++) {
            [self setPageControllerForIndex:i direction:UIPageViewControllerNavigationDirectionForward currentKWViewController:weakSelf destionation:destination];
        }
    }
    
    // Right -> Left
    else if (destination < tempIndex) {
        for (int i = (int)tempIndex-1; i >= destination; i--) {
            [self setPageControllerForIndex:i direction:UIPageViewControllerNavigationDirectionReverse currentKWViewController:weakSelf destionation:destination];
        }
    }
}

- (void)setPageControllerForIndex:(NSInteger)index direction:(UIPageViewControllerNavigationDirection)direction currentKWViewController:(id)weakSelf
{
        [self setPageControllerForIndex:index direction:direction currentKWViewController:weakSelf destionation:0];
}

- (void)setPageControllerForIndex:(NSInteger)index direction:(UIPageViewControllerNavigationDirection)direction currentKWViewController:(id)weakSelf destionation:(NSInteger)destination
{
    __block NSInteger pageModeBlock = _pageMode;
    [_pageController setViewControllers:@[[_viewControllerArray objectAtIndex:index]] direction:direction animated:NO completion:^(BOOL complete){
        __strong __typeof(&*weakSelf)strongSelf = weakSelf;
        if (complete && strongSelf) {
            if ((pageModeBlock == KW_SegmentController) && (index != destination)) return; // It should update the segment buttons when the user already pressed in a segment
            [strongSelf updateCurrentPageIndex:index];
        }
    }];
}



- (void)updateCurrentPageIndex:(NSInteger)newIndex
{
    _currentPageIndex = newIndex;
//    [self KWPageChangedToIndex:_currentPageIndex];
}

// Delegate
- (void)KWPageChangedToIndex:(NSInteger)index
{
    if ([self KWDataDelegate] && [[self KWDataDelegate] respondsToSelector:@selector(KWPageChangedToIndex:)]) {
        [[self KWDataDelegate] KWPageChangedToIndex:index];
    }
    
    if (_pageMode == KW_SegmentController) {
        [self updateSegmentControllerWithDestination:index];
    }
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger index = [self indexOfController:viewController];
    
    if ((index == NSNotFound) || (index == 0)) {
        return nil;
    }
    
    index--;
    return [_viewControllerArray objectAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSInteger index = [self indexOfController:viewController];
    
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    
    if (index == [_viewControllerArray count]) {
        return nil;
    }
    
    return [_viewControllerArray objectAtIndex:index];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    
    if (completed) {
        _currentPageIndex = [self indexOfController:[pageViewController.viewControllers lastObject]];
        [self KWPageChangedToIndex:_currentPageIndex];
    }
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers{
    _buttonPressed = -1;
}


- (NSInteger)indexOfController:(UIViewController *)viewController
{
    for (int i = 0; i < [_viewControllerArray count]; i++) {
        if (viewController == [_viewControllerArray objectAtIndex:i])
        {
            return i;
        }
    }
    return NSNotFound;
}

#pragma mark - Helpers

- (NSString *)description {
    
    return [NSString stringWithFormat:@"%@ description: %@", [super description], self.viewControllerArray];
}

@end


