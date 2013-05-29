//
//  AJImageCollection.m
//  ImageCollectionViewer
//
//  Created by Antoine van der Lee on 12-05-13.
//  Copyright (c) 2013 Antoine van der Lee. All rights reserved.
//

#import "AJImageCollection.h"

#pragma mark -

@interface AJImageCollection ()
{
}

@end

@implementation AJImageCollection

@synthesize title, images;

- (id) initWithTitle:(NSString *)collectionTitle {
    self = [super init];
    if (self){
        title = collectionTitle;
        images = [[NSMutableArray alloc] init];
    }
    
    return self;
}
@end
