//
//  ViewController.m
//  ImageCollectionViewer
//
//  Created by Antoine van der Lee on 24-04-13.
//  Copyright (c) 2013 Antoine van der Lee. All rights reserved.
//

#import "ViewController.h"
#import "AJImage.h"
#import "AJImageCollection.h"
#import "FBAlbumFactory.h"
#import "FBPhotoFactory.h"



@interface ViewController (){
    NSMutableArray *imageCollections;
}

@end

@implementation ViewController

@synthesize albumsScrollview;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //MTStatusBarOverlay *overlay = [MTStatusBarOverlay sharedInstance];
    
    
    imageCollections = [[NSMutableArray alloc] init];
    
    
    /*

    NSArray *imageCollection = @[@"image_1.jpg", @"image_2.jpg", @"image_3.jpg", @"image_4.jpg", @"image_5.jpg"];
    
    AJImageCollection *imageCollectionObjects = [[AJImageCollection alloc] initWithTitle:@"Album #1"];
    
    for(int i=0; i<[imageCollection count]; i++){
        AJImage *image = [[AJImage alloc] initWithImageName:imageCollection[i]];
        [imageCollectionObjects.images addObject:image];
    }

    
    AJImageCollectionViewController *imageCollectionViewController = [[AJImageCollectionViewController alloc] initWithImageCollection:imageCollectionObjects];
    [imageCollectionViewController.view setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    [imageCollections addObject:imageCollectionViewController];
    [self.view addSubview:imageCollectionViewController.view];
    
    // With urls:
    NSArray *imageUrlsCollection = @[@"http://www.nature-pictures.info/wp-content/uploads/2013/03/top-33-most-beautiful-abandoned-places-in-the-world-110.jpg",
                                     @"http://www.nature-pictures.info/wp-content/uploads/2013/03/top-33-most-beautiful-abandoned-places-in-the-world-91.jpg",
                                     @"http://www.nature-pictures.info/wp-content/uploads/2013/03/top-33-most-beautiful-abandoned-places-in-the-world-13.jpg",
                                     @"http://www.nature-pictures.info/wp-content/uploads/2013/03/top-33-most-beautiful-abandoned-places-in-the-world-14.jpg",
                                     @"http://www.nature-pictures.info/wp-content/uploads/2013/03/top-33-most-beautiful-abandoned-places-in-the-world-16.jpg"];
    
    AJImageCollection *imageUrlsCollectionObjects = [[AJImageCollection alloc] initWithTitle:@"Album #2"];
    
    for(int i=0; i<[imageUrlsCollection count]; i++){
        AJImage *image = [[AJImage alloc] initWithImageURL:imageUrlsCollection[i]];
        [imageUrlsCollectionObjects.images addObject:image];
    }
    
    
    imageCollectionViewController = [[AJImageCollectionViewController alloc] initWithImageCollection:imageUrlsCollectionObjects];
    [imageCollectionViewController.view setFrame:CGRectMake(0, imageCollectionViewController.view.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    [imageCollections addObject:imageCollectionViewController];
    [self.view addSubview:imageCollectionViewController.view];*/
    
    //[FBPhotoFactory getPhotosForAlbumID:tempAlbum.albumID]
    
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
   
    [self getAlbums];
}

- (void) getAlbums {
    dispatch_queue_t queue  = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0ul);
    dispatch_async(queue,^{
        
        FBAlbumCollection *albumsCollection = [FBAlbumFactory getAlbumCollectionForPageID:@"jcpardoes"];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            for (FBAlbum *album in [albumsCollection albums]){
                [self getPhotosForAlbum:album];
            }
        });
    });
}

- (void) getPhotosForAlbum:(FBAlbum *)album {
    AJImageCollection *tempImageCollection = [[AJImageCollection alloc] initWithTitle:[album name]];
    
    dispatch_queue_t queue  = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0ul);
    dispatch_async(queue,^{

        NSMutableArray *photos = [FBPhotoFactory getPhotosForAlbumID:[album albumID]];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            for (FBPhoto *photo in photos){
                AJImage *image = [[AJImage alloc] initWithSmallImageURL:[photo mediumImageURL] andLargeImageUrl:[photo largeImageURL]];
                
                [image setSmallSize:[photo smallSize]];
                [image setLargeSize:[photo largeSize]];
                [tempImageCollection.images addObject:image];
            }
            
            [self addAlbumToViewWithCollection:tempImageCollection];
        });
    });
}

- (void) addAlbumToViewWithCollection:(AJImageCollection *)collection {
    AJImageCollectionViewController *tempICVController = [[AJImageCollectionViewController alloc] initWithImageCollection:collection];
    [self.albumsScrollview setContentSize:CGSizeMake(SCREEN_WIDTH, ([imageCollections count] * tempICVController.view.frame.size.height))];
    [tempICVController.view setAlpha:0];
    [tempICVController.view setFrame:CGRectMake(0, ([imageCollections count] * tempICVController.view.frame.size.height), SCREEN_WIDTH, SCREEN_HEIGHT)];
    [imageCollections addObject:tempICVController];
    
    [self.albumsScrollview addSubview:tempICVController.view];
    
    
    [UIView animateWithDuration:0.15
                     animations:^{
                         [tempICVController.view setAlpha:1.0];
                     }];
}

// Older versions of iOS (deprecated) if supporting iOS < 5
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation    {
    return YES;
}

// iOS6
- (BOOL)shouldAutorotate {
    return YES;
}

// iOS6
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

@end
