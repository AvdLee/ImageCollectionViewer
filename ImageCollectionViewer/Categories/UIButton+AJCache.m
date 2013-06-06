//
//  UIButton+AJCache.m
//  ImageCollectionViewer
//
//  Created by Antoine van der Lee on 29-05-13.
//  Copyright (c) 2013 Antoine van der Lee. All rights reserved.
//

#import "UIButton+AJCache.h"
#import "AJDownloadManager.h"

@implementation UIButton (AJCache)

- (void)setImageFromUrl:(NSURL *)url {
    [self.imageView setContentMode: UIViewContentModeScaleAspectFill];

    if(url){
        [self setAlpha:0];
        __weak UIButton *wSelf = self;
        [AJDownloadManager getImageFromURL:url success:^(UIImage *image) {
            [wSelf setImage:image forState:UIControlStateNormal];
            
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                [wSelf setAlpha:1.0];
            } completion: nil];
        }];
    }
}

@end
