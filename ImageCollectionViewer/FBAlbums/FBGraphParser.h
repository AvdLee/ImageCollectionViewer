//
//  FBGraphParser.h
//  ImageCollectionViewer
//
//  Created by Antoine van der Lee on 14-05-13.
//  Copyright (c) 2013 Antoine van der Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBSettings.h"

@interface FBGraphParser : NSObject

+ (NSDictionary *) getAlbumsForPageID:(NSString *)pageID;
+ (NSDictionary *) getPhotosForAlbumID:(NSString *)albumID;

@end
