//
//  FBAlbumCollection.m
//  ImageCollectionViewer
//
//  Created by Antoine van der Lee on 14-05-13.
//  Copyright (c) 2013 Antoine van der Lee. All rights reserved.
//

#import "FBAlbumCollection.h"

@implementation FBAlbumCollection

@synthesize albums = _albums;

- (NSMutableArray *)albums {
    if (!_albums) _albums = [[NSMutableArray alloc] init];
    return _albums;
}

@end
