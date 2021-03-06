//
//  AJZoomedImageSrollView.m
//  ImageCollectionViewer
//
//  Created by Antoine van der Lee on 01-05-13.
//  Copyright (c) 2013 Antoine van der Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "AJZoomedImageSrollView.h"
#import "AJCacheHelper.h"
#import "AJDownloadManager.h"
#import "AJProgressView.h"
#import "UIImageView+AJProgress.h"

#define P(x,y) CGPointMake(x, y)


#pragma mark -

@interface AJZoomedImageSrollView () <UIScrollViewDelegate>
{
    UIImageView *_zoomView;
    AJProgressView *_progressView;

    CGSize      _imageSize;
    BOOL        _zoomed;
    CGPoint     _startPos;
    float       _moved;
    bool        _animatingOut;
    bool        _animatingIn;
    
    CGPoint _pointToCenterAfterResize;
    CGFloat _scaleToRestoreAfterResize;
}

@end

@implementation AJZoomedImageSrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.bouncesZoom = YES;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.delegate = self;
        self.bounces = true;
        self.alwaysBounceHorizontal = NO;
        self.alwaysBounceVertical = YES;
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        [doubleTap setNumberOfTapsRequired:2];
        [self addGestureRecognizer:doubleTap];
    }
    return self;
}

- (void)setImage:(AJImage *)image {
    _image = image;
    
    UIImage *cachedLargeImage = [[AJCacheHelper sharedInstance] cachedImageForURL:[_image largeImgUrl]];
    UIImage *cachedSmallImage = [[AJCacheHelper sharedInstance] cachedImageForURL:[_image smallImgUrl]];
    
    if(cachedLargeImage){
        [self displayImage:cachedLargeImage];
    } else if(cachedSmallImage){
        [self displayImage:cachedSmallImage];
        [self downloadLargeImage];
    } else {
        CGRect viewRect = CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height);
        _progressView = [[AJProgressView alloc] initInCenterOfFrame:viewRect];
        _progressView.tintColor = [UIColor whiteColor];
        [self addSubview:_progressView];
        [self downloadLargeImage];
    }
}

- (void)downloadLargeImage
{
    [AJDownloadManager getImageFromURL:[_image largeImgUrl] progressChange:^(float progress) {
        if(_progressView){
            if(progress == 1){
                [_progressView removeFromSuperview];
            }
            [_progressView setProgress:progress];
        }
    } success:^(UIImage *image) {
        if(!_animatingIn){
            [self displayImage:image];   
        }
    }];
}

- (void)setIndex:(NSUInteger)index
{
    _index = index;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if(_animatingOut) return;
    
    // center the zoom view as it becomes smaller than the size of the screen
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = _zoomView.frame;
    
    // center horizontally
    if (frameToCenter.size.width < boundsSize.width)
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    else
        frameToCenter.origin.x = 0;
    
    // center vertically
    if (frameToCenter.size.height < boundsSize.height)
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    else
        frameToCenter.origin.y = 0;
    
    _zoomView.frame = frameToCenter;
}

- (void)setFrame:(CGRect)frame
{
    BOOL sizeChanging = !CGSizeEqualToSize(frame.size, self.frame.size);
    
    if (sizeChanging) {
        [self prepareToResize];
    }
    
    [super setFrame:frame];
    
    if (sizeChanging) {
        [self recoverFromResizing];
    }
}


#pragma mark - Image Animation methods
- (void) animateImageIn {
    _animatingIn = true;
    
    CGRect endFrame = _zoomView.frame;
    _zoomView.frame = [_zoomedImageScrollViewDelegate returnThumbFrameForIndex:_index];
    
    [self setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.0]];
    [_zoomedImageScrollViewDelegate zoomedImageScrollViewWillBeginAnimating];
    
    [UIView animateWithDuration:0.3 delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:1.0]];
                         _zoomView.frame = endFrame;
                     }
                     completion:^(BOOL finished){
                         _animatingIn = false;
                         
                         UIImage *cachedLargeImage = [[AJCacheHelper sharedInstance] cachedImageForURL:[_image largeImgUrl]];
                         UIImage *cachedSmallImage = [[AJCacheHelper sharedInstance] cachedImageForURL:[_image smallImgUrl]];
                         
                         // If large image is downloaded, but not set yet
                         if(_zoomView.image == cachedSmallImage && cachedLargeImage){
                             [self displayImage:cachedLargeImage];
                         }
                         [_zoomedImageScrollViewDelegate zoomedImageScrollViewDidEndAnimating];
                     }];
}

