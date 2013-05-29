//
//  AJCacheHelper.h
//  ImageCollectionViewer
//
//  Created by Antoine van der Lee on 27-05-13.
//  Copyright (c) 2013 Antoine van der Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AJCacheHelper : NSCache

#pragma mark - Singleton instance
//+ (id)sharedInstance;

#pragma mark - Cache methods
- (UIImage *)cachedImageForURL:(NSURL *)url;
- (void)cacheImage:(UIImage *)image forURL:(NSURL *)url;

@end
