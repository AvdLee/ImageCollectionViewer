//
//  AJZoomedImageCollectionViewController.m
//  ImageCollectionViewer
//
//  Created by Antoine van der Lee on 27-04-13.
//  Copyright (c) 2013 Antoine van der Lee. All rights reserved.
//

#import "AJZoomedImageCollectionViewController.h"

@interface AJZoomedImageCollectionViewController () {
    NSUInteger currentPageIndex;
    BOOL initiated;
    BOOL infoVisible;
    AJImageCollection *_imageCollection;
}

@end

@implementation AJZoomedImageCollectionViewController

@synthesize imageTitle, delegate;
@synthesize selectedImageSmallFrame, imagesPageViewController, imageHeaderViewContainer, imageFooterViewContainer;
@synthesize footerCurrentIndex, footerLeftArrow, footerRightArrow, footerTotalImagesCount;


#pragma mark - View Initialisation
+ (AJZoomedImageCollectionViewController *)initWithImageCollection:(AJImageCollection *)imageCollection selectedIndex:(NSUInteger)index selectedImageFrame:(CGRect)frame
{
    return [[self alloc] initWithImageCollection:imageCollection selectedIndex:index selectedImageFrame:frame];
}

- (id) initWithImageCollection:(AJImageCollection *)imageCollection selectedIndex:(NSUInteger)index selectedImageFrame:(CGRect)frame {
    if (self = [super initWithNibName:@"AJZoomedImageCollectionViewController"  bundle:nil]) {
        // Custom initialization
        _imageCollection = imageCollection;
        currentPageIndex = index;
        selectedImageSmallFrame = frame;
        
        [self buildPageController];
    }
    return self;
}

#pragma mark - View lifecycle
- (void) viewWillAppear:(BOOL)animated {
    // Set outside view to animate in later
    CGRect headerFrame = imageHeaderViewContainer.frame;
    headerFrame.origin.y = -headerFrame.size.height;
    [imageHeaderViewContainer setFrame:headerFrame];
    
    CGRect footerFrame = imageFooterViewContainer.frame;
    footerFrame.origin.y = footerFrame.origin.y + footerFrame.size.height;
    [imageFooterViewContainer setFrame:footerFrame];
    
    [self updateHeaderAndFooterForCurrentImage];
}

- (void) viewDidLoad {
    [imageTitle setText:[[_imageCollection.images objectAtIndex:currentPageIndex] title]];
    [self initGestures];
}

#pragma mark - Gesture methods
- (void) initGestures {
    UITapGestureRecognizer *doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                                          initWithTarget:self action:nil];
    doubleTapGestureRecognizer.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:doubleTapGestureRecognizer];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [singleTap setNumberOfTapsRequired:1];
    [singleTap requireGestureRecognizerToFail: doubleTapGestureRecognizer];
    [self.view addGestureRecognizer:singleTap];
}

- (void)handleSingleTap:(UIGestureRecognizer *)recognizer {
    [self animateHeaderAndFooterToVisibility:!infoVisible];
}

#pragma mark - Header and Footer methods
- (void) animateHeaderAndFooterToVisibility:(BOOL)visibile {
    CGRect imageHeaderFrame = imageHeaderViewContainer.frame;
    CGRect imageFooterFrame = imageFooterViewContainer.frame;

    infoVisible = visibile;
    
    if(visibile){
        imageHeaderFrame.origin.y = 0;
        imageFooterFrame.origin.y = self.view.bounds.size.height - imageFooterFrame.size.height;
    } else {
        imageHeaderFrame.origin.y = -imageHeaderFrame.size.height;
        imageFooterFrame.origin.y = self.view.bounds.size.height;
    }
    
    [UIView animateWithDuration:0.15
                     animations:^{
                         imageHeaderViewContainer.frame = imageHeaderFrame;
                         imageFooterViewContainer.frame = imageFooterFrame;
                     }];
}

