//
//  AJDownloadManager.m
//  ImageCollectionViewer
//
//  Created by Antoine van der Lee on 29-05-13.
//  Copyright (c) 2013 Antoine van der Lee. All rights reserved.
//

#import "AJDownloadManager.h"
#import "AFHTTPRequestOperation.h"

@implementation AJDownloadManager

+ (void)getImageFromURL:(NSURL *)imageURL success:(void (^)(UIImage *image))success {
    NSURLRequest *request = [NSURLRequest requestWithURL:imageURL];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(responseObject!= NULL){
            if([[[operation.request URL] absoluteString] isEqualToString:[imageURL absoluteString]]){
                success([UIImage imageWithData:responseObject]);
            }
            
        }
        
    } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {

    }];
    
    [operation start];
}

@end