- (void) animateImageOutAndRemove {
    CGRect thumbFrameWithOffset = [_zoomedImageScrollViewDelegate returnThumbFrameForIndex:_index];
    thumbFrameWithOffset.origin.y = thumbFrameWithOffset.origin.y + self.contentOffset.y;
    
    [UIView animateWithDuration:0.3 delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _zoomView.frame = thumbFrameWithOffset;
                         [self setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.0]];
                     }
                     completion:^(BOOL finished){
                         [_zoomedImageScrollViewDelegate zoomedImageScrolledOut];
                         
                     }];
}


#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _zoomView;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    _zoomed = true;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
    _zoomed = !(scale == self.minimumZoomScale);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if([self zoomed]) return;
    _startPos = scrollView.contentOffset;
    [_zoomedImageScrollViewDelegate zoomedImageScrollViewWillBeginAnimating];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(_animatingOut || [self zoomed]) return;
    float newY = scrollView.contentOffset.y;
    _moved = _startPos.y - newY;
    
    float space = (SCREEN_HEIGHT-_zoomView.frame.size.height)/2;
    float opacity = abs(_moved)/space;
    
    [self setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:(1-opacity)]];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(abs(_moved) > ZOOMED_IMAGE_MOVED_LIMIT){
        _animatingOut = true;
        [self animateImageOutAndRemove];
    } else if(!decelerate) {
        [self setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:1.0]];
        [_zoomedImageScrollViewDelegate zoomedImageScrollViewDidEndAnimating];
    }
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if(_animatingOut){
        [scrollView setContentOffset:scrollView.contentOffset animated:YES];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if(!_animatingOut){
        [_zoomedImageScrollViewDelegate zoomedImageScrollViewDidEndAnimating];
    }
}

#pragma mark - Gesture methods
- (void)handleDoubleTap:(UIGestureRecognizer *)recognizer {
    if(self.minimumZoomScale == self.maximumZoomScale) return;
    
    if (self.zoomScale == self.minimumZoomScale){
        CGPoint pointInView = [recognizer locationInView:_zoomView];
        CGFloat newZoomscal = self.maximumZoomScale;
        
        CGSize scrollViewSize = self.bounds.size;
        
        CGFloat w = scrollViewSize.width / newZoomscal;
        CGFloat h = scrollViewSize.height / newZoomscal;
        CGFloat x = pointInView.x - (scrollViewSize.width/2);
        CGFloat y = pointInView.y - (scrollViewSize.height/2);
        
        CGRect rectTozoom = CGRectMake(x, y, w, h);
        [self zoomToRect:rectTozoom animated:YES];
        
        [self setZoomScale:self.maximumZoomScale animated:YES];
    } else {
        [self setZoomScale:self.minimumZoomScale animated:YES];
    }
}

#pragma mark - Configure scrollView to display new image (tiled or not)
- (void)displayImage:(UIImage *)image
{
    // Set bounds
    self.bounds = self.frame;
    
    // Clear the previous image
    [_zoomView removeFromSuperview];
    _zoomView = nil;
    
    // Reset our zoomScale to 1.0 before doing any further calculations
    self.zoomScale = 1.0;
    
    // Set image to zoomview
    _zoomView = [[UIImageView alloc] initWithImage:image];
    
    // Set zoomView properties
    [_zoomView setContentMode: UIViewContentModeScaleAspectFill];
    [_zoomView setClipsToBounds:YES];
    
    // Add to view
    [self addSubview:_zoomView];
    
    // Configure for size
    [self configureForImageSize:_zoomView.image.size];
}

