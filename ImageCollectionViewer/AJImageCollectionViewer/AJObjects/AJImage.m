//
//  AJImage.m
//  ImageCollectionViewer
//
//  Created by Antoine van der Lee on 12-05-13.
//  Copyright (c) 2013 Antoine van der Lee. All rights reserved.
//

#import "AJImage.h"
#import <QuartzCore/QuartzCore.h>

#pragma mark -

@interface AJImage ()
{
    UIImage *image;
}

@end

@implementation AJImage

@synthesize title, smallImgUrl, largeImgUrl;
@synthesize smallSize, largeSize, cachedSmallImage, cachedLargeImage;

#pragma mark - Init methods
- (id) initWithImageName:(NSString *)imageName {
    self = [super init];
    
    if(self){
        image = [UIImage imageNamed:imageName];
        title = imageName;
    }
    
    return self;
}

- (id) initWithSmallImageURL:(NSString *)smallImageURL andLargeImageUrl:(NSString *)largeImageUrl {
    self = [super init];
    
    if(self){
        smallImgUrl = [NSURL URLWithString:smallImageURL];
        largeImgUrl = [NSURL URLWithString:largeImageUrl];
    }
    
    return self;
}

#pragma mark - Image set methods
- (void) setImageToButton:(UIButton *)button {
    [[button imageView] setContentMode: UIViewContentModeScaleAspectFill];
    if(image){
        [button setImage:image forState:UIControlStateNormal];
    } else if(smallImgUrl){
        [button setAlpha:0];
        __weak UIButton *wbutton = button;

        dispatch_async(dispatch_get_global_queue(0,0), ^{
            NSData * data = [[NSData alloc] initWithContentsOfURL: smallImgUrl];
            if ( data == nil )
                return;
            dispatch_async(dispatch_get_main_queue(), ^{
                [wbutton setImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
                [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                    [wbutton setAlpha:1.0];
                } completion: nil];
                cachedSmallImage = [UIImage imageWithData:data];
            });
        });
        
        
        /*[button setImageWithURL:smallImgUrl forState:UIControlStateNormal placeholderImage:nil options:SDWebImageCacheMemoryOnly completed:^(UIImage *_image, NSError *error, SDImageCacheType cacheType)
         {
             if (_image)
             {
                [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                                      [wbutton setAlpha:1.0];
                                  } completion: nil];
                 cachedSmallImage = _image;
             }
         }];*/
    }
}
/*
- (void) setImageToUIImageView:(UIImageView *)imageView {
    if(image){
        [imageView setImage:image];
    } else if(largeImgUrl){
        __weak UIImageView *weakImageView = imageView;
        
        // Set small one first, this one should allready be loaded earlier
        [imageView setImageWithURL:smallImgUrl placeholderImage:nil options:SDWebImageCacheMemoryOnly];
        
        UIProgressView *progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        float pWidth = 100;
        float pHeight = 10;
        CGRect pFrame = CGRectMake((screenSize.width-pWidth)/2, (screenSize.height-pHeight)/2, pWidth, pHeight);
        [progressView setFrame:pFrame];
        NSLog(@"Size width %f and height %f", imageView.frame.size.width, imageView.frame.size.height);

        [progressView setProgress:0.5];
        [imageView addSubview:progressView];
        
        [imageView setImageWithURL:largeImgUrl placeholderImage:nil options:SDWebImageCacheMemoryOnly progress:^(NSUInteger receivedSize, long long expectedSize)
         {
             //float percentDone = (float)receivedSize*200/(receivedSize+expectedSize);
         }
        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType)
         {
             CGRect ivFrame = weakImageView.frame;
             ivFrame.size = weakImageView.image.size;
             [weakImageView setFrame:ivFrame];
         }];
        
        
        //[imageView setImageWithURL:largeImgUrl];
    }
    
    
}*/


@end
