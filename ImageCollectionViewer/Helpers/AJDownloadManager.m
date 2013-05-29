//
//  AJDownloadManager.m
//  ImageCollectionViewer
//
//  Created by Antoine van der Lee on 29-05-13.
//  Copyright (c) 2013 Antoine van der Lee. All rights reserved.
//

#import "AJDownloadManager.h"
#import "AFHTTPRequestOperation.h"
#import "AJCacheHelper.h"

@implementation AJDownloadManager

+ (void)getImageFromURL:(NSURL *)imageURL success:(void (^)(UIImage *image))success {
    // Check if item is in cache
    UIImage *cachedImage = [[AJCacheHelper sharedInstance] cachedImageForURL:imageURL];
    
    if(cachedImage){
        success(cachedImage);
        return;
    }
    
    // Image is not cached, get it
    NSURLRequest *request = [NSURLRequest requestWithURL:imageURL];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(responseObject!= NULL){
            if([[[operation.request URL] absoluteString] isEqualToString:[imageURL absoluteString]]){
                UIImage *image = [UIImage imageWithData:responseObject];
                
                // Set cached item
                [[AJCacheHelper sharedInstance] cacheImage:image forURL:[operation.request URL]];
                
                success(image);
            }
            
        }
        
    } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {

    }];
    
    [operation start];
}

@end
