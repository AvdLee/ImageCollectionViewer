//
//  PhotoViewController.h
//  ImageCollectionViewer
//
//  Created by Antoine van der Lee on 01-05-13.
//  Copyright (c) 2013 Antoine van der Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AJZoomedImageSrollView.h"
#import "AJImage.h"

@interface AJPhotoViewController : UIViewController

#pragma mark - Variables
- (void) animateImageIn;
- (NSInteger)pageIndex;

#pragma mark - Functions
+ (AJPhotoViewController *)photoViewControllerForImage:(AJImage *)image pageIndex:(NSUInteger)pageIndex andZoomedImageSrollViewDelegate:(id)delegate;



@end