- (void) updateHeaderAndFooterForCurrentImage {
    [imageTitle setText:[[_imageCollection.images objectAtIndex:currentPageIndex] title]];
    [footerLeftArrow setAlpha:(currentPageIndex == 0 ? 0.4 : 1.0)];
    [footerRightArrow setAlpha:(currentPageIndex == ([_imageCollection.images count]-1) ? 0.4 : 1.0)];
    [footerCurrentIndex setText:[NSString stringWithFormat:@"%u", (currentPageIndex + 1)]];
    [footerTotalImagesCount setText:[NSString stringWithFormat:@"%u", [_imageCollection.images count]]];
}

#pragma mark - UIPageViewController methods
- (void) buildPageController {
    [delegate zoomedImagePageViewControllerSwitchedToIndex:0];

    PhotoViewController *pageZero = [PhotoViewController photoViewControllerForImage:[_imageCollection.images objectAtIndex:currentPageIndex] pageIndex:currentPageIndex andZoomedImageSrollViewDelegate:self];
    
    if (pageZero != nil)
    {
        NSDictionary * options;
        
        // Page spacing available from iOS 6 and up
        if(DEVICE_SYSTEM_VERSION >= 6){
            options = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:12.0f] forKey:UIPageViewControllerOptionInterPageSpacingKey];
        }
        
        imagesPageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
        
        [imagesPageViewController setDataSource:self];
        [imagesPageViewController setDelegate:self];
        [imagesPageViewController.view setFrame:self.view.frame];
        [imagesPageViewController.view setBackgroundColor:[UIColor blackColor]];
        
        [imagesPageViewController setViewControllers:@[pageZero]
                                     direction:UIPageViewControllerNavigationDirectionForward
                                      animated:NO
                                    completion:NULL];
        
        [self.view insertSubview:imagesPageViewController.view belowSubview:imageHeaderViewContainer];
        
        [pageZero animateImageIn];
        initiated = true;
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pvc viewControllerBeforeViewController:(PhotoViewController *)vc
{
    if(vc.pageIndex == 0) return nil;
    
    NSUInteger newIndex = vc.pageIndex - 1;
    AJImage *image = [_imageCollection.images objectAtIndex:newIndex];

    return [PhotoViewController photoViewControllerForImage:image pageIndex:newIndex andZoomedImageSrollViewDelegate:self];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pvc viewControllerAfterViewController:(PhotoViewController *)vc
{    
    NSUInteger newIndex = vc.pageIndex + 1;

    if(newIndex < [_imageCollection.images count]){
        AJImage *image = [_imageCollection.images objectAtIndex:newIndex];

        return [PhotoViewController photoViewControllerForImage:image pageIndex:newIndex andZoomedImageSrollViewDelegate:self];
    }
    return nil;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    
    if(completed) {
        currentPageIndex = [(PhotoViewController *)[pageViewController.viewControllers lastObject] pageIndex];
        [delegate zoomedImagePageViewControllerSwitchedToIndex:currentPageIndex];
        [self updateHeaderAndFooterForCurrentImage];
    }
}

#pragma mark - AJZoomedImageSrollViewDelegate methods
- (void) zoomedImageScrolledOut {
    [self.view removeFromSuperview];
}

- (CGRect) returnThumbFrameForIndex:(NSUInteger) index {
    return selectedImageSmallFrame;
}

- (void) zoomedImageScrollViewWillBeginAnimating {
    if(initiated){
        [self animateHeaderAndFooterToVisibility:FALSE];
    }
    
    [imagesPageViewController.view setBackgroundColor:[UIColor clearColor]];
}

- (void) zoomedImageScrollViewDidEndAnimating {
    [self animateHeaderAndFooterToVisibility:TRUE];
    [imagesPageViewController.view setBackgroundColor:[UIColor blackColor]];
}

#pragma mark - Orientation methods
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

@end