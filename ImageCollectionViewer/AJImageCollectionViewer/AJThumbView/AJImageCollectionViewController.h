//
//  AJImageCollectionView.h
//  ImageCollectionViewer
//
//  Created by Antoine van der Lee on 24-04-13.
//  Copyright (c) 2013 Antoine van der Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AJImageContainer.h"
#import "AJImageCollection.h"
#import "AJZoomedImageCollectionViewController.h"

@interface AJImageCollectionViewController : UIViewController <AJZoomedImageCollectionViewDelegate, UIScrollViewDelegate>

#pragma mark - Variables
@property (strong, nonatomic)   IBOutlet UILabel *imageCollectionTitle;
@property (weak, nonatomic)     IBOutlet UIScrollView *imageCollectionScrollView;
@property (strong, nonatomic)   NSMutableDictionary *imageThumbsCollection;
@property (strong, nonatomic)   AJZoomedImageCollectionViewController *zoomedImageCollectionViewController;

#pragma mark - Functions
- (id)initWithImageCollection:(AJImageCollection *)imageCollection;

@end
