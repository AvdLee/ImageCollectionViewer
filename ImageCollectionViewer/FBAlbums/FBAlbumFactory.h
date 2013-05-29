//
//  FBAlbumFactory.h
//  ImageCollectionViewer
//
//  Created by Antoine van der Lee on 14-05-13.
//  Copyright (c) 2013 Antoine van der Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBSettings.h"
#import "FBAlbumCollection.h"
#import "FBAlbum.h"

@interface FBAlbumFactory : NSObject

+ (FBAlbumCollection *) getAlbumCollectionForPageID:(NSString *)pageID;

@end
