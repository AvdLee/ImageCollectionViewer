//
//  AJImageCollectionView.m
//  ImageCollectionViewer
//
//  Created by Antoine van der Lee on 24-04-13.
//  Copyright (c) 2013 Antoine van der Lee. All rights reserved.
//

#import "AJImageCollectionViewController.h"
#import "PhotoViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface AJImageCollectionViewController (){
    AJImageCollection *_imageCollection;
    UIInterfaceOrientation _currentOrientation;
}
@end

@implementation AJImageCollectionViewController
@synthesize imageCollectionScrollView, imageThumbsCollection, imageCollectionTitle, zoomedImageCollectionViewController;

#pragma mark - View Initialisation
- (id)initWithImageCollection:(AJImageCollection *)imageCollection
{
    if (self = [super initWithNibName:@"AJImageCollectionViewController" bundle:nil]) {
        // Custom initialization
        _imageCollection = imageCollection;
        [self.view setFrame:self.view.frame];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.imageCollectionTitle setText:[_imageCollection title]];
    imageThumbsCollection = [[NSMutableDictionary alloc] init];
    AJImageContainer *tempImageContainer = [[AJImageContainer alloc] init];
    [imageCollectionScrollView setDelegate:self];
    [imageCollectionScrollView setContentSize:CGSizeMake((tempImageContainer.view.frame.size.width+THUMBS_SPACING)*[_imageCollection.images count], tempImageContainer.view.frame.size.height)];
    [imageCollectionScrollView setContentOffset:CGPointMake(-SCROLLVIEW_INSET, 0)];
    [imageCollectionScrollView setContentInset:UIEdgeInsetsMake(0, SCROLLVIEW_INSET, 0, 0)];
    
    // set orientation
    _currentOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    // set observers
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willRotate:) name:@"willRotate" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRotate:) name:@"didRotate" object:nil];

}

- (void)willRotate:(NSNotification *)notification {
    if(zoomedImageCollectionViewController){
        //UIViewController *parent = [notification object];
        //[parent.navigationController setNavigationBarHidden:YES animated:NO];
    }
}

- (void)didRotate:(NSNotification *)notification {
    if(zoomedImageCollectionViewController){
        UIViewController *parent = [notification object];
        //parent.navigationController.view set
        
        UIWindow* window = [UIApplication sharedApplication].keyWindow;
        if (!window)
            window = [[UIApplication sharedApplication].windows objectAtIndex:0];
        [window sendSubviewToBack:parent.navigationController.view];
        //[[[window subviews] objectAtIndex:0] bringSubviewToFront:zoomedImageCollectionViewController.view];
        //[parent.navigationController setNavigationBarHidden:NO animated:NO];

    }
}


#pragma mark - Images Initialisation
- (void) addImageForIndex:(int)index {
    AJImageContainer *imageContainer;
    imageContainer = [[AJImageContainer alloc] initWithImage:_imageCollection.images[index]];
    [imageContainer.view setFrame:CGRectMake((imageContainer.view.frame.size.width + THUMBS_SPACING)*index, 0, imageContainer.view.frame.size.width, imageContainer.view.frame.size.height)];
    [imageContainer.collectionImageButton setTag:index];
    [imageContainer.collectionImageButton addTarget:self action:@selector(collectionImageClicked:) forControlEvents:UIControlEventTouchUpInside];
    [imageCollectionScrollView addSubview:imageContainer.view];
    [imageThumbsCollection setObject:imageContainer forKey:[NSString stringWithFormat:@"%u", index]];
}

- (void) refreshScrollView {
    float currentOffset = imageCollectionScrollView.contentOffset.x + SCROLLVIEW_INSET;
    float widthPerObject = imageCollectionScrollView.contentSize.width / [_imageCollection.images count];
    int currentCenterIndex = floor((currentOffset + (SCREEN_WIDTH/2)) / widthPerObject);
            
    float biggestSize = MAX(SCREEN_WIDTH, SCREEN_HEIGHT);
    int beforeAndAfterCount = floor(biggestSize / widthPerObject);
    
    for (int i=0; i < [_imageCollection.images count]; i++){
        AJImageContainer *tempContainer = [imageThumbsCollection valueForKey:[NSString stringWithFormat:@"%u", i]];
        
        if (i >= (currentCenterIndex - beforeAndAfterCount) && i <= (currentCenterIndex + beforeAndAfterCount)){
            if(!tempContainer){
                [self addImageForIndex:i];
            }
        } else {
            [tempContainer.view removeFromSuperview];
            [imageThumbsCollection removeObjectForKey:[NSString stringWithFormat:@"%u", i]];
        }
    }
}

