//
//  AJZoomedImageCollectionViewController.h
//  ImageCollectionViewer
//
//  Created by Antoine van der Lee on 27-04-13.
//  Copyright (c) 2013 Antoine van der Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoViewController.h"
#import "AJImageCollectionSettings.h"
#import "AJImageCollection.h"

@protocol AJZoomedImageCollectionViewDelegate
@required
- (void)zoomedImagePageViewControllerSwitchedToIndex:(NSUInteger)index;
- (CGRect)returnThumbFrameForIndex:(NSUInteger) index;
@end

@interface AJZoomedImageCollectionViewController : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate, AJZoomedImageSrollViewDelegate>

#pragma mark - Variables
@property (nonatomic, weak)     id zoomedImageCollectionDelegate;
@property (assign, nonatomic)   NSUInteger currentPageIndex;
@property (strong, nonatomic)   IBOutlet UILabel *imageTitle;
@property (strong, nonatomic)   IBOutlet UIPageViewController *imagesPageViewController;

@property (weak, nonatomic)     IBOutlet UIView *imageHeaderViewContainer;
@property (weak, nonatomic)     IBOutlet UIView *imageFooterViewContainer;

@property (weak, nonatomic) IBOutlet UIImageView *footerLeftArrow;
@property (weak, nonatomic) IBOutlet UIImageView *footerRightArrow;
@property (weak, nonatomic) IBOutlet UILabel *footerCurrentIndex;
@property (weak, nonatomic) IBOutlet UILabel *footerTotalImagesCount;


#pragma mark - Functions
+ (AJZoomedImageCollectionViewController *)initWithImageCollection:(AJImageCollection *)imageCollection selectedIndex:(NSUInteger)index delegate:(id)delegate;

@end
