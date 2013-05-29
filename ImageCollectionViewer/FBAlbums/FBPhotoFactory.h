//
//  FBPhotoFactory.h
//  ImageCollectionViewer
//
//  Created by Antoine van der Lee on 15-05-13.
//  Copyright (c) 2013 Antoine van der Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBPhoto.h"

@interface FBPhotoFactory : NSObject

+ (NSMutableArray *) getPhotosForAlbumID:(NSString *)albumID;

@end
