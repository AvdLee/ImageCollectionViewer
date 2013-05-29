//
//  AJImageContainer.h
//  ImageCollectionViewer
//
//  Created by Antoine van der Lee on 24-04-13.
//  Copyright (c) 2013 Antoine van der Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AJImage.h"

@interface AJImageContainer : UIViewController

#pragma mark - Variables
@property (weak, nonatomic) IBOutlet UIButton *collectionImageButton;

#pragma mark - Functions
- (id)initWithImage:(AJImage *)image;
@end
