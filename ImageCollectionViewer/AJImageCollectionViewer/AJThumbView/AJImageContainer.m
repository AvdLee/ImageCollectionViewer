//
//  AJImageContainer.m
//  ImageCollectionViewer
//
//  Created by Antoine van der Lee on 24-04-13.
//  Copyright (c) 2013 Antoine van der Lee. All rights reserved.
//

#import "AJImageContainer.h"
#import <QuartzCore/QuartzCore.h>

@implementation AJImageContainer

@synthesize collectionImageButton;

- (id)initWithImage:(AJImage *)image
{
    if (self = [super initWithNibName:@"AJImageContainer" bundle:nil]) {
        // Custom initialization
        [self setShadowForImageContainer];
        [image setImageToButton:collectionImageButton];
        //[collectionImageButton setImage:[image image]  forState:UIControlStateNormal];
    }
    return self;
}

#pragma mark - Styling methods
- (void) setShadowForImageContainer {
    CALayer* layer = [self.view layer];
    [layer setShadowColor:[UIColor blackColor].CGColor];
    [layer setShadowOffset:CGSizeMake(0.0, 1)];
    [layer setShadowRadius:1.5];
    [layer setShadowOpacity:0.4];
}
@end
