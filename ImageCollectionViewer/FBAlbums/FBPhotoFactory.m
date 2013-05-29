//
//  FBPhotoFactory.m
//  ImageCollectionViewer
//
//  Created by Antoine van der Lee on 15-05-13.
//  Copyright (c) 2013 Antoine van der Lee. All rights reserved.
//

#import "FBPhotoFactory.h"
#import "FBGraphParser.h"

@implementation FBPhotoFactory

+ (NSMutableArray *) getPhotosForAlbumID:(NSString *)albumID {
    NSDictionary *rawPhotos = [FBGraphParser getPhotosForAlbumID:albumID];
    NSMutableArray *photos = [self creatPhotosCollectionFor:rawPhotos];
    
    return photos;
}

+ (NSMutableArray *) creatPhotosCollectionFor:(NSDictionary *)photosDict {
    NSMutableArray *tempPhotosCollection = [[NSMutableArray alloc] init];
    
    for (NSDictionary *photo in photosDict){
        FBPhoto *tempPhoto;
        if ((tempPhoto = [self createPhotoFor:photo])){
            [tempPhotosCollection addObject:tempPhoto];
        }
    }
    
    return tempPhotosCollection;
}

+ (FBPhoto *) createPhotoFor:(NSDictionary *)photosDict {
    FBPhoto *tempPhoto = [[FBPhoto alloc] init];
    [tempPhoto setPhotoID:photosDict[@"id"]];
    [tempPhoto setName:photosDict[@"name"]];
    [tempPhoto setCreatedTime:photosDict[@"created_time"]];
    
    NSArray *imagesDict = photosDict[@"images"];
    int smallIndex = [imagesDict count]-1;
    int mediumIndex = [imagesDict count]/2;
    int largeIndex = 0;
    
    // set image urls
    [tempPhoto setSmallImageURL:imagesDict[smallIndex][@"source"]];
    [tempPhoto setMediumImageURL:imagesDict[mediumIndex][@"source"]];
    [tempPhoto setLargeImageURL:imagesDict[largeIndex][@"source"]];
    
    // set image sizes
    [tempPhoto setSmallSize:[self imageSizeForIndex:smallIndex imagesDict:imagesDict]];
    [tempPhoto setMediumSize:[self imageSizeForIndex:mediumIndex imagesDict:imagesDict]];
    [tempPhoto setLargeSize:[self imageSizeForIndex:largeIndex imagesDict:imagesDict]];
    
    return tempPhoto;
}

+ (CGSize) imageSizeForIndex:(int)index imagesDict:(NSArray *)imagesDict {
    float width = [imagesDict[index][@"width"] floatValue];
    float height = [imagesDict[index][@"height"] floatValue];
    return CGSizeMake(width, height);
}

@end