#pragma mark - Image methods
- (IBAction)collectionImageClicked:(id)sender {
    UIButton *button = sender;
    zoomedImageCollectionViewController = [AJZoomedImageCollectionViewController initWithImageCollection:_imageCollection selectedIndex:button.tag delegate:self];
        
    [zoomedImageCollectionViewController.view setFrame:[self returnAbsoluteScreenFrame]];
    
    /*UIWindow* window = [UIApplication sharedApplication].keyWindow;
    if (!window)
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    [[[window subviews] objectAtIndex:0] addSubview:zoomedImageCollectionViewController.view];*/
    
    [self.navigationController pushViewController:zoomedImageCollectionViewController animated:FALSE];
    
    //[[[UIApplication sharedApplication] keyWindow] addSubview:zoomedImageCollectionViewController.view];
    //[self.navigationController.view addSubview:zoomedImageCollectionViewController.view];
    
}

- (CGRect) returnAbsoluteFrameForButton:(UIButton *)button {
    CGRect imageContainerFrame = button.superview.frame;
    float x = (imageContainerFrame.origin.x + imageCollectionScrollView.frame.origin.x + button.frame.origin.x + self.view.frame.origin.x) - imageCollectionScrollView.contentOffset.x;
    float y = (imageContainerFrame.origin.y + imageCollectionScrollView.frame.origin.y + button.frame.origin.y + self.view.frame.origin.y);
    
    // If navigation bar enabled
    if(!self.parentViewController.navigationController.navigationBarHidden){
        UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        y += (UIInterfaceOrientationIsPortrait(interfaceOrientation) ? 44 : 32);
    }
    
    return CGRectMake(x, y, button.frame.size.width, button.frame.size.height);
}

- (CGRect) returnAbsoluteScreenFrame {
    CGRect frame = self.view.bounds;
    CGRect appFrame = [[UIScreen mainScreen] applicationFrame];
    
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if(UIInterfaceOrientationIsPortrait(interfaceOrientation)){
        return appFrame;
    } else {
        frame.size.height = appFrame.size.width;
        frame.size.width = appFrame.size.height;
        frame.origin.y = ([UIApplication sharedApplication].statusBarHidden ? 0 : 20);
    }
    
    return frame;
}

#pragma mark - imageCollectionScrollViewDelegate methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self refreshScrollView];
}

#pragma mark - AJZoomedImageCollectionViewDelegate methods
- (void)zoomedImagePageViewControllerSwitchedToIndex:(NSUInteger)index {
    [self scrollToMakeSelectedImageVisibleForSelectedIndex:index];
}

- (void) scrollToMakeSelectedImageVisibleForSelectedIndex:(int)index {
    AJImageContainer *selectedImageView = [imageThumbsCollection objectForKey:[NSString stringWithFormat:@"%u",index]];
    CGRect selectedImageContainerFrame = selectedImageView.view.frame;
    
    if(selectedImageContainerFrame.origin.x >= imageCollectionScrollView.contentOffset.x){
        selectedImageContainerFrame.origin.x = selectedImageContainerFrame.origin.x + SCROLLVIEW_INSET;
    }
    
    [imageCollectionScrollView scrollRectToVisible:selectedImageContainerFrame animated:FALSE];
}

- (CGRect)returnThumbFrameForIndex:(NSUInteger)index {
    AJImageContainer *selectedImageView = [imageThumbsCollection objectForKey:[NSString stringWithFormat:@"%u",index]];
    return [self returnAbsoluteFrameForButton:selectedImageView.collectionImageButton];
}

#pragma mark - Rotation methods
- (void)viewWillLayoutSubviews {
    [self checkIfOrientationChanged];
}

- (void)checkIfOrientationChanged {
    UIInterfaceOrientation newOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    BOOL newOrientationIsPortrait = UIInterfaceOrientationIsPortrait(newOrientation);
    BOOL oldOrientationIsPortrait = UIInterfaceOrientationIsPortrait(_currentOrientation);
    
    if(newOrientationIsPortrait != oldOrientationIsPortrait){
        _currentOrientation = newOrientation;
        [self refreshScrollView];
        if(zoomedImageCollectionViewController){
            [self scrollToMakeSelectedImageVisibleForSelectedIndex:zoomedImageCollectionViewController.currentPageIndex];
        }
    }
}
@end
