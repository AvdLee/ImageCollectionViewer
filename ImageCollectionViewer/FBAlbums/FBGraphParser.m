//
//  FBGraphParser.m
//  ImageCollectionViewer
//
//  Created by Antoine van der Lee on 14-05-13.
//  Copyright (c) 2013 Antoine van der Lee. All rights reserved.
//

#import "FBGraphParser.h"

@implementation FBGraphParser

+ (NSDictionary *) getAlbumsForPageID:(NSString *)pageID {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/albums?fields=id,created_time,name",pageID]];
    
    NSData *returnedData = [NSData dataWithContentsOfURL:url];
    NSError *parseError;
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:returnedData options:0 error:&parseError];
    
    if (parseError) return NULL;
    
    NSDictionary *albums = [result objectForKey:@"data"];
    
    return (albums ? albums : NULL);
}

+ (NSDictionary *) getPhotosForAlbumID:(NSString *)albumID {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/photos?fields=id,created_time,name,images",albumID]];
    
    NSData *returnedData = [NSData dataWithContentsOfURL:url];
    NSError *parseError;
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:returnedData options:0 error:&parseError];
    
    if (parseError) return NULL;
    
    NSDictionary *photos = [result objectForKey:@"data"];
    
    return (photos ? photos : NULL);
}

@end
