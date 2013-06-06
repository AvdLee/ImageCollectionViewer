//
//  PhotoViewController.m
//  ImageCollectionViewer
//
//  Created by Antoine van der Lee on 01-05-13.
//  Copyright (c) 2013 Antoine van der Lee. All rights reserved.
//

#import "AJPhotoViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface AJPhotoViewController ()
{
    NSUInteger _pageIndex;
    AJImage *_image;
    AJZoomedImageSrollView *_scrollView;
    __weak id _zoomedImageScrollViewDelegate;
}
@end

@implementation AJPhotoViewController

+ (AJPhotoViewController *)photoViewControllerForImage:(AJImage *)image pageIndex:(NSUInteger)pageIndex andZoomedImageSrollViewDelegate:(id)delegate
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
@end
