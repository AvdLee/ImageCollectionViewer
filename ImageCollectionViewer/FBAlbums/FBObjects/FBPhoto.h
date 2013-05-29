//
//  FBPhoto.h
//  ImageCollectionViewer
//
//  Created by Antoine van der Lee on 15-05-13.
//  Copyright (c) 2013 Antoine van der Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FBPhoto : NSObject

@property (assign, nonatomic) NSString *photoID;
@property (assign, nonatomic) NSString *name;
@property (assign, nonatomic) NSString *createdTime;

@property (assign, nonatomic) NSString *smallImageURL;
@property (assign, nonatomic) NSString *mediumImageURL;
@property (assign, nonatomic) NSString *largeImageURL;

@property (assign, nonatomic) CGSize smallSize;
@property (assign, nonatomic) CGSize mediumSize;
@property (assign, nonatomic) CGSize largeSize;

@end
