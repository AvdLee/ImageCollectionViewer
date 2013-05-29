//
//  AJCacheHelper.m
//  ImageCollectionViewer
//
//  Created by Antoine van der Lee on 27-05-13.
//  Copyright (c) 2013 Antoine van der Lee. All rights reserved.
//

#import "AJCacheHelper.h"

@implementation AJCacheHelper

static AJCacheHelper *sharedInstance = nil;

+ (AJCacheHelper *)sharedInstance {
    if (nil != sharedInstance) {
        return sharedInstance;
    }
    
    static dispatch_once_t pred;        // Lock
    dispatch_once(&pred, ^{             // This code is called at most once per app
        sharedInstance = [[AJCacheHelper alloc] init];
    });
    
    return sharedInstance;
}

- (UIImage *)cachedImageForURL:(NSURL *)url {
    return [self objectForKey:[url absoluteString]];
}

- (void)cacheImage:(UIImage *)image forURL:(NSURL *)url {
    if (image && url) {
        [self setObject:image forKey:[url absoluteString]];
    }
}
@end
