//
//  FBAlbum.h
//  ImageCollectionViewer
//
//  Created by Antoine van der Lee on 14-05-13.
//  Copyright (c) 2013 Antoine van der Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FBAlbum : NSObject

@property (assign, nonatomic) NSString *albumID;
@property (assign, nonatomic) NSString *name;
@property (assign, nonatomic) NSString *createdTime;

@end
