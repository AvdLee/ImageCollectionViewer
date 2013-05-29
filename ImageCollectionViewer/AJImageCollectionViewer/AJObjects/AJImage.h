//
//  AJImage.h
//  ImageCollectionViewer
//
//  Created by Antoine van der Lee on 12-05-13.
//  Copyright (c) 2013 Antoine van der Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AJImage : NSObject

#pragma mark - Variables
@property (weak, nonatomic) NSString *title;
@property (strong, nonatomic) NSURL *smallImgUrl;
@property (strong, nonatomic) NSURL *largeImgUrl;
@property (assign, nonatomic) CGSize smallSize;
@property (assign, nonatomic) CGSize largeSize;

@property (strong, nonatomic) UIImage *cachedSmallImage;
@property (strong, nonatomic) UIImage *cachedLargeImage;

#pragma mark - Functions
- (id) initWithImageName:(NSString *)imageName;
- (id) initWithSmallImageURL:(NSString *)smallImageURL andLargeImageUrl:(NSString *)largeImageUrl;

- (void) setImageToButton:(UIButton *)button;
//- (void) setImageToUIImageView:(UIImageView *)imageView;

@end
