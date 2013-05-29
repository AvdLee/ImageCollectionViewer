//
//  AJDownloadManager.h
//  ImageCollectionViewer
//
//  Created by Antoine van der Lee on 29-05-13.
//  Copyright (c) 2013 Antoine van der Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AJDownloadManager : NSObject

+ (void)getImageFromURL:(NSURL *)imageURL success:(void (^)(UIImage *image))success;

@end
