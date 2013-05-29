//
//  AJImageCollection.h
//  ImageCollectionViewer
//
//  Created by Antoine van der Lee on 12-05-13.
//  Copyright (c) 2013 Antoine van der Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AJImageCollection : NSObject
#pragma mark - Variables
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSMutableArray *images;

#pragma mark - Functions
- (id) initWithTitle:(NSString *)title;

@end
