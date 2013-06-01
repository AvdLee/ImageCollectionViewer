
// forward-declaration of delegate-protocol
@protocol MTStatusBarOverlayDelegate;

@interface MTStatusBarOverlay : UIWindow 

@property (nonatomic, strong) UIView *backgroundView;

+ (MTStatusBarOverlay *)sharedInstance;
+ (MTStatusBarOverlay *)sharedOverlay;


@end
