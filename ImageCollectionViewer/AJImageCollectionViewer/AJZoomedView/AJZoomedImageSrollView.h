//
//  AJZoomedImageSrollView.h
//  ImageCollectionViewer
//
//  Created by Antoine van der Lee on 01-05-13.
//  Copyright (c) 2013 Antoine van der Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AJImageCollectionSettings.h"
#import "AJImage.h"

@protocol AJZoomedImageSrollViewDelegate
@required
- (void) zoomedImageScrolledOut;
- (void) zoomedImageScrollViewWillBeginAnimating;
- (void) zoomedImageScrollViewDidEndAnimating;
- (CGRect)returnThumbFrameForIndex:(NSUInteger) index;
@end

@interface AJZoomedImageSrollView : UIScrollView

#pragma mark - Variables
@property (nonatomic)           NSUInteger index;
@property (nonatomic)           AJImage *image;
@property (nonatomic, weak)     id zoomedImageScrollViewDelegate;

#pragma mark - Functions
- (void) animateImageIn;

@end