- (void)configureForImageSize:(CGSize)imageSize
{
    _imageSize = imageSize;
    
    [self setContentSize:imageSize];
    [self setMaxMinZoomScalesForCurrentBounds];
    [self setZoomScale:self.minimumZoomScale];
}

- (void)setMaxMinZoomScalesForCurrentBounds
{
    CGSize boundsSize = self.bounds.size;
    
    // calculate min/max zoomscale
    CGFloat xScale = (boundsSize.width - (ZOOMED_IMAGE_MARGIN_LEFT_RIGHT*2))  / _imageSize.width;    // the scale needed to perfectly fit the image width-wise
    CGFloat yScale = (boundsSize.height - (ZOOMED_IMAGE_MARGIN_TOP_BOTTOM*2)) / _imageSize.height;   // the scale needed to perfectly fit the image height-wise
    
    // Take smallest scale to make sure the image stays in boundaries
    CGFloat minScale = MIN(xScale, yScale);
    
    // Set maxScale to 1.0 for default
    CGFloat maxScale = 1.0;
    
    // If the image is smaller and used for zooming, make sure the maxScale can exceed
    if (minScale > maxScale) {
        maxScale = minScale;
    }
    self.maximumZoomScale = maxScale;
    self.minimumZoomScale = minScale;
}

- (BOOL) zoomed {
    return !(self.minimumZoomScale == self.zoomScale);
}

#pragma mark -
#pragma mark Methods called during rotation to preserve the zoomScale and the visible portion of the image

#pragma mark - Rotation support

- (void)prepareToResize
{
    CGPoint boundsCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    _pointToCenterAfterResize = [self convertPoint:boundsCenter toView:_zoomView];
    
    _scaleToRestoreAfterResize = self.zoomScale;
    
    // If we're at the minimum zoom scale, preserve that by returning 0, which will be converted to the minimum
    // allowable scale when the scale is restored.
    if (_scaleToRestoreAfterResize <= self.minimumZoomScale + FLT_EPSILON)
        _scaleToRestoreAfterResize = 0;
}

- (void)recoverFromResizing
{
    [self setMaxMinZoomScalesForCurrentBounds];
    
    // Step 1: restore zoom scale, first making sure it is within the allowable range.
    CGFloat maxZoomScale = MAX(self.minimumZoomScale, _scaleToRestoreAfterResize);
    self.zoomScale = MIN(self.maximumZoomScale, maxZoomScale);
    //NSLog(@"Zoomscale: %f", self.zoomScale);
    
    // Step 2: restore center point, first making sure it is within the allowable range.
    
    // 2a: convert our desired center point back to our own coordinate space
    CGPoint boundsCenter = [self convertPoint:_pointToCenterAfterResize fromView:_zoomView];
    
    // 2b: calculate the content offset that would yield that center point
    CGPoint offset = CGPointMake(boundsCenter.x - self.bounds.size.width / 2.0,
                                 boundsCenter.y - self.bounds.size.height / 2.0);
    
    // 2c: restore offset, adjusted to be within the allowable range
    CGPoint maxOffset = [self maximumContentOffset];
    CGPoint minOffset = [self minimumContentOffset];
    
    CGFloat realMaxOffset = MIN(maxOffset.x, offset.x);
    offset.x = MAX(minOffset.x, realMaxOffset);
    
    realMaxOffset = MIN(maxOffset.y, offset.y);
    offset.y = MAX(minOffset.y, realMaxOffset);
    
    self.contentOffset = offset;
}

- (CGPoint)maximumContentOffset
{
    CGSize contentSize = self.contentSize;
    CGSize boundsSize = self.bounds.size;
    return CGPointMake(contentSize.width - boundsSize.width, contentSize.height - boundsSize.height);
}

- (CGPoint)minimumContentOffset
{
    return CGPointZero;
}

@end