#import "MTStatusBarOverlay.h"
#import <QuartzCore/QuartzCore.h>

// the height of the status bar
//#define kStatusBarHeight 568.f
// width of the screen in portrait-orientation
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
// height of the screen in portrait-orientation
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface MTStatusBarOverlay ()

// selectors
- (void)rotateToStatusBarFrame:(NSValue *)statusBarFrameValue;
- (void)didChangeStatusBarFrame:(NSNotification *)notification;

// returns the current frame for the detail view depending on the interface orientation
- (CGRect)backgroundViewFrameForStatusBarInterfaceOrientation;
@end



@implementation MTStatusBarOverlay

@synthesize backgroundView = backgroundView_;



- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        
        
		// Place the window on the correct level and position
        self.windowLevel = UIWindowLevelStatusBar+1.f;
		//self.alpha = 0.f;
		self.hidden = NO;
                
        // Create view that stores all the content
        CGRect backgroundFrame = [self backgroundViewFrameForStatusBarInterfaceOrientation];
        backgroundView_ = [[UIView alloc] initWithFrame:backgroundFrame];
		backgroundView_.clipsToBounds = YES;
		backgroundView_.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image_1.jpg"]];
        [imageView setFrame:CGRectMake(0, 0, 100, 100)];
        [backgroundView_ addSubview:imageView];
        [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
        [self addSubview:backgroundView_];
        
		// listen for changes of status bar frame
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(didChangeStatusBarFrame:)
													 name:UIApplicationWillChangeStatusBarFrameNotification object:nil];
        
        // initial rotation, fixes the issue with a wrong bar appearance in landscape only mode
        [self rotateToStatusBarFrame:nil];
    }
    
	return self;
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}



////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Rotation
////////////////////////////////////////////////////////////////////////

- (void)didChangeStatusBarFrame:(NSNotification *)notification {
	NSValue * statusBarFrameValue = [notification.userInfo valueForKey:UIApplicationStatusBarFrameUserInfoKey];
    
	// TODO: react on changes of status bar height (e.g. incoming call, tethering, ...)
	// NSLog(@"Status bar frame changed: %@", NSStringFromCGRect([statusBarFrameValue CGRectValue]));
    
	// have to use performSelector to prohibit animation of rotation
	[self performSelector:@selector(rotateToStatusBarFrame:) withObject:statusBarFrameValue afterDelay:0];
}

- (void)rotateToStatusBarFrame:(NSValue *)statusBarFrameValue {
	// current interface orientation
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
	
    
	CGFloat pi = (CGFloat)M_PI;
	if (orientation == UIDeviceOrientationPortrait) {
		self.transform = CGAffineTransformIdentity;
		self.frame = CGRectMake(0.f,0.f,kScreenWidth,kScreenHeight);
	}else if (orientation == UIDeviceOrientationLandscapeLeft) {
		self.transform = CGAffineTransformMakeRotation(pi * (90.f) / 180.0f);
		self.frame = CGRectMake(kScreenWidth - kScreenHeight,0, kScreenHeight, kScreenHeight);
	} else if (orientation == UIDeviceOrientationLandscapeRight) {
		self.transform = CGAffineTransformMakeRotation(pi * (-90.f) / 180.0f);
		self.frame = CGRectMake(0.f,0.f, kScreenHeight, kScreenHeight);
	} else if (orientation == UIDeviceOrientationPortraitUpsideDown) {
		self.transform = CGAffineTransformMakeRotation(pi);
		self.frame = CGRectMake(0.f,kScreenHeight - kScreenHeight,kScreenWidth,kScreenHeight);
	}
    
    self.backgroundView.frame = [self backgroundViewFrameForStatusBarInterfaceOrientation];
}


- (CGRect)backgroundViewFrameForStatusBarInterfaceOrientation{
    
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    return (UIInterfaceOrientationIsLandscape(interfaceOrientation) ?
            CGRectMake(0, 0, kScreenHeight, kScreenWidth) :
            CGRectMake(0, 0, kScreenWidth, kScreenHeight));
}

////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Singleton Definitions
////////////////////////////////////////////////////////////////////////

+ (MTStatusBarOverlay *)sharedInstance {
    static dispatch_once_t pred;
    __strong static MTStatusBarOverlay *sharedOverlay = nil;
    
    dispatch_once(&pred, ^{
        sharedOverlay = [[MTStatusBarOverlay alloc] init];
    });
    
	return sharedOverlay;
}

+ (MTStatusBarOverlay *)sharedOverlay {
	return [self sharedInstance];
}

@end

void mt_dispatch_sync_on_main_thread(dispatch_block_t block) {
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}
