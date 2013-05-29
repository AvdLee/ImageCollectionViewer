//
//  FBAlbumFactory.m
//  ImageCollectionViewer
//
//  Created by Antoine van der Lee on 14-05-13.
//  Copyright (c) 2013 Antoine van der Lee. All rights reserved.
//

#import "FBAlbumFactory.h"
#import "FBPhotoFactory.h"
#import "FBGraphParser.h"

@implementation FBAlbumFactory

+ (FBAlbumCollection *) getAlbumCollectionForPageID:(NSString *)pageID {
    NSDictionary *rawAlbums = [FBGraphParser getAlbumsForPageID:pageID];
    FBAlbumCollection *albumCollection = [self createAlbumCollectionFor: rawAlbums];
    
    return albumCollection;
}

+ (FBAlbumCollection *) createAlbumCollectionFor:(NSDictionary *)albumsDict {
    FBAlbumCollection *tempAlbumCollection = [[FBAlbumCollection alloc] init];
    
    
    
    for (NSDictionary *album in albumsDict){
        if([tempAlbumCollection.albums count] == 1) break;
        FBAlbum *tempAlbum;
        if ((tempAlbum = [self createAlbumFor:album])){
            [tempAlbumCollection.albums addObject:tempAlbum];
        }
    }
    
    NSLog(@"Dictionary: %u", [tempAlbumCollection.albums count]);

    
    return tempAlbumCollection;
}

+ (FBAlbum *) createAlbumFor:(NSDictionary *)albumDict {
    FBAlbum *tempAlbum = [[FBAlbum alloc] init];
    [tempAlbum setAlbumID:albumDict[@"id"]];
    [tempAlbum setName:albumDict[@"name"]];
    [tempAlbum setCreatedTime:albumDict[@"created_time"]];
    return tempAlbum;
}



@end
