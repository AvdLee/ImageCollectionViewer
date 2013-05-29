//
//  AJCacheHelper.m
//  ImageCollectionViewer
//
//  Created by Antoine van der Lee on 27-05-13.
//  Copyright (c) 2013 Antoine van der Lee. All rights reserved.
//

#import "AJCacheHelper.h"

@implementation AJCacheHelper

- (UIImage *)cachedImageForURL:(NSURL *)url {
    return [self objectForKey:[url absoluteString]];
}

- (void)cacheImage:(UIImage *)image forURL:(NSURL *)url {
    if (image && url) {
        [self setObject:image forKey:[url absoluteString]];
    }
}
@end
