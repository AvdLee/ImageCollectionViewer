//
//  PhotoViewController.m
//  ImageCollectionViewer
//
//  Created by Antoine van der Lee on 01-05-13.
//  Copyright (c) 2013 Antoine van der Lee. All rights reserved.
//

#import "PhotoViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface PhotoViewController ()
{
    NSUInteger _pageIndex;
    AJImage *_image;
    AJZoomedImageSrollView *_scrollView;
    __weak id _zoomedImageScrollViewDelegate;
}
@end

@implementation PhotoViewController

+ (PhotoViewController *)photoViewControllerForImage:(AJImage *)image pageIndex:(NSUInteger)pageIndex andZoomedImageSrollViewDelegate:(id)delegate
{
    return [[self alloc] initWithImage:image pageIndex:pageIndex andZoomedImageSrollViewDelegate:delegate];
}

- (id)initWithImage:(AJImage *)image pageIndex:(NSUInteger)pageIndex andZoomedImageSrollViewDelegate:(id)delegate
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        _image = image;
        _pageIndex = pageIndex;
        _zoomedImageScrollViewDelegate = delegate;
    }
    return self;
}

- (NSInteger)pageIndex
{
    return _pageIndex;
}

- (void) viewDidAppear:(BOOL)animated {
}

- (void) animateImageIn {
    [_scrollView animateImageIn];
}

- (void)loadView
{
    _scrollView = [[AJZoomedImageSrollView alloc] init];
    _scrollView.image = _image;
    _scrollView.index = _pageIndex;
    _scrollView.zoomedImageScrollViewDelegate = _zoomedImageScrollViewDelegate;
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.view = _scrollView;
}

// (this can also be defined in Info.plist via UISupportedInterfaceOrientations)
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

@end
