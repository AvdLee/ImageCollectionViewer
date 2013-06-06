//
//  UIImageView+AJProgress.m
//  ImageCollectionViewer
//
//  Created by Antoine van der Lee on 04-06-13 (w23).
//  Copyright (c) 2013 Antoine van der Lee. All rights reserved.
//

#import "UIImageView+AJProgress.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIImageView (AJProgress)

- (void)setProgress:(float)progress {
    /*UIProgressView *progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    [progressView setFrame:CGRectMake(0, 0, 400, 20)];
    [self addSubview:progressView];
    [progressView setProgress:progress];*/
    NSLog(@"Setting progress to %f", progress);
    
    
}

@end
