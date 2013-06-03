#import "AJWindowOverlay.h"

@implementation AJWindowOverlay

+ (AJWindowOverlay *)sharedInstance {
    static dispatch_once_t pred;
    __strong static AJWindowOverlay *sharedOverlay = nil;
    
    dispatch_once(&pred, ^{
        sharedOverlay = [[AJWindowOverlay alloc] init];
    });
    
	return sharedOverlay;
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		// Place the window on the correct level and position
        self.windowLevel = UIWindowLevelStatusBar+1.f;
		self.hidden = NO;
        LogRect([[UIScreen mainScreen] applicationFrame]);
        self.frame = CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height);
        [self setClipsToBounds:YES];
    }
    
	return self;
}

- (void) setRootViewController:(UIViewController *)rootViewController {
    [super setRootViewController:rootViewController];
    [self setHidden:NO];
}

- (void) removeFromView {
    [self.rootViewController.view removeFromSuperview];
    [self setHidden:YES];
}
@end